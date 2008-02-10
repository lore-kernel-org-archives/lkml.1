Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbYBJCrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbYBJCrB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 21:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987AbYBJCqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 21:46:48 -0500
Received: from rfc2324.org ([89.149.194.216]:40380 "EHLO rfc2324.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986AbYBJCqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 21:46:46 -0500
Date: Sun, 10 Feb 2008 03:46:33 +0100
From: Maximilian Wilhelm <max@rfc2324.org>
To: Krzysztof Oledzki <olel@ans.pl>, max@rfc2324.org,
       linux-kernel@vger.kernel.org, Eric.Moore@lsi.com
Subject: Re: Kernel Panic in MPT SAS on 2.6.24 (and 2.6.23.14, 2.6.23.9)
Message-ID: <20080210024633.GA20450@outback.rfc2324.org>
Mail-Followup-To: Krzysztof Oledzki <olel@ans.pl>, max@rfc2324.org,
	linux-kernel@vger.kernel.org, Eric.Moore@lsi.com
References: <20080206210426.GD11236@outback.rfc2324.org> <47AB82DD.90201@ans.pl> <20080208012028.GF11236@outback.rfc2324.org> <20080208014805.GG11236@outback.rfc2324.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080208014805.GG11236@outback.rfc2324.org>
X-Operating-System: Linux 2.6.23.9-grsec auf i686
X-Warning: This message may contain ironic / sarcastic elements.
X-GC-3.12: GCM/CS/IT d+(--) s+: a-- C++>$ UL++++$ US>++++ P++ L+++>++++ E--- W+ N o+ K- w O? M? V? PS+ PE Y+ PGP++ t 5? X- R tv b+(++) DI+(++) !D G++ e>+++  h!>--(---) r++ y+
X-message-Flag: Outlook: A programm to spread viri, but it can mail, too.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Friday, den  8 February hub Maximilian Wilhelm folgendes in die Tasten:

> Just noticed that Eric's address was wrong, so resend with corrected Cc.

> Eric, my intial report was http://lkml.org/lkml/2008/2/6/300
> 
> > Am Thursday, den  7 February hub Krzysztof Oledzki folgendes in die Tasten:
> > 
> > Hi!
> > 
> > > >While installing my new firewall I got the following kernel panic in
> > > >the MPT SAS driver which I need for the disks.
> > 
> > > >The first kernel I bootet was 2.6.23.14 which did panic so I tried a
> > > >2.6.24 which panics, too. Our usual FAI kernel (2.6.23.9) is also
> > > >affected.
> > 
> > > Could you please try 2.6.22-stable?
> > 
> > Yes it works :-/
> > 
> > I've put some things which on the web which might be helpful:
> > 
> > dmesg		http://files.rfc2324.org/mptsas_panic/2.6.22-dmesg
> > lspci -v	http://files.rfc2324.org/mptsas_panic/2.6.22-lspci-v
> > .config		http://files.rfc2324.org/mptsas_panic/2.6.22-config
> > 
> > I'll search for the last working kernel and try to break it down to a
> > commit tommorow when I can get a serial console or direct access.
> > The Java driven console redirection is everything else than fulfilling :-(
> > 
> > > It looks *very* similar to my problem:
> > 
> > > http://bugzilla.kernel.org/show_bug.cgi?id=9909
> > 
> > It seems to be the same controller:
> > 
> > 01:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068E PCI-Express Fusion-MPT SAS (rev 08)
> > 	Subsystem: Dell Unknown device 1f10
> > 	Flags: bus master, fast devsel, latency 0, IRQ 16
> > 	I/O ports at ec00 [size=256]
> > 	Memory at fc8fc000 (64-bit, non-prefetchable) [size=16K]
> > 	Memory at fc8e0000 (64-bit, non-prefetchable) [size=64K]
> > 	Expansion ROM at fc900000 [disabled] [size=1M]
> > 	Capabilities: [50] Power Management version 2
> > 	Capabilities: [68] Express Endpoint IRQ 0
> > 	Capabilities: [98] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
> > 	Capabilities: [b0] MSI-X: Enable- Mask- TabSize=1

I did a git bisect between v2.6.22 v2.6.23 and it seems that
  6cb8f91320d3e720351c21741da795fed580b21b
introduced some badness.

---snip---
Fusion MPT base driver 3.04.05
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SAS Host driver 3.04.05
mptbase: Initiating ioc0 bringup
ioc0: SAS1068E: Capabilities={Initiator}
scsi0 : ioc0: LSISAS1068E, FwRev=00142e00h, Ports=1, MaxQ=511, IRQ=16
scsi 0:0:0:0: Direct-Access     SEAGATE  ST973402SS       S207 PQ: 0 ANSI: 5
scsi 0:0:1:0: Direct-Access     SEAGATE  ST973402SS       S207 PQ: 0 ANSI: 5
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000028
 printing eip:
c014b8ca
*pde = 00000000
Oops: 0000 [#1]
SMP 
Modules linked in:
CPU:    6
EIP:    0060:[<c014b8ca>]    Not tainted VLI
EFLAGS: 00010046   (2.6.22-g6cb8f913 #13)
EIP is at __kmalloc+0x35/0x5f
eax: 00000006   ebx: 00000246   ecx: c03fa820   edx: 000000d0
esi: 00000010   edi: 00000000   ebp: c23a4000   esp: c2143dbc
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process swapper (pid: 1, ti=c2142000 task=c2141670 task.ti=c2142000)
Stack: c22a3e80 00000000 c013cba9 c22a3e80 c22a3e80 c2399800 00000000 c02bcb67 
       00000020 c2399800 00100100 00200200 00000000 00200200 fffefe48 c02ba15d 
       c2399800 c2190000 c2143e1c 023a4000 00000001 0000ffff 000a0001 c02b0000 
Call Trace:
 [<c013cba9>] __kzalloc+0xd/0x34
 [<c02bcb67>] mptsas_sas_expander_pg0+0x110/0x181
 [<c02ba15d>] mpt_timer_expired+0x0/0x28
 [<c02b0000>] megasas_lookup_instance+0x9/0x2e
 [<c02bd2ff>] mptsas_probe_expander_phys+0x42/0x395
 [<c02ba15d>] mpt_timer_expired+0x0/0x28
 [<c02ba15d>] mpt_timer_expired+0x0/0x28
 [<c02be9b0>] mptsas_probe+0x309/0x387
 [<c021cf6e>] pci_device_probe+0x36/0x57
 [<c023f8a6>] driver_probe_device+0xe1/0x15f
 [<c034c3fd>] klist_next+0x4b/0x6b
 [<c023f9b6>] __driver_attach+0x0/0x79
 [<c023f9fc>] __driver_attach+0x46/0x79
 [<c023ee7b>] bus_for_each_dev+0x33/0x55
 [<c023f70a>] driver_attach+0x16/0x18
 [<c023f9b6>] __driver_attach+0x0/0x79
 [<c023f15f>] bus_add_driver+0x6d/0x16d
 [<c021d0aa>] __pci_register_driver+0x48/0x74
 [<c043e7e4>] kernel_init+0x14a/0x2ac
 [<c0102402>] ret_from_fork+0x6/0x1c
 [<c043e69a>] kernel_init+0x0/0x2ac
 [<c043e69a>] kernel_init+0x0/0x2ac
 [<c01030d7>] kernel_thread_helper+0x7/0x10
 =======================
Code: 3f c0 85 c0 75 05 eb 1a 83 c1 0c 3b 01 77 f9 f6 c2 01 74 05 8b 71 08 eb 03 8b 71 04 31 c0 85 f6 74 30 9c 5b fa 64 a1 08 b0 46 c0 <8b> 0c 86 83 39 00 74 12 c7 41 0c 01 00 00 00 8b 01 48 89 01 8b 
EIP: [<c014b8ca>] __kmalloc+0x35/0x5f SS:ESP 0068:c2143dbc
---snip---

A simple git revert did not work on the current git and I don't want
to fiddle around in this area, so I couldn't test further.

Ciao
Max
-- 
	Follow the white penguin.
