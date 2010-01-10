Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861Ab0AJRX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab0AJRX3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 12:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818Ab0AJRX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 12:23:29 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:53831 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab0AJRX2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 12:23:28 -0500
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.33-rc3 -- INFO: possible recursive locking --  (s_active){++++.+}, at: [<c10d2941>] sysfs_hash_and_remove+0x3d/0x4f
References: <a44ae5cd1001060454g22fb5a0ay8185bc680cd4fc67@mail.gmail.com>
	<20100110084704.GC3005@hack>
	<2375c9f91001100058w4bac1cf9s183fc37eafbfde75@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 10 Jan 2010 09:23:15 -0800
In-Reply-To: <2375c9f91001100058w4bac1cf9s183fc37eafbfde75@mail.gmail.com>
 (=?utf-8?Q?=22Am=C3=A9rico?= Wang"'s message of "Sun\, 10 Jan 2010
 16\:58\:56 +0800")
Message-ID: <m13a2dho1o.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang <xiyou.wangcong@gmail.com> writes:

> On Sun, Jan 10, 2010 at 4:47 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>>
>> On Wed, Jan 06, 2010 at 07:54:59AM -0500, Miles Lane wrote:
>> >[ 6967.926563] ACPI: Preparing to enter system sleep state S3
>> >[ 6967.956156] Disabling non-boot CPUs ...
>> >[ 6967.970401]
>> >[ 6967.970408] =============================================
>> >[ 6967.970419] [ INFO: possible recursive locking detected ]
>> >[ 6967.970431] 2.6.33-rc2-git6 #27
>> >[ 6967.970439] ---------------------------------------------
>> >[ 6967.970450] pm-suspend/22147 is trying to acquire lock:
>> >[ 6967.970460]  (s_active){++++.+}, at: [<c10d2941>]
>> >sysfs_hash_and_remove+0x3d/0x4f
>> >[ 6967.970493]
>> >[ 6967.970497] but task is already holding lock:
>> >[ 6967.970506]  (s_active){++++.+}, at: [<c10d4110>]
>> >sysfs_get_active_two+0x16/0x36
>> >[ 6967.970531]
>> >[ 6967.970535] other info that might help us debug this:
>> >[ 6967.970547] 6 locks held by pm-suspend/22147:
>> >[ 6967.970556]  #0:  (&buffer->mutex){+.+.+.}, at: [<c10d2ff3>]
>> >sysfs_write_file+0x25/0xeb
>> >[ 6967.970584]  #1:  (s_active){++++.+}, at: [<c10d4110>]
>> >sysfs_get_active_two+0x16/0x36
>> >[ 6967.970612]  #2:  (s_active){++++.+}, at: [<c10d411b>]
>> >sysfs_get_active_two+0x21/0x36
>> >[ 6967.970639]  #3:  (pm_mutex){+.+.+.}, at: [<c1056f00>] enter_state+0x26/0x114
>> >[ 6967.970668]  #4:  (cpu_add_remove_lock){+.+.+.}, at: [<c102ea10>]
>> >cpu_maps_update_begin+0xf/0x11
>> >[ 6967.970697]  #5:  (cpu_hotplug.lock){+.+.+.}, at: [<c102ea3e>]
>> >cpu_hotplug_begin+0x1d/0x40
>> >[ 6967.970724]
>> >[ 6967.970728] stack backtrace:
>> >[ 6967.970740] Pid: 22147, comm: pm-suspend Not tainted 2.6.33-rc2-git6 #27
>> >[ 6967.970751] Call Trace:
>> >[ 6967.970771]  [<c12cc9bf>] ? printk+0xf/0x18
>> >[ 6967.970791]  [<c104dcdb>] __lock_acquire+0x817/0xb6d
>> >[ 6967.970812]  [<c104cbb2>] ? mark_held_locks+0x43/0x5b
>> >[ 6967.970831]  [<c104cf4c>] ? debug_check_no_locks_freed+0xfd/0x107
>> >[ 6967.970851]  [<c104ce1a>] ? trace_hardirqs_on_caller+0x108/0x130
>> >[ 6967.970871]  [<c104e08d>] lock_acquire+0x5c/0x73
>> >[ 6967.970890]  [<c10d2941>] ? sysfs_hash_and_remove+0x3d/0x4f
>> >[ 6967.970910]  [<c10d3ee6>] sysfs_addrm_finish+0x9a/0xfe
>> >[ 6967.970929]  [<c10d2941>] ? sysfs_hash_and_remove+0x3d/0x4f
>> >[ 6967.970953]  [<c10d2941>] sysfs_hash_and_remove+0x3d/0x4f
>> >[ 6967.970974]  [<c10d4c11>] sysfs_remove_group+0x52/0x81
>> >[ 6967.970993]  [<c12cab5d>] mc_cpu_callback+0x73/0x9a
>> >[ 6967.971014]  [<c10427d0>] notifier_call_chain+0x51/0x78
>> >[ 6967.971034]  [<c104285c>] __raw_notifier_call_chain+0xe/0x10
>> >[ 6967.971054]  [<c12c094b>] _cpu_down+0x7a/0x235
>> >[ 6967.971074]  [<c102eab9>] disable_nonboot_cpus+0x58/0xe0
>> >[ 6967.971093]  [<c1056e20>] suspend_devices_and_enter+0xb9/0x173
>> >[ 6967.971094]  [<c1056fa2>] enter_state+0xc8/0x114
>> >[ 6967.971094]  [<c1056855>] state_store+0x93/0xa7
>> >[ 6967.971094]  [<c10567c2>] ? state_store+0x0/0xa7
>> >[ 6967.971094]  [<c1140595>] kobj_attr_store+0x16/0x22
>> >[ 6967.971094]  [<c10d308e>] sysfs_write_file+0xc0/0xeb
>> >[ 6967.971094]  [<c10d2fce>] ? sysfs_write_file+0x0/0xeb
>> >[ 6967.971094]  [<c109511c>] vfs_write+0x80/0xdf
>> >[ 6967.971094]  [<c109520f>] sys_write+0x3b/0x5d
>> >[ 6967.971094]  [<c1002897>] sysenter_do_call+0x12/0x36
>> >[ 6967.973262] CPU 1 is now offline
>> >[ 6967.973271] lockdep: fixing up alternatives.
>>
>> Hmmm, does reverting commit 846f99749ab68b help?
>>
>
> Of course it will help, but the problem is not that. That patch helps
> us to detect such a problem... I am still investigating. :-/

This looks like this is triggered by a write to a sysfs file,
so the solution is probably to call schedule_work so the
suspend can happen outside the context of sysfs.

The typical scenario that triggers this is:
- A lock is held while removing a sysfs attribute.
- The same lock is grabbed inside the sysfs attribute.

I think we do that with the cpu_hotplug.lock

In this case it looks like this might be a reach around scenario where
we try and remove the sysfs attribute that triggered the suspend.

Eric


