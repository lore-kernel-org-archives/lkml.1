Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831Ab0AJAIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab0AJAIK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 19:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752Ab0AJAIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 19:08:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:52491 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab0AJAIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 19:08:07 -0500
Date: Sat, 9 Jan 2010 16:10:49 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.33-rc3 -- INFO: possible recursive locking --
 (s_active){++++.+},  at: [<c10d2941>] sysfs_hash_and_remove+0x3d/0x4f
Message-ID: <20100109161049.773a84a6@infradead.org>
In-Reply-To: <a44ae5cd1001060454g22fb5a0ay8185bc680cd4fc67@mail.gmail.com>
References: <a44ae5cd1001060454g22fb5a0ay8185bc680cd4fc67@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jan 2010 07:54:59 -0500
Miles Lane <miles.lane@gmail.com> wrote:

> [ 6967.926563] ACPI: Preparing to enter system sleep state S3
> [ 6967.956156] Disabling non-boot CPUs ...
> [ 6967.970401]
> [ 6967.970408] =============================================
> [ 6967.970419] [ INFO: possible recursive locking detected ]
> [ 6967.970431] 2.6.33-rc2-git6 #27


I get the same on changing cpufreq governor.....


[  165.356101] bash/1965 is trying to acquire lock:
[  165.356214]  (s_active){++++.+}, at: [<c04ea0a9>]
sysfs_hash_and_remove+0x3d/0x4f [  165.356257] 
[  165.356257] but task is already holding lock:
[  165.356257]  (s_active){++++.+}, at: [<c04eba15>]
sysfs_get_active_two+0x16/0x35 [  165.356257] 
[  165.356257] other info that might help us debug this:
[  165.356257] 4 locks held by bash/1965:
[  165.356257]  #0:  (&buffer->mutex){+.+.+.}, at: [<c04ea81f>]
sysfs_write_file+0x25/0xeb [  165.356257]  #1:  (s_active){++++.+}, at:
[<c04eba15>] sysfs_get_active_two+0x16/0x35 [  165.356257]  #2:
(s_active){++++.+}, at: [<c04eba20>] sysfs_get_active_two+0x21/0x35
[  165.356257]  #3:  (dbs_mutex){+.+.+.}, at: [<c066a2e2>]
cpufreq_governor_dbs+0x366/0x3fe [  165.356257] [  165.356257] stack
backtrace: [  165.356257] Pid: 1965, comm: bash Not tainted 2.6.33-rc3
#83 [  165.356257] Call Trace:
[  165.356257]  [<c07801d4>] ? printk+0xf/0x13
[  165.356257]  [<c04556ef>] __lock_acquire+0xc8a/0x13a7
[  165.356257]  [<c0454081>] ? mark_held_locks+0x43/0x5b
[  165.356257]  [<c04543de>] ? debug_check_no_locks_freed+0xfd/0x107
[  165.356257]  [<c0455e95>] lock_acquire+0x89/0xa2
[  165.356257]  [<c04ea0a9>] ? sysfs_hash_and_remove+0x3d/0x4f
[  165.356257]  [<c04eb7d4>] sysfs_addrm_finish+0x8f/0x100
[  165.356257]  [<c04ea0a9>] ? sysfs_hash_and_remove+0x3d/0x4f
[  165.356257]  [<c04ea0a9>] sysfs_hash_and_remove+0x3d/0x4f
[  165.356257]  [<c04ec5ae>] sysfs_remove_group+0x76/0xa5
[  165.356257]  [<c066a2f2>] cpufreq_governor_dbs+0x376/0x3fe
[  165.356257]  [<c0452a63>] ? trace_hardirqs_off+0xb/0xd
[  165.356257]  [<c044963c>] ? cpu_clock+0x2d/0x4e
[  165.356257]  [<c0452a85>] ? lock_release_holdtime+0x20/0x17a



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
