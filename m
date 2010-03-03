Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab0CCASA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:18:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54569 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751884Ab0CCAR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:17:58 -0500
Date: Tue, 2 Mar 2010 16:16:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: john@calva.com
Cc: bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [Bugme-new] [Bug 15426] New: Running many copies of bonnie++ on
 different filesystems seems to deadlock in sync
Message-Id: <20100302161627.bf02d0a2.akpm@linux-foundation.org>
In-Reply-To: <bug-15426-10286@http.bugzilla.kernel.org/>
References: <bug-15426-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Tue, 2 Mar 2010 16:31:03 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=15426
> 
>            Summary: Running many copies of bonnie++ on different
>                     filesystems seems to deadlock in sync
>            Product: File System
>            Version: 2.5
>     Kernel Version: 2.6.32
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: VFS
>         AssignedTo: fs_vfs@kernel-bugs.osdl.org
>         ReportedBy: john@calva.com
>         Regression: No
> 
> 
> I create 8 ext3 filesystems on 8 disks and run a copy of bonnie++ on each
> filesystem.  All but two or three of the Bonnie++ processes seem to hang in
> sync and I get log messages like:
> 
> [ 1557.377626] INFO: task bonnie:2503 blocked for more than 120 seconds.
> [ 1557.377693] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> message.
> [ 1557.377775] bonnie        D 0000000000000000     0  2503   2489 0x00000000
> [ 1557.377778]  ffffffff8144b1f0 0000000000000082 0000000000000000
> ffff88034ac155c0
> [ 1557.377780]  ffff88033c079880 ffffffff81047f43 000000000000f8a0
> ffff88063b1e9fd8
> [ 1557.377783]  00000000000155c0 00000000000155c0 ffff88063bbe3f90
> ffff88063bbe4288
> [ 1557.377785] Call Trace:
> [ 1557.377787]  [<ffffffff81047f43>] ? finish_task_switch+0x3a/0xa7
> [ 1557.377790]  [<ffffffff812ee653>] ? __mutex_lock_common+0x10b/0x17b
> [ 1557.377792]  [<ffffffff812ee77b>] ? mutex_lock+0x1a/0x31
> [ 1557.377794]  [<ffffffff8110a3cd>] ? sync_filesystems+0x13/0xe3
> [ 1557.377796]  [<ffffffff8110a4d8>] ? sys_sync+0x12/0x2e
> [ 1557.377799]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
> 

When the system is stuck, please run

	echo w > /proc/sysrq-trigger

or, equivalently, hit `alt-sysrq-w'.

This will emit huge amounts of stack traces into the system logs and
onto the console.  There's no need to send all of them - please
identify typical-looking ones and then send them in reply to this
email.  Email clients like to wordwrap these traces - please try to
prevent that.

Thanks.
