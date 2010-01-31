Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180Ab0AaVfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab0AaVfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 16:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105Ab0AaVfU
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 16:35:20 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:63869 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab0AaVfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 16:35:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=XMyhRZWfmAPKVYfUvpc8lY1vefYp9KBc5nY3F85W3VCBwzg8wDzaBKXbcCpl6nKg3a
         lbt0BrjAatzwLkWTl0Q77iAWXlqT0E8PsqYTFn567V/Uo4o91XPk8Xq7AW7cg+bqOvaw
         eQaWOqdWzSuy21Pk7xlSAO+odyx1VZMOkf2q4=
MIME-Version: 1.0
Date: Sun, 31 Jan 2010 22:35:18 +0100
X-Google-Sender-Auth: 7aa1b81dc7cdf3ff
Message-ID: <520f0cf11001311335qeeb6082k68ba63c024c47b8a@mail.gmail.com>
Subject: K99cpuspeed: possible recursive locking detected
From: John Kacur <jkacur@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see the following when I shut-down 2.6.33-rc6 on my Lenovo Laptop T500

Disabling ondemand cpu frequency scaling:
=============================================
[ INFO: possible recursive locking detected ]
2.6.33-rc6 #1
---------------------------------------------
K99cpuspeed/20601 is trying to acquire lock:
 (s_active){++++.+}, at: [<ffffffff81156f5c>] sysfs_hash_and_remove+0x53/0x6a

but task is already holding lock:
 (s_active){++++.+}, at: [<ffffffff81159084>] sysfs_get_active_two+0x24/0x48

other info that might help us debug this:
4 locks held by K99cpuspeed/20601:
 #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff81157911>] sysfs_write_file+0x3e/0
x12b
 #1:  (s_active){++++.+}, at: [<ffffffff81159084>] sysfs_get_active_two+0x24/0x4
8
 #2:  (s_active){++++.+}, at: [<ffffffff81159091>] sysfs_get_active_two+0x31/0x4
8
 #3:  (dbs_mutex){+.+.+.}, at: [<ffffffffa04c4db3>] cpufreq_governor_dbs+0x29b/0
x348 [cpufreq_ondemand]

stack backtrace:
Pid: 20601, comm: K99cpuspeed Not tainted 2.6.33-rc6 #1
Call Trace:
 [<ffffffff81071f16>] __lock_acquire+0xcf6/0xd8b
 [<ffffffff810708d4>] ? debug_check_no_locks_freed+0x120/0x12f
 [<ffffffff810701ce>] ? trace_hardirqs_on_caller+0x11f/0x14a
 [<ffffffff81072083>] lock_acquire+0xd8/0xf5
 [<ffffffff81156f5c>] ? sysfs_hash_and_remove+0x53/0x6a
 [<ffffffff81158d85>] sysfs_addrm_finish+0xe1/0x175
 [<ffffffff81156f5c>] ? sysfs_hash_and_remove+0x53/0x6a
 [<ffffffff8137af35>] ? sub_preempt_count+0xa3/0xb6
 [<ffffffff81156f5c>] sysfs_hash_and_remove+0x53/0x6a
 [<ffffffff8115a0f1>] sysfs_remove_group+0x91/0xc9
 [<ffffffffa04c4dc6>] cpufreq_governor_dbs+0x2ae/0x348 [cpufreq_ondemand]
 [<ffffffff8137af35>] ? sub_preempt_count+0xa3/0xb6
 [<ffffffff812ab760>] __cpufreq_governor+0x89/0xc7
 [<ffffffff812ac54d>] __cpufreq_set_policy+0x18e/0x22a
 [<ffffffff812aca6a>] store_scaling_governor+0x199/0x1ed
 [<ffffffff812ad2a1>] ? handle_update+0x0/0x39
 [<ffffffff813765d5>] ? down_write+0x76/0x7e
 [<ffffffff81370065>] ? do_boot_cpu+0x5ff/0x653
 [<ffffffff812ac39b>] store+0x67/0x8b
 [<ffffffff811579c9>] sysfs_write_file+0xf6/0x12b
 [<ffffffff810fff45>] vfs_write+0xb0/0x10a
 [<ffffffff8110006d>] sys_write+0x4c/0x75
 [<ffffffff81002d9b>] system_call_fastpath+0x16/0x1b
