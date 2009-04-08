Return-Path: <linux-kernel-owner+w=401wt.eu-S935035AbZDHRM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935035AbZDHRM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935026AbZDHRMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:12:31 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:37558 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935021AbZDHRM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:12:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=P81briJVKzM4xeJgqSoZsNAelFh3qKJYU1HSXNyfq6RZ38eyTtd+lHmUaYGQ9vBj/a
         bqmC9Izef/QQ2mHuKjYmoIVzEIS2mJqQfuqyCPcp5euhKhWicXCv6NWmWKP99tFiH9Nl
         Hzc3Cz7w2CN1UB2dMNjOs/aw+QpDK5o+ljK88=
MIME-Version: 1.0
Date: Wed, 8 Apr 2009 21:12:25 +0400
Message-ID: <a4423d670904081012j30ad104etefeee0c8c682aca9@mail.gmail.com>
Subject: 2.6.30-rc1 cannot boot: scsi/async
From: Alexander Beregalov <a.beregalov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

It is 2*2 SMP system, x86_64.

INFO: task async/0:1073 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
async/0       D 0000000000000000  6312  1073      2
 ffff88007ed91cd0 0000000000000046 0000000000000006 0000000000000000
 ffff88007ed91c40 000000000000d988 00000000001d2040 0000000000000000
 ffff88007f5c1300 ffff88007f7d8000 ffff88007f5c1690 0000000000000000
Call Trace:
 [<ffffffff802832ed>] ? trace_hardirqs_on_caller+0x18d/0x1f0
 [<ffffffff80283370>] ? trace_hardirqs_on+0x20/0x40
 [<ffffffff806d53e6>] schedule+0x26/0x60
 [<ffffffff80275825>] async_synchronize_cookie_domain+0x85/0x160
 [<ffffffff8026cd70>] ? autoremove_wake_function+0x0/0x60
 [<ffffffff80275923>] async_synchronize_cookie+0x23/0x40
 [<ffffffff8027596c>] async_synchronize_full+0x2c/0x70
 [<ffffffff8058a0c8>] scsi_complete_async_scans+0x88/0x140
 [<ffffffff8058c985>] __scsi_add_device+0x105/0x140
 [<ffffffff805aefb2>] ata_scsi_scan_host+0xc2/0x1f0
 [<ffffffff805aafd6>] async_port_probe+0xc6/0x110
 [<ffffffff806d8fa5>] ? _spin_unlock_irqrestore+0x55/0xb0
 [<ffffffff8027563a>] async_thread+0x11a/0x280
 [<ffffffff802460a0>] ? default_wake_function+0x0/0x40
 [<ffffffff80275520>] ? async_thread+0x0/0x280
 [<ffffffff8026c8dc>] kthread+0x5c/0xb0
 [<ffffffff8020cafa>] child_rip+0xa/0x20
 [<ffffffff8020c4c0>] ? restore_args+0x0/0x30
 [<ffffffff8026c880>] ? kthread+0x0/0xb0
 [<ffffffff8020caf0>] ? child_rip+0x0/0x20
1 lock held by async/0/1073:
 #0:  (&shost->scan_mutex){+.+.+.}, at: [<ffffffff8058c94a>]
__scsi_add_device+0xca/0x140
INFO: task async/1:1076 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
async/1       D 0000000000000001  6552  1076      2
 ffff88007ed97dc0 0000000000000046 ffff88007ed97d00 ffffffff8027fb01
 00000000000001d2 000000000000d988 00000000001d2040 0000000000000002
 ffff88007ed98000 ffff88007f7db900 ffff88007ed98390 000000027ed97eb0
Call Trace:
 [<ffffffff8027fb01>] ? put_lock_stats+0x21/0x60
 [<ffffffff802832ed>] ? trace_hardirqs_on_caller+0x18d/0x1f0
 [<ffffffff80283370>] ? trace_hardirqs_on+0x20/0x40
 [<ffffffff806d53e6>] schedule+0x26/0x60
 [<ffffffff80275825>] async_synchronize_cookie_domain+0x85/0x160
 [<ffffffff8026cd70>] ? autoremove_wake_function+0x0/0x60
 [<ffffffff80275923>] async_synchronize_cookie+0x23/0x40
 [<ffffffff805ab000>] async_port_probe+0xf0/0x110
 [<ffffffff806d8fa5>] ? _spin_unlock_irqrestore+0x55/0xb0
 [<ffffffff8027563a>] async_thread+0x11a/0x280
 [<ffffffff802460a0>] ? default_wake_function+0x0/0x40
 [<ffffffff80275520>] ? async_thread+0x0/0x280
 [<ffffffff8026c8dc>] kthread+0x5c/0xb0
 [<ffffffff8020cafa>] child_rip+0xa/0x20
 [<ffffffff8020c4c0>] ? restore_args+0x0/0x30
 [<ffffffff8026c880>] ? kthread+0x0/0xb0
 [<ffffffff8020caf0>] ? child_rip+0x0/0x20
no locks held by async/1/1076.
INFO: task swapper:1 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
swapper       D 0000000000000000  3336     1      0
 ffff88007f427dd0 0000000000000046 ffff88007f427d10 ffffffff8027fb01
 0000000000000145 000000000000d988 00000000001d2040 0000000000000000
 ffff88007f448000 ffffffff808744a0 ffff88007f448390 00000000808c9fe0
Call Trace:
 [<ffffffff8027fb01>] ? put_lock_stats+0x21/0x60
 [<ffffffff802832ed>] ? trace_hardirqs_on_caller+0x18d/0x1f0
 [<ffffffff80283370>] ? trace_hardirqs_on+0x20/0x40
 [<ffffffff806d53e6>] schedule+0x26/0x60
 [<ffffffff80275825>] async_synchronize_cookie_domain+0x85/0x160
 [<ffffffff8026cd70>] ? autoremove_wake_function+0x0/0x60
 [<ffffffff80275923>] async_synchronize_cookie+0x23/0x40
 [<ffffffff8027596c>] async_synchronize_full+0x2c/0x70
 [<ffffffff805758bf>] wait_for_device_probe+0x8f/0xc0
 [<ffffffff8026cd70>] ? autoremove_wake_function+0x0/0x60
 [<ffffffff808d865f>] prepare_namespace+0x2a/0x179
 [<ffffffff808d78c6>] kernel_init+0x1e9/0x250
 [<ffffffff8020cafa>] child_rip+0xa/0x20
 [<ffffffff8020c4c0>] ? restore_args+0x0/0x30
 [<ffffffff808d76dd>] ? kernel_init+0x0/0x250
 [<ffffffff8020caf0>] ? child_rip+0x0/0x20
no locks held by swapper/1.
