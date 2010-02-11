Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab0BKRLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 12:11:50 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:13655 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567Ab0BKRLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 12:11:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=YMPI5PPNiQZ06wc8B8TC+TCDtqd5shA3owMcTGKW8dMPfLaAxZ6y2nYIJKQkL94BWC
         xUj1YvwONBFpnnLazdRGrAHlhnv117OHk8/PcCrFd5/Aauke6pNn5RUp32N8PoszD8uv
         zD/lRrHM69ymz9ofnYjh5xVFTWN5W46I23E/M=
MIME-Version: 1.0
Date: Thu, 11 Feb 2010 12:11:46 -0500
X-Google-Sender-Auth: 638de1436acbed89
Message-ID: <520f0cf11002110911t3f125649v73062e9851e2cfb3@mail.gmail.com>
Subject: [BUG]: Possibe recursive locking detected in sysfs
From: John Kacur <jkacur@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure if this one has already been reported. - thanks.

Feb 11 07:24:15 localhost kernel: [ INFO: possible recursive locking detected ]
Feb 11 07:24:15 localhost kernel: 2.6.33-rc7 #1
Feb 11 07:24:15 localhost kernel: ---------------------------------------------
Feb 11 07:24:15 localhost kernel: 94cpufreq/2933 is trying to acquire lock:
Feb 11 07:24:15 localhost kernel: (s_active){++++.+}, at:
[<ffffffff81157408>] sysfs_hash_and_remove+0x53/0x6a
Feb 11 07:24:15 localhost kernel:
Feb 11 07:24:15 localhost kernel: but task is already holding lock:
Feb 11 07:24:15 localhost kernel: (s_active){++++.+}, at:
[<ffffffff81159530>] sysfs_get_active_two+0x24/0x48
Feb 11 07:24:15 localhost kernel:
Feb 11 07:24:15 localhost kernel: other info that might help us debug this:
Feb 11 07:24:15 localhost kernel: 4 locks held by 94cpufreq/2933:
Feb 11 07:24:15 localhost kernel: #0:  (&buffer->mutex){+.+.+.}, at:
[<ffffffff81157dbd>] sysfs_write_file+0x3e/0x12b
Feb 11 07:24:15 localhost kernel: #1:  (s_active){++++.+}, at:
[<ffffffff81159530>] sysfs_get_active_two+0x24/0x48
Feb 11 07:24:15 localhost kernel: #2:  (s_active){++++.+}, at:
[<ffffffff8115953d>] sysfs_get_active_two+0x31/0x48
Feb 11 07:24:15 localhost kernel: #3:  (dbs_mutex){+.+.+.}, at:
[<ffffffffa04bcdb3>] cpufreq_governor_dbs+0x29b/0x348
[cpufreq_ondemand]
Feb 11 07:24:15 localhost kernel:
Feb 11 07:24:15 localhost kernel: stack backtrace:
Feb 11 07:24:15 localhost kernel: Pid: 2933, comm: 94cpufreq Not
tainted 2.6.33-rc7 #1
Feb 11 07:24:15 localhost kernel: Call Trace:
Feb 11 07:24:15 localhost kernel: [<ffffffff81071f53>]
__lock_acquire+0xcf6/0xd8b
Feb 11 07:24:15 localhost kernel: [<ffffffff81070914>] ?
debug_check_no_locks_freed+0x120/0x12f
Feb 11 07:24:15 localhost kernel: [<ffffffff8107020e>] ?
trace_hardirqs_on_caller+0x11f/0x14a
Feb 11 07:24:15 localhost kernel: [<ffffffff810720c0>] lock_acquire+0xd8/0xf5
Feb 11 07:24:15 localhost kernel: [<ffffffff81157408>] ?
sysfs_hash_and_remove+0x53/0x6a
Feb 11 07:24:15 localhost kernel: [<ffffffff81159231>]
sysfs_addrm_finish+0xe1/0x175
Feb 11 07:24:15 localhost kernel: [<ffffffff81157408>] ?
sysfs_hash_and_remove+0x53/0x6a
Feb 11 07:24:15 localhost kernel: [<ffffffff8137b1b5>] ?
sub_preempt_count+0xa3/0xb6
Feb 11 07:24:15 localhost kernel: [<ffffffff81157408>]
sysfs_hash_and_remove+0x53/0x6a
Feb 11 07:24:15 localhost kernel: [<ffffffff8115a59d>]
sysfs_remove_group+0x91/0xc9
Feb 11 07:24:15 localhost kernel: [<ffffffffa04bcdc6>]
cpufreq_governor_dbs+0x2ae/0x348 [cpufreq_ondemand]
Feb 11 07:24:15 localhost kernel: [<ffffffff8137b1b5>] ?
sub_preempt_count+0xa3/0xb6
Feb 11 07:24:15 localhost kernel: [<ffffffff812ab9cc>]
__cpufreq_governor+0x89/0xc7
Feb 11 07:24:15 localhost kernel: [<ffffffff812ac7b9>]
__cpufreq_set_policy+0x18e/0x22a
Feb 11 07:24:15 localhost kernel: [<ffffffff812accd6>]
store_scaling_governor+0x199/0x1ed
Feb 11 07:24:15 localhost kernel: [<ffffffff812ad50d>] ? handle_update+0x0/0x39
Feb 11 07:24:15 localhost kernel: [<ffffffff8137685d>] ? down_write+0x76/0x7e
Feb 11 07:24:15 localhost kernel: [<ffffffff812ac607>] store+0x67/0x8b
Feb 11 07:24:15 localhost kernel: [<ffffffff81157e75>]
sysfs_write_file+0xf6/0x12b
Feb 11 07:24:15 localhost kernel: [<ffffffff811003c9>] vfs_write+0xb0/0x10a
Feb 11 07:24:15 localhost kernel: [<ffffffff811004f1>] sys_write+0x4c/0x75
Feb 11 07:24:15 localhost kernel: [<ffffffff81002d9b>]
system_call_fastpath+0x16/0x1b
