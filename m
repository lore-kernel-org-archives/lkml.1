Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbXIDLFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbXIDLFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 07:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbXIDLFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 07:05:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:38713 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbXIDLFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 07:05:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=i/I+hnXu50T1WNbzJuBvCUV4xwddlYt21i+yQjlvMF4dy4eKrtLZxWI77D2UoD7Zb3Zx9JseVq3rSxLoCelx5iASQfAQ4ceysXgyGgHi882VjqvOeZzG0LGQIMjwoZg8xGz4cCEmUca/s9aBmraP3ag6g5y0vuyXxgV56m8O0IU=
Message-ID: <6278d2220709040405i4f816afemb3a44d9cd95f9cc@mail.gmail.com>
Date: Tue, 4 Sep 2007 12:05:21 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Trond Myklebust" <Trond.Myklebust@netapp.com>
Subject: [NFSv4] 2.6.23-rc4 oops in nfs4_cb_recall...
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, nfsv4@linux-nfs.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trond,

When accessing a directory inode from a single other client, NFSv4
callbacks catastrophically failed [1] on the NFS server with
2.6.23-rc4 (unpatched); clients are both 2.6.22 (Ubuntu Gutsy build).
Seems not easy to reproduce, since this kernel was running smoothly
for 7 days on the server.

What information will help track this down, or is there a known
failure mechanism? I can map stack frames to source lines with
objdump, if that helps.

Daniel

--- [1]

general protection fault: 0000 [1] SMP
CPU 1
Modules linked in: dvb_usb_dtt200u dvb_usb dvb_core firmware_class
i2c_core uhci_hcd ehci_hcd usbcore
Pid: 24009, comm: nfs4_cb_recall Not tainted 2.6.23-rc4-109 #1
RIP: 0010:[xprt_reserve+217/384]  [xprt_reserve+217/384] xprt_reserve+0xd9/0x180
RSP: 0018:ffff81003905de20  EFLAGS: 00010286
RAX: ffff81000a2600a8 RBX: ffff81003a1d8780 RCX: 4d00000000610d00
RDX: 0b66656403100000 RSI: 0000000000000000 RDI: ffff81000a260000
RBP: ffff81003ebf3000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: ffff81000a260000
R13: ffff81003ebf3460 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff81003fdd4180(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00002b456c102468 CR3: 000000003e047000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
Process nfs4_cb_recall (pid: 24009, threadinfo ffff81003905c000, task
ffff81000a358000)
Stack:  ffff810032360040 0000000000000000 ffff81003a1d8780 ffffffff804d2170
  ffff81003a1d8870 ffffffff80483a3b 0000000000000000 ffff81003a1d8780
  ffff81003a1d8780 ffffffff804d2170 ffff81003905ded0 ffffffff8047d876
Call Trace:
  [__rpc_execute+107/656] __rpc_execute+0x6b/0x290
  [rpc_do_run_task+118/208] rpc_do_run_task+0x76/0xd0
  [rpc_call_sync+21/64] rpc_call_sync+0x15/0x40
  [nfsd4_cb_recall+258/304] nfsd4_cb_recall+0x102/0x130
  [do_recall+0/32] do_recall+0x0/0x20
  [do_recall+17/32] do_recall+0x11/0x20
  [kthread+75/128] kthread+0x4b/0x80
  [child_rip+10/18] child_rip+0xa/0x12
  [kthread+0/128] kthread+0x0/0x80
-- 
Daniel J Blueman
