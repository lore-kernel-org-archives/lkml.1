Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbZGNXrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbZGNXrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 19:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902AbZGNXrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 19:47:06 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:40505 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbZGNXrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 19:47:05 -0400
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <200907142347.n6ENl23S001626@clem.clem-digital.net>
Subject: Oops tty layer -- 31-rc3 and 31-rc2-git10
To: linux-kernel@vger.kernel.org (linux-kernel)
Date: Tue, 14 Jul 2009 19:47:02 -0400 (EDT)
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fyi:
Getting the following oops on shutdown with 31-rc2-git10 and 31-rc3.
(x86 UP)

BUG: unable to handle kernel NULL pointer dereference at 00000004
IP: [<c10fe4d4>] tty_ldisc_wait_idle+0x74/0xe0
*pde = 00000000 
Oops: 0000 [#1] 
last sysfs file: 
Modules linked in: ipv6

Pid: 1954, comm: login Not tainted (2.6.31-rc3 #1) XPST450
EIP: 0060:[<c10fe4d4>] EFLAGS: 00010296 CPU: 0
EIP is at tty_ldisc_wait_idle+0x74/0xe0
EAX: 00000000 EBX: 000004e2 ECX: d7ba5df8 EDX: d7ba5dec
ESI: d78fac00 EDI: d78fac00 EBP: d7ba5df8 ESP: d7ba5dec
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process login (pid: 1954, ti=d7ba4000 task=d78ed1b0 task.ti=d7ba4000)
Stack:
 00000000 d78ed1b0 c1027870 c124184c c124184c d78fac14 d78fac00 d78fac00
<0> 00000000 c10fec5a 00000001 d78fad08 d78fad08 d78fac00 c10f7fc7 00000000
<0> 00000001 d7b850a0 00000000 d7854920 d78fac00 00000001 d7983584 c10f84d6
Call Trace:
 [<c1027870>] ? autoremove_wake_function+0x0/0x50
 [<c10fec5a>] ? tty_ldisc_hangup+0xda/0x190
 [<c10f7fc7>] ? do_tty_hangup+0x97/0x2b0
 [<c10f84d6>] ? disassociate_ctty+0x36/0x150
 [<c101922d>] ? do_exit+0x5dd/0x630
 [<c101ef2a>] ? recalc_sigpending+0xa/0x20
 [<c102172f>] ? dequeue_signal+0x2f/0x180
 [<c101040b>] ? pte_alloc_one+0x1b/0x50
 [<c10192aa>] ? do_group_exit+0x2a/0x80
 [<c1021be9>] ? get_signal_to_deliver+0x129/0x300
 [<c1001fe8>] ? do_notify_resume+0xb8/0x830
 [<c10124bd>] ? dequeue_task_fair+0x1d/0x170
 [<c1011999>] ? dequeue_task+0x69/0xc0
 [<c11bbfb3>] ? schedule+0x233/0x360
 [<c1018985>] ? do_wait+0x155/0x250
 [<c1013e30>] ? default_wake_function+0x0/0x10
 [<c1018b15>] ? sys_wait4+0x95/0xe0
 [<c1002d3a>] ? work_notifysig+0x13/0x19
Code: 00 89 44 24 08 89 6c 24 0c 89 6c 24 10 8d 76 00 8d bc 27 00 00 00 00 b8 4c 18 24 c1 b9 02 00 00 00 89 e2 e8 af 91 f2 ff 8b 46 20 <8b> 40 04 85 c0 74 2d 89 d8 e8 ee dc 0b 00 85 c0 89 c3 75 d8 89 
EIP: [<c10fe4d4>] tty_ldisc_wait_idle+0x74/0xe0 SS:ESP 0068:d7ba5dec
CR2: 0000000000000004
---[ end trace eb52b7270d368252 ]---
Fixing recursive fault but reboot is needed!

-- 
Pete Clements 
