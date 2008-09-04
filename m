Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbYIDEmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbYIDEmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 00:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbYIDEmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 00:42:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941AbYIDEmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 00:42:32 -0400
Date: Wed, 3 Sep 2008 21:42:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: linux-next: Tree for September 3
Message-Id: <20080903214225.d7831142.akpm@linux-foundation.org>
In-Reply-To: <20080903191619.6b6b230e.sfr@canb.auug.org.au>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008 19:16:19 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

ug.  What a lot of bugs.

acpi:

calling  param_sysfs_init+0x0/0x153
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:465 sysfs_add_one+0x2a/0x36()
sysfs: duplicate filename 'acpi' can not be created
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.27-rc5 #4
 [<c01208e4>] warn_slowpath+0x4e/0x77
 [<c013e30f>] ? __lock_acquire+0x671/0x6b7
 [<c013a79e>] ? trace_hardirqs_off+0xb/0xd
 [<c0108621>] ? native_sched_clock+0x82/0x96
 [<c018a1de>] ? ifind+0x7e/0x88
 [<c032fee9>] ? _spin_unlock+0x27/0x3c
 [<c018a1de>] ? ifind+0x7e/0x88
 [<c01b7262>] ? sysfs_find_dirent+0x16/0x27
 [<c01b72fc>] sysfs_add_one+0x2a/0x36
 [<c01b779d>] create_dir+0x43/0x71
 [<c01b77f8>] sysfs_create_dir+0x2d/0x41
 [<c032fee9>] ? _spin_unlock+0x27/0x3c
 [<c01fa600>] kobject_add_internal+0xb3/0x157
 [<c01fa74f>] kobject_add_varg+0x35/0x41
 [<c01fa8cd>] kobject_init_and_add+0x26/0x28
 [<c049160c>] kernel_param_sysfs_setup+0x4c/0x99
 [<c0491750>] param_sysfs_init+0xf7/0x153
 [<c0101125>] _stext+0x3d/0x11d
 [<c0491659>] ? param_sysfs_init+0x0/0x153
 [<c011c8af>] ? wake_up_process+0xf/0x11
 [<c012d8b9>] ? start_workqueue_thread+0x1d/0x20
 [<c012de97>] ? __create_workqueue_key+0xe4/0xfc
 [<c0482767>] kernel_init+0xeb/0x152
 [<c048267c>] ? kernel_init+0x0/0x152
 [<c01046ef>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace 4eaa2a86a8e2da22 ]---
kobject_add_internal failed for acpi with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc5 #4
 [<c01fa66c>] kobject_add_internal+0x11f/0x157
 [<c01fa74f>] kobject_add_varg+0x35/0x41
 [<c01fa8cd>] kobject_init_and_add+0x26/0x28
 [<c049160c>] kernel_param_sysfs_setup+0x4c/0x99
 [<c0491750>] param_sysfs_init+0xf7/0x153
 [<c0101125>] _stext+0x3d/0x11d
 [<c0491659>] ? param_sysfs_init+0x0/0x153
 [<c011c8af>] ? wake_up_process+0xf/0x11
 [<c012d8b9>] ? start_workqueue_thread+0x1d/0x20
 [<c012de97>] ? __create_workqueue_key+0xe4/0xfc
 [<c0482767>] kernel_init+0xeb/0x152
 [<c048267c>] ? kernel_init+0x0/0x152
 [<c01046ef>] kernel_thread_helper+0x7/0x10
 =======================
Module 'acpi' failed to be added to sysfs, error number -17


there seem to have been tens or even hunderds of reports of this.  Odd.
