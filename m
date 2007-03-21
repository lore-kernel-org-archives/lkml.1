Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbXCUNPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbXCUNPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 09:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbXCUNPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 09:15:13 -0400
Received: from main.gmane.org ([80.91.229.2]:53341 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbXCUNPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 09:15:10 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dale Blount <linux-kernel@dale.us>
Subject: Re: PROBLEM: null pointer dereference in =?utf-8?b?Y2ZxX2Rpc3BhdGNoX3JlcXVlc3Rz?= (2.6.21-rc2 and 2.6.20)
Date: Wed, 21 Mar 2007 13:07:11 +0000 (UTC)
Message-ID: <loom.20070321T135132-397@post.gmane.org>
References: <1172685755.5773.6.camel@dwillia2-linux.ch.intel.com> <200703011308.28266.linux@f-seidel.de> <20070301123057.GO23985@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 66.211.211.211 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070224 FireFox/2.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm puzzled why this is hitting Dan, but no one else has reported
> anything. Dan, did 2.6.19 work for you?

Actually, I believe it is happening to me too.  This is on a 4-disk raid5 with
one failed disk on two 2-port sata_sil pci controller cards.

The BUG below is from 2.6.20.3, but I will try 2.6.21-rc4 tonight.
The disk didn't fail until 2.6.20, so I don't know if 2.6.19 would have worked
or not.


BUG: unable to handle kernel NULL pointer dereference at virtual address 0000005c
 printing eip:
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP 
Modules linked in: ipv6 raid456 xor md_mod e1000 usbcore ext3 jbd mbcache
sata_sil sd_mod sr_mod cdrom generic ide_core ata_piix libata
CPU:    0
EIP:    0060:[<c0220a29>]    Not tainted VLI
EFLAGS: 00010086   (2.6.20-ARCH #1)
EIP is at cfq_dispatch_insert+0x19/0x70
eax: c2bc1340   ebx: 00000000   ecx: 00000049   edx: 00000000
esi: c298802c   edi: f7c17cc0   ebp: 00e47352   esp: f18addfc
ds: 007b   es: 007b   ss: 0068
Process rsync (pid: 3698, ti=f18ac000 task=dfe97570 task.ti=f18ac000)
Stack: 00000000 c298ce3c f7c17cc0 00e47352 c0220bd9 00000040 c2b3cd40 c2b3c4a8 
       cafa6500 c0294750 00000000 00000000 00000004 d8ed1480 00000000 cafa6500 
       c298802c c29f0800 c2b3c000 c298802c c0215690 00000000 c0294750 cafa6500 
Call Trace:
 [<c0220bd9>] cfq_dispatch_requests+0xf9/0x4e0
 [<c0294750>] scsi_done+0x0/0x20
 [<c0215690>] elv_next_request+0x20/0x1d0
 [<c0294750>] scsi_done+0x0/0x20
 [<c0294ab6>] scsi_dispatch_cmd+0x146/0x230
 [<c0299904>] scsi_request_fn+0x194/0x2d0
 [<c0219518>] blk_run_queue+0x58/0x70
 [<c0298460>] scsi_next_command+0x30/0x50
 [<c029866b>] scsi_end_request+0xab/0xe0
 [<c0298776>] scsi_io_completion+0x86/0x370
 [<f882c770>] ata_hsm_qc_complete+0x90/0x110 [libata]
 [<f88127eb>] sd_rw_intr+0x2b/0x200 [sd_mod]
 [<c02945a9>] scsi_finish_command+0x49/0x60
 [<c0219d88>] blk_done_softirq+0x58/0x70
 [<c012bc12>] __do_softirq+0x82/0xf0
 [<c012bcb7>] do_softirq+0x37/0x40
 [<c012bee5>] irq_exit+0x45/0x50
 [<c0105dc5>] do_IRQ+0x45/0x80
 [<c0103c0f>] common_interrupt+0x23/0x28
 =======================
Code: ae 40 ee ff e9 25 ff ff ff 0f 0b eb fe 0f 0b eb fe 90 83 ec 10 89 1c 24 89
d3 89 74 24 04 89 c6 89 7c 24 08 89 6c 24 0c 8b 40 0c <8b> 7a 5c 8b 68 04 89 d0
e8 7a fe ff ff 8b 43 14 89 da 25 01 80
EIP: [<c0220a29>] cfq_dispatch_insert+0x19/0x70 SS:ESP 0068:f18addfc
 <0>Kernel panic - not syncing: Fatal exception in interrupt


