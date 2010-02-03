Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab0BCTEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:04:07 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:7861 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335Ab0BCTEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:04:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=oFYV1khkJAUiLX+rS1ho3CwRaNW9ERE5GM6CN/82jCQEQNNI772Ialg4W3G0btKzz2
         wblM9IQ1EpJdzvVSCvfSDvQgl9soCN8OTNH1UjM2sI+75DoTsDoZ7YBfJWaeTVBysjDy
         ySCI4rWE3WRZF/zhn+kuhXn9sHAM73lxDTV6o=
MIME-Version: 1.0
Date: Wed, 3 Feb 2010 22:03:59 +0300
Message-ID: <a4423d671002031103r230f66cai4ab25236504bcf15@mail.gmail.com>
Subject: reiserfs deadlock
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic

I do not have previous messages and do not know how to reproduce it.
Kernel was 2.6.33-rc5-00237-g9a3cbe3

INFO: task svscan:1395 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
svscan        D f73094f0  5248  1395      1 0x00000000
 f6565da0 00000046 00000007 f73094f0 c134e5fd f7309770 f73094f0 c104e4b4
 f6411c84 f6411c84 00000246 f73094f0 f6565de4 c134e58a 00000000 00000002
 00000000 c1110e38 f6411cac c1110e38 f6411cc0 f6335d18 f706bf14 f73094f0
Call Trace:
 [<c134e5fd>] ? mutex_lock_nested+0x19d/0x2b0
 [<c104e4b4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e58a>] mutex_lock_nested+0x12a/0x2b0
 [<c1110e38>] ? reiserfs_write_lock+0x28/0x40
 [<c1110e38>] ? reiserfs_write_lock+0x28/0x40
 [<c1110e38>] reiserfs_write_lock+0x28/0x40
 [<c10f059a>] reiserfs_readdir_dentry+0x5a/0x720
 [<c1042c75>] ? sched_clock_cpu+0x95/0x110
 [<c104ca2b>] ? trace_hardirqs_off+0xb/0x10
 [<c109fe10>] ? filldir+0x0/0xd0
 [<c1042c75>] ? sched_clock_cpu+0x95/0x110
 [<c10502d9>] ? __lock_acquire+0x509/0xa70
 [<c104e1f2>] ? mark_held_locks+0x62/0x90
 [<c134e361>] ? mutex_lock_killable_nested+0x201/0x300
 [<c104e4b4>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c134e36b>] ? mutex_lock_killable_nested+0x20b/0x300
 [<c10a0022>] ? vfs_readdir+0x52/0xa0
 [<c10a0022>] ? vfs_readdir+0x52/0xa0
 [<c109fe10>] ? filldir+0x0/0xd0
 [<c10f0c77>] reiserfs_readdir+0x17/0x20
 [<c10a0055>] vfs_readdir+0x85/0xa0
 [<c10a0188>] sys_getdents+0x68/0xc0
 [<c1002b10>] sysenter_do_call+0x12/0x36
2 locks held by svscan/1395:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c10a0022>]
vfs_readdir+0x52/0xa0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110e38>]
reiserfs_write_lock+0x28/0x40
