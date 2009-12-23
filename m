Return-Path: <linux-kernel-owner+w=401wt.eu-S1751828AbZLWAUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbZLWAUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 19:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbZLWAUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 19:20:22 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:44780 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbZLWAUV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 19:20:21 -0500
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Oops] 2.6.33-rc1: kernel NULL pointer dereference in check_preempt_wakeup
Date: Wed, 23 Dec 2009 01:20:14 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.32.2; KDE/4.3.85; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912230120.15519.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.33-rc1 I have random hangs. Even SysRq-Key works, only hard reset. 
I've had it mostly within X, where I didn't get any messages but one time on 
console with the following trace:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000090
IP [<ffffffff810263f1>1 check_preempt_wakeup+0xae/0x14e
PGD 10efa1067 PUD 11767a067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:10.3/tempt1_input
CPU 0
Pid: 20108, comm: ebuild.sh Not tainted 2.6.33-rc1 #1 TYAN Tiger K8W Dual AMD 
Opteron, S28755/To Be Filled By O.E.M.
RIP: 0010:[<ffffffff810263f1>] [<ffffffff810263f1>] check_preempt_wakeup+0xae/0x14e
RSP: 0018: ffff88006c0e3e50 EFALGS: 000010087
RAX: ffff880028292420 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000001200011
RBP: ffff880105a3eae0 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000001200011 R11: ffff88011cdd0000 R12: ffff8800282123c0
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000004ed0
FS:  00007f767a6aa700(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000090 CR§: 00000001061a3000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process ebuild.sh (pid: 20108, threadinfo ffff88006c0e2000, task ffff880105a3eae0)
Stack:
 ffff8800202123c0 ffff88009734c740 0000000001200011 ffff88009734c740
<0> 0000000000004ed0 ffffffff8102e329 0000000000000000 0000000000000286
<0> 00007f767a6aa9d0 0000000000000000 0000000000000000 ffffffff8103042d
Call Trace:
 [<ffffffff8102e329>] ?  wake_up_new_task+0x66/0x8f
 [<ffffffff8103042d>] ? do_fork+0x20f/0x273
 [<ffffffff810a5a9s>] ? alloc_fd+0x69/10a
 [<ffffffff8103a953>] ? sigprocmask+0x9f/0xc2
 [<ffffffff810020d3>] ? stub_clone+0x13/0x20
 [<ffffffff81001e6b>] ? system_call_fastpath+0x16/0x1b
Code: 8b 89 88 00 00 00 ff c0 48 85 c9 75 f2 eb 09 40 0b 9b 88 00 00 00 ff ca 39 
c2 7f f3 eb 09 4d 8b b6 88 00 00 00 ff c8 39 d0 7f f3 <49> 8b 86 90 00 00 00 48 
39 83 90 00 00 00 75 74 4d 85 f6 75 04
RIP  [<ffffffff810263f1>] check_preempt_wakeup+0xae/0x14e
 RSP <ffff88006c0e3e50>
CR2: 0000000000000090
---[ end trace f6bafb05b72ae358 ]---

Since the system didn't respond anymore, I had captured this with camera and 
copied by hand. I hope I haven't made any mistakes when copying. The picture 
wasn't very good.

regards,
  Johannes
