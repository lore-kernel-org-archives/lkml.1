Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab0BHO2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 09:28:08 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40676 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750804Ab0BHO2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 09:28:07 -0500
Date: Mon, 8 Feb 2010 14:27:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, kvm@kernel.org
Subject: KVM in -next is somewhat busted
Message-ID: <20100208142752.2e859b7d@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reliably at boot time with todays -next I get the following:

BUG: unable to handle kernel paging request at 0000000000001028
IP: [<ffffffffa001c4c4>] balloon+0x1a1/0x309 [virtio_balloon]
PGD 2cd42067 PUD 3b9dc067 PMD 0 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/virtio-pci/virtio4/block/vdd/removable
CPU 3 
Pid: 511, comm: vballoon Not tainted 2.6.33-rc7-next-20100208+ #51 /
RIP: 0010:[<ffffffffa001c4c4>]  [<ffffffffa001c4c4>] balloon+0x1a1/0x309 [virtio_balloon]
RSP: 0018:ffff88002cd65e40  EFLAGS: 00010282
RAX: ffffea0000d655f2 RBX: ffff88003d3d2800 RCX: ffffea0000000000
RDX: 0000000000000000 RSI: ffff88002cd65e80 RDI: ffff88003d3d2c80
RBP: ffff88002cd65ee0 R08: 0000000000000040 R09: ffffffff81af0c88
R10: ffff88002cc65c80 R11: ffff88002cd65eac R12: 0000000000001000
R13: ffff88003ca61720 R14: ffff88002cd65e80 R15: ffff88003ca61720
FS:  0000000000000000(0000) GS:ffff880001e60000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000001028 CR3: 000000002cdbd000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process vballoon (pid: 511, threadinfo ffff88002cd64000, task ffff88003ca61720)
Stack:
 0000000000000001 0000000000000000 ffff88003ca61720 ffff88003d3d2c80
<0> ffff88003d3d2868 ffff88002cd65e98 ffff88003d3d2820 0000000000000000
<0> ffffea0000d655f2 0000003c00000c80 0000000000000000 0000000000000000
Call Trace:
 [<ffffffffa001c323>] ? balloon+0x0/0x309 [virtio_balloon]
 [<ffffffff81064d75>] kthread+0x7f/0x87
 [<ffffffff8100a9a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81064cf6>] ? kthread+0x0/0x87
 [<ffffffff8100a9a0>] ? kernel_thread_helper+0x0/0x10
Code: 54 48 89 df c7 83 7c 04 00 00 00 00 00 00 e8 b0 fd ff ff 4c 8b 63 18 48 8b b5 78 ff ff ff ba 3c 00 00 00 4c 89 f7 e8 85 f3 1e e1 <49> 8b 44 24 28 31 c9 49 89 d8 ba 01 00 00 00 4c 89 f6 4c 89 e7 
RIP  [<ffffffffa001c4c4>] balloon+0x1a1/0x309 [virtio_balloon]
 RSP <ffff88002cd65e40>
CR2: 0000000000001028
---[ end trace 2a0ed1359b95aa89 ]---
