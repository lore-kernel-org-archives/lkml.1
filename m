Return-Path: <linux-kernel-owner+w=401wt.eu-S1756200Ab0AMSiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab0AMSiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 13:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521Ab0AMSiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 13:38:11 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:36125 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab0AMSiJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 13:38:09 -0500
To: Miles Lane <miles.lane@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: 2.6.33-rc3 -- INFO: possible recursive locking --  (s_active){++++.+}, at: [<c10d2941>] sysfs_hash_and_remove+0x3d/0x4f
References: <a44ae5cd1001060454g22fb5a0ay8185bc680cd4fc67@mail.gmail.com>
	<2375c9f91001100058w4bac1cf9s183fc37eafbfde75@mail.gmail.com>
	<m13a2dho1o.fsf@fess.ebiederm.org> <201001101935.31882.rjw@sisk.pl>
	<m1wrzpbcmi.fsf@fess.ebiederm.org> <4B4BC2D3.7070003@kernel.org>
	<m11vhw6u3k.fsf@fess.ebiederm.org>
	<a44ae5cd1001130817v7a3ffbc9yc83d7cc701f8620@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 13 Jan 2010 10:37:49 -0800
In-Reply-To: <a44ae5cd1001130817v7a3ffbc9yc83d7cc701f8620@mail.gmail.com> (Miles Lane's message of "Wed\, 13 Jan 2010 11\:17\:28 -0500")
Message-ID: <m1my0h97gi.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miles Lane <miles.lane@gmail.com> writes:

> On Mon, Jan 11, 2010 at 7:32 PM, Eric W. Biederman <ebiederm@xmission.com>
> wrote:
>
>     Tejun Heo <tj@kernel.org> writes:
>
>     > On 01/11/2010 11:26 AM, Eric W. Biederman wrote:
>     >> From: Eric W. Biederman <ebiederm@xmission.com>
>     >> Date: Sun, 10 Jan 2010 18:13:35 -0800
>     >> Subject: [PATCH] sysfs: Add support for lockdep subclasses to s_active
>     >>
>     >> We have apparently valid cases where the code for a sysfs attribute
>     >> removes other sysfs attributes.  Without support for subclasses
>     >> lockdep flags a possible recursive lock problem as it figures
>     >> the first sysfs attribute could be attempting to remove itself.
>     >>
>     >> By adding support for sysfs subclasses we can teach lockdep to
>     >> distinguish between different types of sysfs attributes and not
>     >> get confused.
>     >>
>     >> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>     >
>     > Acked-by: Tejun Heo <tj@kernel.org>
>
>     Now if I can just get a Tested-by  this patch will be all set ;)
>
>
> Not sure if this is related to your patch.  It doesn't look like it.
> When I tried to suspend, I got the following:

There doesn't appear to be any sysfs involvement in any of those call
traces. Going farther the failure mode of the races I have been trying
to warn about is a silent deadlock.  I don't have a clue what would
have triggered this.

Eric


>
> PM: Syncing filesystems ... d? spin_lock_irq+0x8/0xa
>   [<c105c3ea>] ? lock_acquire+0xa3/0xcd
>   [<c116eb75>] ? do_raw_spin_lock+0x60/0x122
>   [<c1041d0a>] ? spin_lock_irq+0x8/0xa
>   [<c12f6347>] ? _raw_spin_unlock_irq+0x22/0x57
>   [<c105b09d>] ? trace_hardirqs_on_caller+0x119/0x141
>   [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
>   [<c12f6370>] ? _raw_spin_unlock_irq+0x4b/0x57
>   [<c1041d14>] ? spin_unlock_irq+0x8/0xa
>   [<c1041edc>] ? sigprocmask+0xbe/0xc6
>   [<c10c3b1b>] ? sys_ppoll+0xe1/0xf8
>   [<c100321c>] ? sysenter_exit+0xf/0x1f
>   [<c1002cdd>] do_notify_resume+0x23/0x62
>   [<c12f6a3c>] work_notifysig+0x13/0x1b
> cfg80211      S 00000227  2956  3441      2 0x00000000
>   f3774f44 00000086 43681739 00000227 f38d15a0 f38d1854 c1536980 f3774f08
>   c1531ef0 c1536980 f38d1854 c1536980 c105b0d0 f3774f20 c12f6318 f3824a00
>   435e6f3a 00000227 f38d15a0 f3774f44 c104b9ff 00000286 00000000 c2c0d4c0
> Call Trace:
>   [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
>   [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
>   [<c104b9ff>] ? prepare_to_wait+0x4e/0x55
>   [<c1047e63>] worker_thread+0xa1/0x289
>   [<f856f4d2>] ? wdev_cleanup_work+0x0/0xa5 [cfg80211]
>   [<c104b810>] ? autoremove_wake_function+0x0/0x2f
>   [<c1047dc2>] ? worker_thread+0x0/0x289
>   [<c104b4aa>] kthread+0x6a/0x6f
>   [<c104b440>] ? kthread+0x0/0x6f
>   [<c1003742>] kernel_thread_helper+0x6/0x1a
> hd-audio0     S 00000005  3276  3478      2 0x00000000
>   f2e93f44 00000086 4120e090 00000005 f38d2070 f38d2324 c1536980 f2e93f08
>   c1531ef0 c1536980 f38d2324 c1536980 c105b0d0 fffef111 c2c05ef0 00000000
>   41207fac 00000005 f38d2070 f2e93f44 00000000 00000000 00000000 c2c0d5c0
> Call Trace:
>   [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
>   [<c1047e63>] worker_thread+0xa1/0x289
>   [<c12f6321>] ? _raw_spin_unlock_irqrestore+0x7d/0x81
>   [<c104b810>] ? autoremove_wake_function+0x0/0x2f
>   [<c102758b>] ? complete+0x34/0x3e
>   [<c1047dc2>] ? worker_thread+0x0/0x289
>   [<c104b4aa>] kthread+0x6a/0x6f
>   [<c104b440>] ? kthread+0x0/0x6f
>   [<c1003742>] kernel_thread_helper+0x6/0x1a
> phy0          S 00000227  2396  3480      2 0x00000000
>   f2e81f44 00000086 41ecea10 00000227 f38d0ad0 f38d0d84 c1536980 f2e81f08
>   c1531ef0 c1536980 f38d0d84 c1536980 c105b0d0 f2e81f20 c12f6318 00000000
>   41e8dbc7 00000227 f38d0ad0 f2e81f44 c104b9ff 00000286 00000000 c2c0d640
> Call Trace:
>   [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
>   [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
>   [<c104b9ff>] ? prepare_to_wait+0x4e/0x55
>   [<c1047e63>] worker_thread+0xa1/0x289
>   [<f86a54e7>] ? ieee80211_sta_work+0x0/0xcd6 [mac80211]
>   [<c104b810>] ? autoremove_wake_function+0x0/0x2f
>   [<c1047dc2>] ? worker_thread+0x0/0x289
>   [<c104b4aa>] kthread+0x6a/0x6f
>   [<c104b440>] ? kthread+0x0/0x6f
>   [<c1003742>] kernel_thread_helper+0x6/0x1a
> flush-7:0     S 0000022d  1924  3574      2 0x00000000
>   c5e17f14 00000086 9ec1c11b 0000022d 000802be f7166ed4 c1536980 c158cdc0
>   c1531ef0 c1536980 f7166ed4 c1536980 c12f6318 0007fd57 c2c05ef0 00000000
>   9ec12b74 0000022d f7166c20 00000000 00000000 00000000 00000000 c5e17f20
> Call Trace:
>   [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
>   [<c12f4b60>] schedule_timeout+0x85/0xba
>   [<c103eda1>] ? process_timeout+0x0/0xa
>   [<c12f4bd8>] schedule_timeout_interruptible+0x15/0x17
>   [<c10ce1dd>] bdi_writeback_task+0x65/0x84
>   [<c109f684>] ? bdi_start_fn+0x0/0xa4
>   [<c109f6d2>] bdi_start_fn+0x4e/0xa4
>   [<c109f684>] ? bdi_start_fn+0x0/0xa4
>   [<c104b4aa>] kthread+0x6a/0x6f
>   [<c104b440>] ? kthread+0x0/0x6f
>   [<c1003742>] kernel_thread_helper+0x6/0x1a
> flush-8:0     S 0000022d  2240  3575      2 0x00000000
>   c59b8f14 00000086 3f62054c 0000022d 0008012e f7166404 c1536980 f70b0000
>   c1531ef0 c1536980 f7166404 c1536980 c12f6318 0007f038 c2e05ef0 00000000
>   3f615a75 0000022d f7166150 00000001 00000000 00000000 00000000 c59b8f20
> Call Trace:
>   [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
>   [<c12f4b60>] schedule_timeout+0x85/0xba
>   [<c103eda1>] ? process_timeout+0x0/0xa
>   [<c12f4bd8>] schedule_timeout_interruptible+0x15/0x17
>   [<c10ce1dd>] bdi_writeback_task+0x65/0x84
>   [<c109f684>] ? bdi_start_fn+0x0/0xa4
>   [<c109f6d2>] bdi_start_fn+0x4e/0xa4
>   [<c109f684>] ? bdi_start_fn+0x0/0xa4
>   [<c104b4aa>] kthread+0x6a/0x6f
>   [<c104b440>] ? kthread+0x0/0x6f
>   [<c1003742>] kernel_thread_helper+0x6/0x1a
> dd            D 00000228  1928  3597      1 0x00000000
>   c5a06e5c 00000086 fea63f68 00000228 c1052065 f3ff0d84 c1536980 00000000
>   c1531ef0 c1536980 f3ff0d84 c1536980 00000086 00000007 f3ff0ad0 f3bdc780
>   fea60661 00000228 f3ff0ad0 f6512604 00000000 c5a06e50 c105b0d0 f3ff0ad0
> Call Trace:
>   [<c1052065>] ? refrigerator+0x64/0xbb
>   [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
>   [<c10520a9>] refrigerator+0xa8/0xbb
>   [<c1042aa8>] try_to_freeze+0x23/0x2a
>   [<c1044426>] get_signal_to_deliver+0x4c/0x37f
>   [<c1002649>] do_signal+0x5a/0x6cb
>   [<c10eae6e>] ? spin_lock+0x8/0xa
>   [<c105c3ea>] ? lock_acquire+0xa3/0xcd
>   [<c116eb75>] ? do_raw_spin_lock+0x60/0x122
>   [<c10eae6e>] ? spin_lock+0x8/0xa
>   [<c116eb10>] ? do_raw_spin_unlock+0x8f/0x94
>   [<c12f6298>] ? _raw_spin_unlock+0x33/0x3f
>   [<c10b6d7a>] ? fsnotify_access+0x4f/0x5a
>   [<c10eb0e9>] ? proc_reg_read+0x0/0x84
>   [<c10b763c>] ? vfs_read+0x9d/0xdc
>   [<c1002cdd>] do_notify_resume+0x23/0x62
>   [<c12f6a3c>] work_notifysig+0x13/0x1b
> rsyslogd      D 00000228  2036  3607      1 0x00000000
>   c59e2e5c 00000086 fea6deea 00000228 00000039 f7160d84 c1536980 c59e2e18
>   c1531ef0 c1536980 f7160d84 c1536980 f7160e18 00000007 f7160ad0 f3bdc780
>   fea657db 00000228 f7160ad0 f38f9584 00000000 c59e2e50 c105b0d0 f7160ad0
> Call Trace:
>   [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
>   [<c10520a9>] refrigerator+0xa8/0xbb
>   [<c1042aa8>] try_to_freeze+0x23/0x2a
>   [<c1044426>] get_signal_to_deliver+0x4c/0x37f
>   [<c1002649>] do_signal+0x5a/0x6cb
>   [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
>   [<c10a0fda>] ? might_fault+0x4e/0x88
>   [<c105c3ea>] ? lock_acquire+0xa3/0xcd
>   [<c10a0fda>] ? might_fault+0x4e/0x88
>   [<c10a0fda>] ? might_fault+0x4e/0x88
>   [<c10a100f>] ? might_fault+0x83/0x88
>   [<c116bad6>] ? copy_to_user+0x2b/0x57
>   [<c10c29d7>] ? poll_select_copy_remaining+0xb1/0xcd
>   [<c10c3660>] ? sys_select+0x7a/0x84
>   [<c1002cdd>] do_notify_resume+0x23/0x62
>   [<c12f6a3c>] work_notifysig+0x13/0x1b
> rsyslogd      D 00000228  1988  3617      1 0x00000000
>   c51a9e5c 00000086 fea768ee 00000228 c1052065 f3ff38c4 c1536980 00001719
>   c1531ef0 c1536980 f3ff38c4 c1536980 c12ff364 0007ea75 c2c05ef0 f3891680
>   fea768ee 00000228 f3ff3610 00000078 00000000 00000000 00001719 f3ff3610
> Call Trace:
>   [<c1052065>] ? refrigerator+0x64/0xbb
>   [<c10520a9>] refrigerator+0xa8/0xbb
>   [<c1042aa8>] try_to_freeze+0x23/0x2a
>   [<c1044426>] get_signal_to_deliver+0x4c/0x37f
>   [<c1002649>] do_signal+0x5a/0x6cb
>   [<c1027954>] ? cpuacct_charge+0x51/0x58
>   [<c102df9c>] ? set_next_entity+0x1e/0x89
>   [<c12f6347>] ? _raw_spin_unlock_irq+0x22/0x57
>   [<c105b09d>] ? trace_hardirqs_on_caller+0x119/0x141
>   [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
>   [<c1025f06>] ? need_resched+0x14/0x1e
>   [<c12f4909>] ? schedule+0x808/0x826
>   [<c10c3660>] ? sys_select+0x7a/0x84
>   [<c1002cdd>] do_notify_resume+0x23/0x62
>   [<c12f6a3c>] work_notifysig+0x13/0x1b
> rsyslogd      D 00000228  2844  3618      1 0x00000000
>   c5007e5c 00000086 fed9e135 00000228 c1052065 f3ff2df4 c1536980 00000000
>   c1531ef0 c1536980 f3ff2df4 c1536980 00000086 00000007 f3ff2b40 f3bdc780
>   fea6bc0e 00000228 f3ff2b40 f38f9584 00000000 c5007e50 c105b0d0 f3ff2b40
> Call Trace:
>   [<c1052065>] ? refrigerator+0x64/0xbb
>   [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
>   [<c10520a9>] refrigerator+0xa8/0xbb
>   [<c1042aa8>] try_to_freeze+0x23/0x2a
>   [<c1044426>] get_signal_to_deliver+0x4c/0x37f
>   [<c10bd749>] ? pipe_read+0x290/0x2db
>   [<c1002649>] do_signal+0x5a/0x6cb
>   [<c10b701e>] ? do_sync_read+0x87/0xc2
>   [<c1147456>] ? security_file_permission+0xf/0x11
>   [<c10b70f1>] ? rw_verify_area+0x98/0xbb
>   [<c10b6f97>] ? do_sync_read+0x0/0xc2
>   [<c10b761c>] ? vfs_read+0x7d/0xdc
>   [<c10b6ca5>] ? fput_light+0xc/0xe
>   [<c1002cdd>] do_notify_resume+0x23/0x62
>   [<c12f6a3c>] work_notifysig+0x13/0x1b
> rsyslogd      D 00000228  2392  5563      1 0x00000000
>   c5253e5c 00000086 feda3b6a 00000228 c1052065 e6426ed4 c1536980 00000000
>   c1531ef0 c1536980 e6426ed4 c1536980 00000086 00000007 e6426c20 f3bdc280
>   fea6eb78 00000228 e6426c20 f38f9584 00000000 c5253e50 c105b0d0 e6426c20
> Call Trace:
>   [<c1052065>] ? refrigerator+0x64/0xbb
>   [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
>   [<c10520a9>] refrigerator+0xa8/0xbb
>   [<c1042aa8>] try_to_freeze+0x23/0x2a
>   [<c1044426>] get_signal_to_deliver+0x4c/0x37f
>   [<c1002649>] do_signal+0x5a/0x6cb
>   [<c105f9fa>] ? do_futex+0x77/0x690
>   [<c10a0fda>] ? might_fault+0x4e/0x88
>   [<c105c3ea>] ? lock_acquire+0xa3/0xcd
>   [<c10a0fda>] ? might_fault+0x4e/0x88
>   [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
>   [<c1053a28>] ? ktime_get+0x58/0x95
>   [<c10600f4>] ? sys_futex+0xe1/0xf5
>   [<c100321c>] ? sysenter_exit+0xf/0x1f
>   [<c1002cdd>] do_notify_resume+0x23/0x62
>   [<c12f6a3c>] work_notifysig+0x13/0x1b
> dbus-daemon   D 00000228  1872  3637      1 0x00000000
>   c5562e5c 00000086 fedcc7a9 00000228 c1052065 f6465934 c1536980 00000000
>   c1531ef0 c1536980 f6465934 c1536980 00000086 00000007 f6465680 f3bdd400
>   fea71ea3 00000228 f6465680 f38f8504 00000000 c5562e50 c105b0d0 f6465680
> Call Trace:
>   [<c1052065>] ? refrigerator+0x64/0xbb
>   [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
>   [<c10520a9>] refrigerator+0xa8/0xbb
>   [<c1042aa8>] try_to_freeze+0x23/0x2a
>   [<c1044426>] get_signal_to_deliver+0x4c/0x37f
>   [<c1002649>] do_signal+0x5a/0x6cb
>   [<c1002cdd>] do_notify_resume+0x23/0x62
>   [<c12f6a3c>] work_notifysig+0x13/0x1b
> gdm-binary    D 00000228  2036  3641      1 0x00000000
>   c5005e5c 00000086 fedd34de 00000228 c1052065 f3ff4e64 c1536980 00000000
>   c1531ef0 c1536980 f3ff4e64 c1536980 00000086 00000007 f3ff4bb0 f3825180
>   fea7dfdb 00000228 f3ff4bb0 f6513104 00000000 c5005e50 c105b0d0 f3ff4bb0
> Call Trace:
>   [<c1052065>] ? refrigerator+0x64/0xbb
>   [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
>   [<c10520a9>] refrigerator+0xa8/0xbb
>   [<c1042aa8>] try_to_freeze+0x23/0x2a
>   [<c1044426>] get_signal_to_deliver+0x4c/0x37f
>   [<c1002649>] do_signal+0x5a/0x6cb
>   [<c104b87e>] ? spin_unlock_irqrestore+0x8/0xa
>   [<c104b927>] ? finish_wait+0x44/0x49
>   [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
>   [<c10a0fda>] ? might_fault+0x4e/0x88
>   [<c105c3ea>] ? lock_acquire+0xa3/0xcd
>   [<c10a0fda>] ? might_fault+0x4e/0x88
>   [<c10a0fda>] ? might_fault+0x4e/0x88
>   [<c10a100f>] ? might_fault+0x83/0x88
>   [<c1002cdd>] do_notify_resume+0x23/0x62
>   [<c12f6a3c>] work_notifysig+0x13/0x1b
