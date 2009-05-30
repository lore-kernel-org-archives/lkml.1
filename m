Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbZE3E03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbZE3E03 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 00:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbZE3E0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 00:26:22 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:62679 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbZE3E0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 00:26:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=CefHiXePtlSSDql6yK0/+lj98vsecdsS60O/1KQzxNOSiu6WnJ4aLsen9FLzjMb3IG
         cZb0sfjaBWQo5daywfPZQjRbV0yTMo9qm9x+C7zDgJC5voMnqUc7jaq7zw68+mZkl/bo
         PQpNvENqXJ27ISDx9VGpjDnahjAozDhc4m9ew=
MIME-Version: 1.0
Date: Fri, 29 May 2009 22:26:22 -0600
Message-ID: <9b1675090905292126k502b796cy6724fde2d09cc4c4@mail.gmail.com>
Subject: pdflush blocked for more than 120 seconds
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know how this happened, or how to reproduce it.  But, I
thought I should maybe report it, in case anyone here might know what
the problem could be.  At the time, I was using 2.6.30-rc3.  As of
today I am using 2.6.30-rc7, so I don't know if it will happen again.

May 27 01:56:12 tdamac INFO: task pdflush:15370 blocked for more than
120 seconds.
May 27 01:56:12 tdamac "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 27 01:56:12 tdamac pdflush       D ffff8800518a0000     0 15370      2
May 27 01:56:12 tdamac ffff880025023b50 0000000000000046
0000000025023a90 000000000000d7a0
May 27 01:56:12 tdamac 0000000000004000 0000000000011440
000000000000ca78 ffff880045e71568
May 27 01:56:12 tdamac ffff880045e7156c ffff8800518a0000
ffff880067f54230 ffff8800518a0380
May 27 01:56:12 tdamac Call Trace:
May 27 01:56:12 tdamac [<ffffffff80687d1b>] ? __mutex_lock_slowpath+0xe2/0x124
May 27 01:56:12 tdamac [<ffffffff80687d13>] __mutex_lock_slowpath+0xda/0x124
May 27 01:56:12 tdamac [<ffffffff8068809e>] mutex_lock+0x1e/0x36
May 27 01:56:12 tdamac [<ffffffff803087ae>] flush_commit_list+0x150/0x689
May 27 01:56:12 tdamac [<ffffffff8022f8e5>] ? __wake_up+0x43/0x50
May 27 01:56:12 tdamac [<ffffffff8030ad8a>] do_journal_end+0xb4a/0xd6c
May 27 01:56:12 tdamac [<ffffffff8023053d>] ? dequeue_entity+0x1b/0x1df
May 27 01:56:12 tdamac [<ffffffff8030b020>] journal_end_sync+0x74/0x7d
May 27 01:56:12 tdamac [<ffffffff802fd2fd>] reiserfs_sync_fs+0x41/0x67
May 27 01:56:12 tdamac [<ffffffff80688091>] ? mutex_lock+0x11/0x36
May 27 01:56:12 tdamac [<ffffffff802fd331>] reiserfs_write_super+0xe/0x10
May 27 01:56:12 tdamac [<ffffffff802a532a>] sync_supers+0x61/0xa6
May 27 01:56:12 tdamac [<ffffffff8027e140>] wb_kupdate+0x32/0x128
May 27 01:56:12 tdamac [<ffffffff8027ee7c>] pdflush+0x140/0x21f
May 27 01:56:12 tdamac [<ffffffff8027e10e>] ? wb_kupdate+0x0/0x128
May 27 01:56:12 tdamac [<ffffffff8027ed3c>] ? pdflush+0x0/0x21f
May 27 01:56:12 tdamac [<ffffffff8024fb26>] kthread+0x56/0x83
May 27 01:56:12 tdamac [<ffffffff8020beba>] child_rip+0xa/0x20
May 27 01:56:12 tdamac [<ffffffff8024fad0>] ? kthread+0x0/0x83
May 27 01:56:12 tdamac [<ffffffff8020beb0>] ? child_rip+0x0/0x20
