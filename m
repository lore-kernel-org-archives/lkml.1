Return-Path: <linux-kernel-owner+w=401wt.eu-S1757802AbZFPLoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802AbZFPLoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 07:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbZFPLoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 07:44:14 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:61215 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbZFPLoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 07:44:13 -0400
Date: Tue, 16 Jun 2009 07:44:10 -0400
From: Chris Mason <chris.mason@oracle.com>
To: David Woodhouse <david.woodhouse@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: iommu bug
Message-ID: <20090616114410.GE3735@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	David Woodhouse <david.woodhouse@intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4A37858B.0268:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I posted this one a while ago (last September) and it disappeared on me.
I've recently turned the iommu back on and its back:

Last time David asked me to try with iommu=strict, which I'll do when
back from vacation.  At the time we thought the bug was an IO being
submitted with the same page on two different bios.  For whatever
reason, btrfs raid1 and raid10 hit this harder than MD.

This oops is 2.6.30 + the btrfs tree (which doesn't change iommu at
all).

kernel BUG at drivers/pci/intel-iommu.c:1524!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/block/loop3/removable
CPU 1
Modules linked in: loop btrfs netconsole configfs 3w_9xxx
Pid: 30595, comm: btrfs-worker-5 Not tainted 2.6.30 #6
RIP: 0010:[<ffffffff803ee688>]  [<ffffffff803ee688>] domain_page_mapping+0xa4/0xf7
RSP: 0018:ffff880004cc5af0  EFLAGS: 00010006
RAX: ffff880110e96e00 RBX: ffff88014eda3f40 RCX: 00000000a958e001
RDX: ffff880110e96000 RSI: 0000000000000006 RDI: ffff88014eda3f88
RBP: ffff880004cc5b30 R08: 0000000000000027 R09: 0000000000001000
R10: 0000000000000000 R11: 0000000000000002 R12: 000000000006ec4a
R13: 000000000006ec4b R14: 000000000006ec4a R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff880004c62000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007f0de3efe508 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs-worker-5 (pid: 30595, threadinfo ffff8801339e6000, task ffff8801085b2280)
Stack:
 0000000000000001 00000000affc0000 0000000000000018 ffff88014eda3f40
 ffff88011d826000 0000000000000018 00000000affc0000 0000000000000000
 ffff880004cc5bb0 ffffffff803efb31 ffff8800572fe080 0000000000000000
Call Trace:
Code: 48 63 f6 48 89 df 48 c1 e6 0c 48 03 75 c8 e8 dd fd ff ff 48 85 c0 75 07 b8 f4 ff ff ff eb 50 48 8b 08 48 f7 c1 00 f0 ff ff 74 04 <0f> 0b eb fe 4c 89 e2 48 c1 e2 0c 48 09 ca 48 83 e2 fc 48 0b 55
RIP  [<ffffffff803ee688>] domain_page_mapping+0xa4/0xf7
 RSP <ffff880004cc5af0>
---[ end trace e1cd0e6624485448 ]---
