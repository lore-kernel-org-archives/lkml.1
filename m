Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbZKVRzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbZKVRzX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 12:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755422AbZKVRzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 12:55:23 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:64861 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbZKVRzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 12:55:21 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+G4yIiHcTY4aDzLum15rfd
Date: Sun, 22 Nov 2009 09:55:24 -0800
From: Tony Lindgren <tony@atomide.com>
To: Chris Banker <cbanker@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org
Subject: Re: NULL pointer dereference with 2.6.31 on OMAP243
Message-ID: <20091122175523.GA4860@atomide.com>
References: <65dfecfd0911191234s585182c3sf88aaebcbd1ccd56@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <65dfecfd0911191234s585182c3sf88aaebcbd1ccd56@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi,

Added linux-omap list and Paul to Cc.

* Chris Banker <cbanker@gmail.com> [091119 12:34]:
> I'm having trouble with the 2.6.31 kernel running on an OMAP2430
> board.  I was able to get the board to boot using 2.6.31rc1, but am
> having some issue with 2.6.31.
> 
> With low-level debugging enabled, I get the output below.  It appears
> to be an issue with the new hwmod system, which didn't exist in
> 2.6.31rc1.  It seems to die during the initialization of mpu_hwmod.
> 
> Anyone have any suggestions as to how to fix this or what to try?

Good to hear somebody is playing with a 2430 :) What's the board
you're using? I guess it is not an SDP based on the crystal rate at
19.2MHz?

We had a similar issue with 2420, that got fixed by
a7f20b2695eb6a00a5464089bacf75b8ed64725e.

Maybe give it a try and see if it helps? I've attached Paul's patch
too for reference.

Regards,

Tony

 
> Thanks,
> Chris
> 
> ------------------------------------------------------------------------------------------------------------------------------------------------------
> 
> Starting kernel ...
> 
> Uncompressing Linux.....................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................
> done, booting the kernel.
> <5>Linux version 2.6.31-omap1 (cbanker@vcaeng05) (gcc version 4.3.3
> (GCC) ) #27 Wed Nov 18 17:23:18 PST 2009
> CPU: ARMv6-compatible processor [4107b366] revision 6 (ARMv6TEJ), cr=00c5387f
> CPU: VIPT aliasing data cache, VIPT aliasing instruction cache
> Machine: BFT Digital Modem
> Memory policy: ECC disabled, Data cache writeback
> <7>On node 0 totalpages: 32768
> <7>free_area_init_node: node 0, pgdat c0f10848, node_mem_map c0f35000
> <7>  Normal zone: 256 pages used for memmap
> <7>  Normal zone: 0 pages reserved
> <7>  Normal zone: 32512 pages, LIFO batch:7
> <6>OMAP2430<6>
> <6>SRAM: Mapped pa 0x40200000 to va 0xe3000000 size: 0x100000
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32512
> <5>Kernel command line: root=/dev/ram0 rw console=ttys2,115200n8
> PID hash table entries: 512 (order: 9, 2048 bytes)
> <6>Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
> <6>Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
> <6>Memory: 128MB = 128MB total
> <5>Memory: 114232KB available (3084K code, 327K data, 12124K init, 0K highmem)
> <6>NR_IRQS:384
> <6>Clocking rate (Crystal/DPLL/MPU): 19.2/660/330 MHz
> <1>Unable to handle kernel NULL pointer dereference at virtual address 00000004
> <1>pgd = c0004000
> <1>[00000004] *pgd=00000000
> Internal error: Oops: 5 [#1]
> <d>Modules linked in:
> CPU: 0    Not tainted  (2.6.31-omap1 #27)
> PC is at _enable+0x78/0x208
> LR is at release_console_sem+0x1a8/0x204
> pc : [<c0be9098>]    lr : [<c0bff998>]    psr: a00001d3
> sp : c0ee3f38  ip : c0ee3e80  fp : c0ee3f4c
> r10: 80022140  r9 : 4107b366  r8 : 80022174
> r7 : c0ee86b4  r6 : c0be95cc  r5 : c0ee6154  r4 : c0ee6154
> r3 : 00000000  r2 : 00000000  r1 : 000005b2  r0 : 0000001f
> Flags: NzCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
> Control: 00c5387f  Table: 80004000  DAC: 00000017
> Process swapper (pid: 0, stack limit = 0xc0ee2260)
> Stack: (0xc0ee3f38 to 0xc0ee4000)
> 3f20:                                                       c0ee6634 c0ee6154
> 3f40: c0ee3f68 c0ee3f50 c0be9648 c0be902c 00000000 c0ee6154 c0be95cc c0ee3f88
> 3f60: c0ee3f6c c0be8a6c c0be95d8 c0eece48 c0eece48 c0bdbe08 c0ee5b34 c0ee3f98
> 3f80: c0ee3f8c c0be98f4 c0be8a44 c0ee3fb0 c0ee3f9c c000dfc4 c0be98a0 c0f11190
> 3fa0: c0f11184 c0ee3fc0 c0ee3fb4 c000ef0c c000df50 c0ee3fd0 c0ee3fc4 c000b878
> 3fc0: c000eee8 c0ee3ff4 c0ee3fd4 c0008a2c c000b84c c0008658 c0bdbe08 00c5387d
> 3fe0: c0f11440 c0bdc20c 00000000 c0ee3ff8 80008034 c00088fc 00000000 00000000
> Backtrace:
> [<c0be9020>] (_enable+0x0/0x208) from [<c0be9648>] (_setup+0x7c/0xb0)
>  r4:c0ee6154
> [<c0be95cc>] (_setup+0x0/0xb0) from [<c0be8a6c>] (omap_hwmod_for_each+0x34/0x78)
>  r6:c0be95cc r5:c0ee6154 r4:00000000
> [<c0be8a38>] (omap_hwmod_for_each+0x0/0x78) from [<c0be98f4>]
> (omap_hwmod_late_init+0x60/0x8c)
>  r7:c0ee5b34 r6:c0bdbe08 r5:c0eece48 r4:c0eece48
> [<c0be9894>] (omap_hwmod_late_init+0x0/0x8c) from [<c000dfc4>]
> (omap2_init_common_hw+0x80/0xbc)
> [<c000df44>] (omap2_init_common_hw+0x0/0xbc) from [<c000ef0c>]
> (omap2430bft_init_irq+0x30/0x1c4)
>  r5:c0f11184 r4:c0f11190
> [<c000eedc>] (omap2430bft_init_irq+0x0/0x1c4) from [<c000b878>]
> (init_IRQ+0x38/0x44)
> [<c000b840>] (init_IRQ+0x0/0x44) from [<c0008a2c>] (start_kernel+0x13c/0x2ac)
> [<c00088f0>] (start_kernel+0x0/0x2ac) from [<80008034>] (0x80008034)
>  r6:c0bdc20c r5:c0f11440 r4:00c5387d
> Code: 0a000005 e5933020 e592205c e593305c (e5920004)
> <4>---[ end trace 1b75b31a2719ed1c ]---
> <0>Kernel panic - not syncing: Attempted to kill the idle task!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--UugvWAfsgieZRqgk
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="24xx-clock-pointer.patch"

commit a7f20b2695eb6a00a5464089bacf75b8ed64725e
Author: Paul Walmsley <paul@pwsan.com>
Date:   Wed Oct 14 16:40:37 2009 -0600

    OMAP2xxx clock: set up clockdomain pointer in struct clk
    
    clock24xx.c is missing a omap2_init_clk_clkdm() in its
    omap2_clk_init() function.  Among other bad effects, this causes the
    OMAP hwmod layer to oops on boot.
    
    Thanks to Carlos Aguiar <carlos.aguiar@indt.org.br> and Stefano
    Panella <Stefano.Panella@csr.com> for reporting this bug.  Thanks to Tony
    Lindgren <tony@atomide.com> for N800 booting advice.
    
    Signed-off-by: Paul Walmsley <paul@pwsan.com>
    Cc: Carlos Aguiar <carlos.aguiar@indt.org.br>
    Cc: Stefano Panella <Stefano.Panella@csr.com>
    Cc: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/mach-omap2/clock24xx.c b/arch/arm/mach-omap2/clock24xx.c
index bc5d3ac..e2dbedd 100644
--- a/arch/arm/mach-omap2/clock24xx.c
+++ b/arch/arm/mach-omap2/clock24xx.c
@@ -769,6 +769,7 @@ int __init omap2_clk_init(void)
 		if (c->cpu & cpu_mask) {
 			clkdev_add(&c->lk);
 			clk_register(c->lk.clk);
+			omap2_init_clk_clkdm(c->lk.clk);
 		}
 
 	/* Check the MPU rate set by bootloader */

--UugvWAfsgieZRqgk--
