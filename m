Return-Path: <linux-kernel-owner+w=401wt.eu-S932480AbYEFTio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbYEFTio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 15:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758777AbYEFTif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 15:38:35 -0400
Received: from aun.it.uu.se ([130.238.12.36]:37636 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241AbYEFTid convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 15:38:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <18464.46000.226753.230481@alkaid.it.uu.se>
Date: Tue, 6 May 2008 21:38:24 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: David Miller <davem@davemloft.net>
Cc: mikpe@it.uu.se, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.26-rc1 hangs during boot on UltraSPARC 5
In-Reply-To: <20080506.010523.113767579.davem@davemloft.net>
References: <18464.3741.133714.308327@harpo.it.uu.se>
	<20080506.010523.113767579.davem@davemloft.net>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:
 > From: Mikael Pettersson <mikpe@it.uu.se>
 > Date: Tue, 6 May 2008 09:54:05 +0200
 > 
 > > OF stdout device is: /pci@1f,0/pci@1,1/SUNW,m64B@2
 > > PROM: Built device tree with 46848 bytes of memory.
 > > On node 0 totalpages: 32298
 > >   Normal zone: 335 pages used for memmap
 > >   Normal zone: 0 pages reserved
 > >   Normal zone: 31963 pages, LIFO batch:7
 > >   Movable zone: 0 pages used for memmap
 > > Booting Linux...
 > > Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 31963
 > > Kernel command line: ro root=/dev/sda5
 > > PID hash table entries: 1024 (order: 10, 8192 bytes)
 > > clocksource: mult[28000] shift[16]
 > > clockevent: mult[66666666] shift[32]
 > > Console: colour dummy device 80x25
 > > console handover: boot [earlyprom0] -> real [tty0]
 > > 
 > > *** 2.6.26-rc1 gets as far as the line above, then hangs
 > 
 > It's possible your machine does boot up all the way.
 > The video driver simply isn't registerring for whatever
 > reason.
 > 
 > Can you ping the box if you wait a minute or two after the
 > messages stop?

No joy, it's dead.

 > The only patch to the aty driver since 2.6.25 is the
 > following, below, which you can try reverting.
 > 
 > Another thing you can do is edit arch/sparc64/kernel/setup.c
 > and in the prom_early_console struct initializer, remove the
 > "CON_BOOT" bit from the .flags setting.  That will keep the
 > PROM console enabled even when another console wants to
 > register.  We'll get more messages that way.

I removed "| CON_BOOT" and got what looks like the same oops
Raúl Porcel reported earlier today (which he for some reason
sent only to the lists, not to you or me); his oops was:

[    0.760209] NET: Registered protocol family 1
[    0.808403] Unpacking initramfs...<1>Unable to handle kernel paging 
request at virtual address 00
[    0.928065] tsk->{mm,active_mm}->context = 0000000000000000
[    0.996069] tsk->{mm,active_mm}->pgd = fffff8003f4217d4
[    1.060074]               \|/ ____ \|/
[    1.060079]               "@'/ .. \`@"
[    1.060082]               /_| \__/ |_\
[    1.060086]                  \__U_/
[    1.236087] swapper(1): Oops [#1]
[    1.276091] TSTATE: 0000000080001606 TPC: 00000000007fad00 TNPC: 
00000000007fad04 Y: 00000041   W
[    1.400109] TPC: <unpack_to_rootfs+0xac/0xa28>
[    1.452097] g0: 0000000000000001 g1: 0000000000000001 g2: 
0000000000000001 g3: 0000000000000000
[    1.556104] g4: fffff8003e02d860 g5: 0000000000000000 g6: 
fffff8003e03c000 g7: 0000000000000000
[    1.660111] o0: fffff8003e160000 o1: 00000000000000d0 o2: 
0000000000000001 o3: 0000000000000001
[    1.764117] o4: 0000000000000000 o5: 00000000bde9fd0b sp: 
fffff8003e03f431 ret_pc: 00000000007fac
[    1.876125] RPC: <unpack_to_rootfs+0x58/0xa28>
[    1.928127] l0: 00000000007c2800 l1: 0000000000814400 l2: 
0000000000814400 l3: 0000000000000000
[    2.032134] l4: 0000000000000001 l5: 00000000007e4350 l6: 
fffff8003e11a420 l7: 000000000076b360
[    2.136141] i0: 000000003f800000 i1: 00000000000b864f i2: 
0000000000814400 i3: fffff8003e1becc0
[    2.240147] i4: 00000000000003f7 i5: 00000000007ed400 i6: 
fffff8003e03f4f1 i7: 00000000007fb6e0
[    2.344155] I7: <populate_rootfs+0x64/0xac>
[    2.396155] Caller[00000000007fb6e0]: populate_rootfs+0x64/0xac
[    2.466224] Caller[00000000007f819c]: kernel_init+0xac/0x208
[    2.534229] Caller[0000000000426cf8]: kernel_thread+0x38/0x48
[    2.602233] Caller[00000000006d1d34]: rest_init+0x18/0x60
[    2.666238] Instruction DUMP: 03002050  10680243  c07063a0 <c24e0000> 
05002051  80a06030  124800
[    2.796183] Kernel panic - not syncing: Attempted to kill init!
[    2.864187] Press Stop-A (L1-A) to return to the boot prom

I got the oops in the same location (unpack_to_rootfs) with the
same call stack, only the code addresses differ.
Also, the data address my kernel oopsed on was 0000000010800000,
which was the physical address of the initrd.

/Mikael
