Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187Ab0AKHyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab0AKHyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 02:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038Ab0AKHyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 02:54:24 -0500
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:34021 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751545Ab0AKHyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 02:54:23 -0500
Date: Mon, 11 Jan 2010 18:54:16 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Subject: [lockdep, sysfs]: lockdep compliant when chaging io schedulers
Message-ID: <20100111075416.GF4019@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This output occurred on 2.6.33-rc3 when changing the schedler from cfq to noop.

[  129.838942] =============================================
[  129.839006] [ INFO: possible recursive locking detected ]
[  129.839006] 2.6.33-rc3-dgc #14                           
[  129.839006] ---------------------------------------------
[  129.839006] sh/3921 is trying to acquire lock:           
[  129.839006]  (s_active){++++.+}, at: [<ffffffff8117fa7e>] sysfs_remove_dir+0x7e/0xa0
[  129.839006]                                                                         
[  129.839006] but task is already holding lock:                                       
[  129.839006]  (s_active){++++.+}, at: [<ffffffff8117f4fd>] sysfs_get_active_two+0x3d/0x60
[  129.839006]                                                                             
[  129.839006] other info that might help us debug this:                                   
[  129.839006] 4 locks held by sh/3921:
[  129.839006]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff8117e0b9>] sysfs_write_file+0x49/0x150
[  129.839006]  #1:  (s_active){++++.+}, at: [<ffffffff8117f4fd>] sysfs_get_active_two+0x3d/0x60
[  129.839006]  #2:  (s_active){++++.+}, at: [<ffffffff8117f4e7>] sysfs_get_active_two+0x27/0x60
[  129.839006]  #3:  (&q->sysfs_lock){+.+.+.}, at: [<ffffffff813cb1e4>] queue_attr_store+0x54/0xb0
[  129.839006]
[  129.839006] stack backtrace:
[  129.839006] Pid: 3921, comm: sh Not tainted 2.6.33-rc3-dgc #14
[  129.839006] Call Trace:
[  129.839006]  [<ffffffff81084563>] __lock_acquire+0x1503/0x17a0
[  129.839006]  [<ffffffff81082ea2>] ? debug_check_no_locks_freed+0xa2/0x160
[  129.839006]  [<ffffffff81082795>] ? trace_hardirqs_on_caller+0x135/0x180
[  129.839006]  [<ffffffff810848ce>] lock_acquire+0xce/0x100
[  129.839006]  [<ffffffff8117fa7e>] ? sysfs_remove_dir+0x7e/0xa0
[  129.839006]  [<ffffffff8117f90c>] sysfs_addrm_finish+0xec/0x180
[  129.839006]  [<ffffffff8117fa7e>] ? sysfs_remove_dir+0x7e/0xa0
[  129.839006]  [<ffffffff810824c3>] ? mark_held_locks+0x73/0x90
[  129.839006]  [<ffffffff81073180>] ? cpu_clock+0x50/0x60
[  129.839006]  [<ffffffff8117fa7e>] sysfs_remove_dir+0x7e/0xa0
[  129.839006]  [<ffffffff813dd606>] kobject_del+0x16/0x40
[  129.839006]  [<ffffffff813c2246>] elv_iosched_store+0xf6/0x260
[  129.839006]  [<ffffffff813cb1fa>] queue_attr_store+0x6a/0xb0
[  129.839006]  [<ffffffff8117e149>] sysfs_write_file+0xd9/0x150
[  129.839006]  [<ffffffff8111c072>] vfs_write+0xb2/0xf0
[  129.839006]  [<ffffffff8111c1a5>] sys_write+0x55/0x90
[  129.839006]  [<ffffffff81002fdb>] system_call_fastpath+0x16/0x1b

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
