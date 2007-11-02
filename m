Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbXKBWER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbXKBWER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 18:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbXKBWEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 18:04:04 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:18851 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbXKBWEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 18:04:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=cO/FnSj3SXoEISc/vGaleKj/vgRsymqxiXSEoxaEz7gq3bvQuLsyfcmeBgcLunWpqHwaT4Jlqrj010j9UEdUi7IItVes+Sn9hoODPxjCRVDX7DvC5WU1jbFlq+i6qeiGXeCz/elJNSqiio176hizEzUF43IMCkChuZlbP8FM+7k=
Message-ID: <64bb37e0711021503x4844b905yba1e9a681c4e788a@mail.gmail.com>
Date: Fri, 2 Nov 2007 23:03:58 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc1-54866f032307063776b4eff7eadb131d47f9f9b4 fails to boot: kernel BUG at include/linux/scatterlist.h:49!
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       linux1394-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Both 2.6.24-rc1 and the current git version fail to boot for me:

[   57.182205] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[16]
MMIO=[effff800-efffffff]  Max Packet=
[2048]  IR/IT contexts=[4/8]
[   57.194032] eth1394: eth2: IPv4 over IEEE 1394 (fw-host0)
[   57.199527] ------------[ cut here ]------------
[   57.204154] kernel BUG at include/linux/scatterlist.h:49!
[   57.209559] invalid opcode: 0000 [1] SMP
[   57.213667] CPU 0
[   57.215742] Modules linked in:
[   57.218857] Pid: 1, comm: swapper Not tainted 2.6.24-rc1 #1
[   57.224435] RIP: 0010:[<ffffffff80463512>]  [<ffffffff80463512>]
dma_region_alloc+0x142/0x180
[   57.233003] RSP: 0000:ffff810004f29db0  EFLAGS: 00010293
[   57.238322] RAX: ffffc20001454000 RBX: 0000000000000000 RCX: ffffe20001c7e690
[   57.245457] RDX: 0000000000000000 RSI: 00003ffffffff000 RDI: 0000000000000388
[   57.252592] RBP: ffff810005ddca48 R08: 0000000000000000 R09: ffffc20001454000
[   57.259727] R10: 0000000000000002 R11: 0000000000000000 R12: 0000000087654321
[   57.266862] R13: ffff810100914000 R14: 0000000000000002 R15: ffff810005e88000
[   57.273996] FS:  0000000000000000(0000) GS:ffffffff8079c000(0000)
knlGS:0000000000000000
[   57.282082] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   57.287834] CR2: 0000000000e01766 CR3: 0000000000201000 CR4: 00000000000006e0
[   57.294968] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   57.302102] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   57.309238] Process swapper (pid: 1, threadinfo ffff810004f28000,
task ffff81010032a000)
[   57.317332] Stack:  ffff810005ddca48 0000000000000002
ffff810005ddca00 0000000000000010
[   57.325546]  000000000000001f ffffffff80464146 ffffffff8089ff00
0000000000010000
[   57.333104]  ffff810005ddca00 ffff8101011b66c0 ffff810005e88000
ffffffff80754740
[   57.340455] Call Trace:
[   57.343139]  [<ffffffff80464146>] hpsb_iso_common_init+0x1e6/0x210
[   57.349322]  [<ffffffff80464198>] hpsb_iso_recv_init+0x28/0x70
[   57.355159]  [<ffffffff8046c940>] ether1394_iso+0x0/0x130
[   57.360564]  [<ffffffff8046bc08>] ether1394_recv_init+0x58/0xd0
[   57.366488]  [<ffffffff8046c940>] ether1394_iso+0x0/0x130
[   57.371893]  [<ffffffff8045e8b7>] highlevel_for_each_host_reg+0x17/0x60
[   57.378508]  [<ffffffff8045e8a0>] highlevel_for_each_host_reg+0x0/0x60
[   57.385039]  [<ffffffff80460f74>] nodemgr_for_each_host+0x44/0x90
[   57.391136]  [<ffffffff807dfac6>] ether1394_init_module+0x36/0x70
[   57.397232]  [<ffffffff807be724>] kernel_init+0x164/0x350
[   57.402637]  [<ffffffff8020c9c8>] child_rip+0xa/0x12
[   57.407609]  [<ffffffff807be5c0>] kernel_init+0x0/0x350
[   57.412842]  [<ffffffff8020c9be>] child_rip+0x0/0x12
[   57.417814]
[   57.419327]
[   57.419327] Code: 0f 0b eb fe 0f 0b eb fe 66 0f 1f 44 00 00 48 c7 c7 38 40 6e
[   57.428891] RIP  [<ffffffff80463512>] dma_region_alloc+0x142/0x180
[   57.435117]  RSP <ffff810004f29db0>
[   57.438629] Kernel panic - not syncing: Attempted to kill init!

from gdb:
0xffffffff80463512 is in dma_region_alloc (include/linux/scatterlist.h:49).
44               * In order for the low bit stealing approach to work, pages
45               * must be aligned at a 32-bit boundary as a minimum.
46               */
47              BUG_ON((unsigned long) page & 0x03);
48      #ifdef CONFIG_DEBUG_SG
49              BUG_ON(sg->sg_magic != SG_MAGIC);
50      #endif
51              sg->page_link = page_link | (unsigned long) page;
52      }
53

Torsten
