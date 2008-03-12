Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbYCLJa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbYCLJa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 05:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYCLJav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 05:30:51 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:46531 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbYCLJau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 05:30:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:user-agent;
	b=L+//kBbmoGV+V3HC6dSPwgn+FpebmT0F6ko9G319Oo/+ltkRCy8ADEr7T/t4/
	GOummX+hgcxxqFInRK1NaO/iQ==
Date: Wed, 12 Mar 2008 10:30:45 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-kernel@vger.kernel.org
Cc: Chris Wedgwood <cw@f00f.org>, David Brownell <david-b@pacbell.net>,
       Rabeeh Khoury <rabeeh@marvell.com>
Subject: ehci watchdog-related splatter in 2.6.25-rc4
Message-ID: <20080312093045.GA24017@xi.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems like EHCI IRQ firing while ehci_iaa_watchdog() is running.

This is on the integrated EHCI controller of an ARM SoC, the workload
is pumping a lot of data through an USB-ethernet dongle.

Chris (CC) is seeing similar oopsen on x86.


Unable to handle kernel NULL pointer dereference at virtual address 00000060
pgd = ef524000
[00000060] *pgd=2ce44031, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1] PREEMPT
Modules linked in:
CPU: 0    Not tainted  (2.6.25-rc4 #347)
PC is at end_unlink_async+0x1c/0x13c
LR is at end_unlink_async+0x1c/0x13c
pc : [<c0284440>]    lr : [<c0284440>]    psr: 60000093
sp : ecdafe08  ip : ecdafe08  fp : ecdafe24
r10: efe72800  r9 : ecdae000  r8 : 00000021
r7 : 00000010  r6 : 00000000  r5 : efe728c0  r4 : 00000000
r3 : 00000000  r2 : ecdae000  r1 : efe72800  r0 : 00000000
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0005317f  Table: 2f524000  DAC: 00000015
Process yumdownloader (pid: 1159, stack limit = 0xecdae268)
Stack: (0xecdafe08 to 0xecdb0000)
fe00:                   000080a9 efe728c0 00000000 00000010 ecdafe4c ecdafe28 
fe20: c0288284 c0284434 efe72800 00000000 00000000 00000010 00000103 4015e200 
fe40: ecdafe64 ecdafe50 c02764e8 c0288210 1dcd6500 efe75860 ecdafe84 ecdafe68 
fe60: c0065f64 c02764bc ecdae000 c0401b90 00000010 efe75860 ecdafea4 ecdafe88 
fe80: c0067db8 c0065f30 00000010 c0401b90 ecdaffb0 00000104 ecdafec4 ecdafea8 
fea0: c0022048 c0067cf8 ffd3a1cc ffffffff fe400200 0000000f ecdaff24 ecdafec8 
fec0: c0022668 c0022010 00000000 ffd3a180 ffd3a1cc ecdae010 efe728c0 60000013 
fee0: ecdae000 c02880ec 00000000 ecdae000 4015e200 ecdaff24 ecdafef0 ecdaff10 
ff00: c0284484 c0288174 60000013 ffffffff 00000102 c041f2c0 ecdaff54 ecdaff28 
ff20: c00489e0 c02880fc ecdaff28 ecdaff28 ecdaff54 00000005 c041f0e4 00000009 
ff40: 00000001 00000000 ecdaff74 ecdaff58 c0043f78 c004887c ecdae000 ecdae000 
ff60: c0401b90 00000000 ecdaff8c ecdaff78 c00443b8 c0043f28 00000000 00000010 
ff80: ecdaffac ecdaff90 c002204c c0044378 00000000 ffffffff fe400200 0000000f 
ffa0: 00000000 ecdaffb0 c0022890 c0022010 403b8760 401612a8 000251eb 00000002 
ffc0: 403b8760 403b88f0 00000000 403b1c60 00000002 40167e6c 4015e200 4016c1d8 
ffe0: 403b1c60 bedbfab8 4016b82c 400a13b4 20000010 ffffffff feedfeed feedfeed 
Backtrace: 
[<c0284424>] (end_unlink_async+0x0/0x13c) from [<c0288284>] (ehci_irq+0x84/0x1b0)
 r7:00000010 r6:00000000 r5:efe728c0 r4:000080a9
[<c0288200>] (ehci_irq+0x0/0x1b0) from [<c02764e8>] (usb_hcd_irq+0x3c/0x8c)
[<c02764ac>] (usb_hcd_irq+0x0/0x8c) from [<c0065f64>] (handle_IRQ_event+0x44/0x84)
 r4:efe75860
[<c0065f20>] (handle_IRQ_event+0x0/0x84) from [<c0067db8>] (handle_level_irq+0xd0/0x158)
 r7:efe75860 r6:00000010 r5:c0401b90 r4:ecdae000
[<c0067ce8>] (handle_level_irq+0x0/0x158) from [<c0022048>] (__exception_text_start+0x48/0x64)
 r7:00000104 r6:ecdaffb0 r5:c0401b90 r4:00000010
[<c0022000>] (__exception_text_start+0x0/0x64) from [<c0022668>] (__irq_svc+0x48/0x88)
Exception stack(0xecdafec8 to 0xecdaff10)
fec0:                   00000000 ffd3a180 ffd3a1cc ecdae010 efe728c0 60000013 
fee0: ecdae000 c02880ec 00000000 ecdae000 4015e200 ecdaff24 ecdafef0 ecdaff10 
ff00: c0284484 c0288174 60000013 ffffffff                                     
 r6:0000000f r5:fe400200 r4:ffffffff
[<c02880ec>] (ehci_iaa_watchdog+0x0/0xb4) from [<c00489e0>] (run_timer_softirq+0x174/0x220)
 r5:c041f2c0 r4:00000102
[<c004886c>] (run_timer_softirq+0x0/0x220) from [<c0043f78>] (__do_softirq+0x60/0xd4)
 r8:00000000 r7:00000001 r6:00000009 r5:c041f0e4 r4:00000005
[<c0043f18>] (__do_softirq+0x0/0xd4) from [<c00443b8>] (irq_exit+0x50/0x9c)
 r6:00000000 r5:c0401b90 r4:ecdae000
[<c0044368>] (irq_exit+0x0/0x9c) from [<c002204c>] (__exception_text_start+0x4c/0x64)
 r4:00000010
[<c0022000>] (__exception_text_start+0x0/0x64) from [<c0022890>] (__irq_usr+0x50/0xa0)
Exception stack(0xecdaffb0 to 0xecdafff8)
ffa0:                                     403b8760 401612a8 000251eb 00000002 
ffc0: 403b8760 403b88f0 00000000 403b1c60 00000002 40167e6c 4015e200 4016c1d8 
ffe0: 403b1c60 bedbfab8 4016b82c 400a13b4 20000010 ffffffff                   
 r6:0000000f r5:fe400200 r4:ffffffff
Code: e5904014 e1a05000 e2800090 ebf71090 (e5942060) 
Kernel panic - not syncing: Fatal exception in interrupt
