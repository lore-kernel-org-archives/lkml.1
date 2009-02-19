Return-Path: <linux-kernel-owner+w=401wt.eu-S1757702AbZBSOvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702AbZBSOvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 09:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbZBSOvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 09:51:15 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:43835 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbZBSOvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 09:51:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=vvQbbCFy4YWxdDzJqLlIgaXlcc51qS3fJdBxWBA547bysCOMyQn7yIMN0hZ/Mir8j5
         UBGl2nkC0gYVFjLUyQKgnM6UTeVciwVj9JYrJAHVFEK8yJ5pWui6A0DlH+C/CKV0DG9Y
         7LUqXk5Gj00WAv02w1u546tKMe+IbEmGMIN2g=
MIME-Version: 1.0
Date: Thu, 19 Feb 2009 17:51:12 +0300
Message-ID: <a4423d670902190651t71638aaepbc2ba49b9b6a25c6@mail.gmail.com>
Subject: next-20090219: IMA: kernel BUG at include/linux/scatterlist.h:65
From: Alexander Beregalov <a.beregalov@gmail.com>
To: zohar@us.ibm.com,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

 kernel BUG at include/linux/scatterlist.h:65!
 invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
 last sysfs file:
 CPU 2
 Modules linked in:
 Pid: 1, comm: swapper Not tainted 2.6.29-rc5-next-20090219 #5 PowerEdge 1950
 RIP: 0010:[<ffffffff8045ec70>]  [<ffffffff8045ec70>] ima_calc_hash+0xc0/0x160
 RSP: 0018:ffff88007f46bc40  EFLAGS: 00010286
 RAX: ffffe200032c45e8 RBX: 00000000fffffff4 RCX: 0000000087654321
 RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffff88007cf71048
 RBP: ffff88007f46bcd0 R08: 0000000000000000 R09: 0000000000000163
 R10: ffff88007f4707a8 R11: 0000000000000000 R12: ffff88007cf71048
 R13: 0000000000001000 R14: 0000000000000000 R15: 0000000000009d98
 FS:  0000000000000000(0000) GS:ffff8800051ac000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
 CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process swapper (pid: 1, threadinfo ffff88007f46a000, task ffff88007f470000)
 Stack:
  ffffffff8045e49e 0000004800000246 ffff88007cfbc3b8 ffff88007c853980
  ffffffff8045e49e 0000000000000002 ffff88007cfbc440 ffff88007cfbc418
  2222222222222222 2222222222222222 ffff88007d878b88 2222222200000000
 Call Trace:
  [<ffffffff8045e49e>] ? process_measurement+0x9e/0x110
  [<ffffffff8045e49e>] ? process_measurement+0x9e/0x110
  [<ffffffff8045ed6f>] ima_collect_measurement+0x5f/0x70
  [<ffffffff8045e4e7>] process_measurement+0xe7/0x110
  [<ffffffff8045e531>] ima_bprm_check+0x21/0x30
  [<ffffffff802d0246>] search_binary_handler+0x26/0x320
  [<ffffffff802d0792>] do_execve+0x252/0x2c0
  [<ffffffff802099c9>] sys_execve+0x49/0x80
  [<ffffffff8020ccd8>] kernel_execve+0x68/0xd0
  [<ffffffff80209232>] ? init_post+0xb2/0x1b0
  [<ffffffff8020cc5a>] ? child_rip+0xa/0x20
  [<ffffffff80235ec9>] ? finish_task_switch+0x89/0x110
  [<ffffffff80656006>] ? _spin_unlock_irq+0x36/0x60
  [<ffffffff8020c640>] ? restore_args+0x0/0x30
  [<ffffffff8020cc50>] ? child_rip+0x0/0x20
 Code: 89 e7 e8 d4 c6 dc ff 48 b9 00 00 00 00 00 e2 ff ff 48 c1 e8
 0c 48 8b 55 98 48 6b c0 68 48 01 c8 b9 21 43 65 87 48 39 4d 90 74 30 <0f> 0b eb
 fe 4c 89 e7 44 89 eb e8 f1 66 e6 ff 48 8b 7d c0 48 89
 RIP  [<ffffffff8045ec70>] ima_calc_hash+0xc0/0x160
  RSP <ffff88007f46bc40>
 ---[ end trace 0003b39833c42ede ]---
<..>
Kernel panic - not syncing: Attempted to kill init!
