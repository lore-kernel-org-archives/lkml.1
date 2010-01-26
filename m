Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819Ab0AZSYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab0AZSYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 13:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646Ab0AZSYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 13:24:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57600 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790Ab0AZSYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 13:24:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Locking Problem in 2.6.33-rc5
Date: Tue, 26 Jan 2010 19:25:13 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <4B5F1F8C.6090406@lwfinger.net>
In-Reply-To: <4B5F1F8C.6090406@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001261925.13249.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 January 2010, Larry Finger wrote:
> On suspend to RAM, I get the following recursive locking message:
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.33-rc5-Linus-dirty #173
> ---------------------------------------------
> sh/3488 is trying to acquire lock:
>    (s_active){++++.+}, at: [<ffffffff81167413>] sysfs_addrm_finish+0x43/0x70
> 
> but task is already holding lock:
>    (s_active){++++.+}, at: [<ffffffff8116771d>] sysfs_get_active_two+0x3d/0x60
> 
> other info that might help us debug this:
> 4 locks held by sh/3488:
>    #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff81165b7f>] 
> sysfs_write_file+0x3f/0x160
>    #1:  (s_active){++++.+}, at: [<ffffffff8116771d>] sysfs_get_active_two+0x3d/0x60
>    #2:  (s_active){++++.+}, at: [<ffffffff81167702>] sysfs_get_active_two+0x22/0x60
>    #3:  (dbs_mutex){+.+.+.}, at: [<ffffffff81271517>] 
> cpufreq_governor_dbs+0xe7/0x480
> 
> stack backtrace:
> Pid: 3488, comm: sh Not tainted 2.6.33-rc5-Linus-dirty #173
> Call Trace:
>    [<ffffffff8107c36b>] __lock_acquire+0xf6b/0x1d30
>    [<ffffffff81078e9f>] ? lockdep_init_map+0x5f/0x5d0
>    [<ffffffff8107d1cb>] lock_acquire+0x9b/0x120
>    [<ffffffff81167413>] ? sysfs_addrm_finish+0x43/0x70
>    [<ffffffff81166ba3>] sysfs_deactivate+0xc3/0x110
>    [<ffffffff81167413>] ? sysfs_addrm_finish+0x43/0x70
>    [<ffffffff81167413>] sysfs_addrm_finish+0x43/0x70
>    [<ffffffff81165206>] sysfs_hash_and_remove+0x56/0x80
>    [<ffffffff8116895f>] sysfs_remove_group+0x4f/0xf0
>    [<ffffffff8127152b>] cpufreq_governor_dbs+0xfb/0x480
>    [<ffffffff8107a8dd>] ? trace_hardirqs_on_caller+0x14d/0x190
>    [<ffffffff8107a92d>] ? trace_hardirqs_on+0xd/0x10
>    [<ffffffff8126e314>] __cpufreq_governor+0x94/0x160
>    [<ffffffff8126f84f>] __cpufreq_set_policy+0x11f/0x180
>    [<ffffffff8126fc66>] store_scaling_governor+0xc6/0x200
>    [<ffffffff81270530>] ? handle_update+0x0/0x10
>    [<ffffffff8126f702>] store+0x62/0x90
>    [<ffffffff81165c21>] sysfs_write_file+0xe1/0x160
>    [<ffffffff8110b0c8>] vfs_write+0xb8/0x180
>    [<ffffffff8110b26c>] sys_write+0x4c/0x80
>    [<ffffffff81002dab>] system_call_fastpath+0x16/0x1b

Does the patch at http://patchwork.kernel.org/patch/70461/ fix it?

Rafael
