Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094Ab0AKURa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab0AKURa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989Ab0AKURa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:17:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35109 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997Ab0AKUR2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:17:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: 2.6.33-rc3 -- INFO: possible recursive locking --  (s_active){++++.+}, at: [<c10d2941>] sysfs_hash_and_remove+0x3d/0x4f
Date: Mon, 11 Jan 2010 21:18:07 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: =?utf-8?q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>, Tejun Heo <tj@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
References: <a44ae5cd1001060454g22fb5a0ay8185bc680cd4fc67@mail.gmail.com> <201001101935.31882.rjw@sisk.pl> <m1wrzpbcmi.fsf@fess.ebiederm.org>
In-Reply-To: <m1wrzpbcmi.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001112118.07275.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 January 2010, Eric W. Biederman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Sunday 10 January 2010, Eric W. Biederman wrote:
> >> Américo Wang <xiyou.wangcong@gmail.com> writes:
> >> 
> >> > On Sun, Jan 10, 2010 at 4:47 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> >> >>
> >> >> On Wed, Jan 06, 2010 at 07:54:59AM -0500, Miles Lane wrote:
> >> >> >[ 6967.926563] ACPI: Preparing to enter system sleep state S3
> >> >> >[ 6967.956156] Disabling non-boot CPUs ...
> >> >> >[ 6967.970401]
> >> >> >[ 6967.970408] =============================================
> >> >> >[ 6967.970419] [ INFO: possible recursive locking detected ]
> >> >> >[ 6967.970431] 2.6.33-rc2-git6 #27
> >> >> >[ 6967.970439] ---------------------------------------------
> >> >> >[ 6967.970450] pm-suspend/22147 is trying to acquire lock:
> >> >> >[ 6967.970460]  (s_active){++++.+}, at: [<c10d2941>]
> >> >> >sysfs_hash_and_remove+0x3d/0x4f
> >> >> >[ 6967.970493]
> >> >> >[ 6967.970497] but task is already holding lock:
> >> >> >[ 6967.970506]  (s_active){++++.+}, at: [<c10d4110>]
> >> >> >sysfs_get_active_two+0x16/0x36
> >> >> >[ 6967.970531]
> >> >> >[ 6967.970535] other info that might help us debug this:
> >> >> >[ 6967.970547] 6 locks held by pm-suspend/22147:
> >> >> >[ 6967.970556]  #0:  (&buffer->mutex){+.+.+.}, at: [<c10d2ff3>]
> >> >> >sysfs_write_file+0x25/0xeb
> >> >> >[ 6967.970584]  #1:  (s_active){++++.+}, at: [<c10d4110>]
> >> >> >sysfs_get_active_two+0x16/0x36
> >> >> >[ 6967.970612]  #2:  (s_active){++++.+}, at: [<c10d411b>]
> >> >> >sysfs_get_active_two+0x21/0x36
> >> >> >[ 6967.970639]  #3:  (pm_mutex){+.+.+.}, at: [<c1056f00>] enter_state+0x26/0x114
> >> >> >[ 6967.970668]  #4:  (cpu_add_remove_lock){+.+.+.}, at: [<c102ea10>]
> >> >> >cpu_maps_update_begin+0xf/0x11
> >> >> >[ 6967.970697]  #5:  (cpu_hotplug.lock){+.+.+.}, at: [<c102ea3e>]
> >> >> >cpu_hotplug_begin+0x1d/0x40
> >> >> >[ 6967.970724]
> >> >> >[ 6967.970728] stack backtrace:
> >> >> >[ 6967.970740] Pid: 22147, comm: pm-suspend Not tainted 2.6.33-rc2-git6 #27
> >> >> >[ 6967.970751] Call Trace:
> >> >> >[ 6967.970771]  [<c12cc9bf>] ? printk+0xf/0x18
> >> >> >[ 6967.970791]  [<c104dcdb>] __lock_acquire+0x817/0xb6d
> >> >> >[ 6967.970812]  [<c104cbb2>] ? mark_held_locks+0x43/0x5b
> >> >> >[ 6967.970831]  [<c104cf4c>] ? debug_check_no_locks_freed+0xfd/0x107
> >> >> >[ 6967.970851]  [<c104ce1a>] ? trace_hardirqs_on_caller+0x108/0x130
> >> >> >[ 6967.970871]  [<c104e08d>] lock_acquire+0x5c/0x73
> >> >> >[ 6967.970890]  [<c10d2941>] ? sysfs_hash_and_remove+0x3d/0x4f
> >> >> >[ 6967.970910]  [<c10d3ee6>] sysfs_addrm_finish+0x9a/0xfe
> >> >> >[ 6967.970929]  [<c10d2941>] ? sysfs_hash_and_remove+0x3d/0x4f
> >> >> >[ 6967.970953]  [<c10d2941>] sysfs_hash_and_remove+0x3d/0x4f
> >> >> >[ 6967.970974]  [<c10d4c11>] sysfs_remove_group+0x52/0x81
> >> >> >[ 6967.970993]  [<c12cab5d>] mc_cpu_callback+0x73/0x9a
> >> >> >[ 6967.971014]  [<c10427d0>] notifier_call_chain+0x51/0x78
> >> >> >[ 6967.971034]  [<c104285c>] __raw_notifier_call_chain+0xe/0x10
> >> >> >[ 6967.971054]  [<c12c094b>] _cpu_down+0x7a/0x235
> >> >> >[ 6967.971074]  [<c102eab9>] disable_nonboot_cpus+0x58/0xe0
> >> >> >[ 6967.971093]  [<c1056e20>] suspend_devices_and_enter+0xb9/0x173
> >> >> >[ 6967.971094]  [<c1056fa2>] enter_state+0xc8/0x114
> >> >> >[ 6967.971094]  [<c1056855>] state_store+0x93/0xa7
> >> >> >[ 6967.971094]  [<c10567c2>] ? state_store+0x0/0xa7
> >> >> >[ 6967.971094]  [<c1140595>] kobj_attr_store+0x16/0x22
> >> >> >[ 6967.971094]  [<c10d308e>] sysfs_write_file+0xc0/0xeb
> >> >> >[ 6967.971094]  [<c10d2fce>] ? sysfs_write_file+0x0/0xeb
> >> >> >[ 6967.971094]  [<c109511c>] vfs_write+0x80/0xdf
> >> >> >[ 6967.971094]  [<c109520f>] sys_write+0x3b/0x5d
> >> >> >[ 6967.971094]  [<c1002897>] sysenter_do_call+0x12/0x36
> >> >> >[ 6967.973262] CPU 1 is now offline
> >> >> >[ 6967.973271] lockdep: fixing up alternatives.
> >> >>
> >> >> Hmmm, does reverting commit 846f99749ab68b help?
> >> >>
> >> >
> >> > Of course it will help, but the problem is not that. That patch helps
> >> > us to detect such a problem... I am still investigating. :-/
> >> 
> >> This looks like this is triggered by a write to a sysfs file,
> >> so the solution is probably to call schedule_work so the
> >> suspend can happen outside the context of sysfs.
> >> 
> >> The typical scenario that triggers this is:
> >> - A lock is held while removing a sysfs attribute.
> >> - The same lock is grabbed inside the sysfs attribute.
> >> 
> >> I think we do that with the cpu_hotplug.lock
> >> 
> >> In this case it looks like this might be a reach around scenario where
> >> we try and remove the sysfs attribute that triggered the suspend.
> >
> > We don't do that.
> 
> Looking at this a bit more.  Both this case and Arjuns (which is
> completely different chain of events) seem to have in common people
> removing sysfs attributes from within the contexts of a sysfs
> attribute.  As lockdep treats all instances of a lock as the same lock
> it appears to be picking up false positives.
> 
> The classic mutex_lock_nested work around that introduces different lock
> classes can not be used directly here as the code is too deeply nested.
> 
> The first problem this lockdep warning found was indeed a real and
> subtle bug, I think there are several other real bugs this annotation
> is capable of finding much easier than manual audits of the code, so I
> don't want to remove the lockdep annotations.
> 
> Changing the cpu governor is especially interesting because it appears
> that this coming from a sysfs attribute that will be removed if/when
> the cpu is hotplug removed.  Which says to me that we really would like
> to have a couple of different lockdep classes in use, for essentially the
> same lock.
> 
> So I think the thing to do is to add a lockdep subclass field to sysfs
> attributes so that we can take teach lockdep to distinguish between
> the handful of these that are safe because they are different instances
> of the same lock.
> 
> How does the patch below look?

Makes sense for me.

Rafael


> From: Eric W. Biederman <ebiederm@xmission.com>
> Date: Sun, 10 Jan 2010 18:13:35 -0800
> Subject: [PATCH] sysfs: Add support for lockdep subclasses to s_active
> 
> We have apparently valid cases where the code for a sysfs attribute
> removes other sysfs attributes.  Without support for subclasses
> lockdep flags a possible recursive lock problem as it figures
> the first sysfs attribute could be attempting to remove itself.
> 
> By adding support for sysfs subclasses we can teach lockdep to
> distinguish between different types of sysfs attributes and not
> get confused.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
