Return-Path: <linux-kernel-owner+w=401wt.eu-S1759483AbZASJzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483AbZASJzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 04:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758569AbZASJzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 04:55:00 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:41820 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759667AbZASJy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 04:54:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=S93sFNCwevZZR+sAgiMt4EOWdhHg6KoVgLsmjL48n5i4uNqOcTb38528vDHs3jNpa6
         hC2+h5Ru1fW0nNvSZZ5U8U7kZH5ZZaaPcCH8/NCMdWNfPEwNB/M9Om0vmasQqNo867Hj
         ExJpMxMB6UK1LNUXUISaIoqYPKzDny8/GDHLw=
Message-ID: <c4e36d110901190154y59436b74nbcd1c35712111741@mail.gmail.com>
Date: Mon, 19 Jan 2009 10:54:54 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.29-rc1 does not resume on Lenove T61
Cc: "Maciej Rutecki" <maciej.rutecki@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       dbrownell@users.sourceforge.net
In-Reply-To: <c4e36d110901131441t46fed880j6ac4641a011fb761@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com>
	 <200901121340.21009.rjw@sisk.pl>
	 <c4e36d110901120450q10278979j5cf726a5175cc3f1@mail.gmail.com>
	 <200901121819.01042.rjw@sisk.pl>
	 <c4e36d110901131436y79beaf40h2da44e5925d574b5@mail.gmail.com>
	 <c4e36d110901131441t46fed880j6ac4641a011fb761@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/13 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> 2009/1/13 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
>> 2009/1/12 Rafael J. Wysocki <rjw@sisk.pl>:
>>> On Monday 12 January 2009, Zdenek Kabelac wrote:
>>
>>> Sure, good idea.  I've been running with this reverted recently.
>>>
>>>> PS: I'll do the above 'echo' trace later (being busy right now).
>>>
>>> That shouldn't be necessary if you can suspend-resume with
>>> 7503bfbae89eba07b46441a5d1594647f6b8ab7d reverted and the USB controller
>>> modules unloaded.
>>>
>>> Instead, with 7503bfbae89eba07b46441a5d1594647f6b8ab7d reverted, please write
>>> 'disabled' to the /sys/devices/.../power/wakeup files of all USB controllers
>>> and see if suspend-resume works in this configuration.
>>>
>>
>> Hi
>>
>> So I've check some   find /sys/device | grep usb | grep power/wakeup
>> and there was no difference.
>> I've updated to latest git to be in sync
>> (e0b325d310a6b11f1538413fd557d2eb98f2fae5)
>> I'm still keeping reverted commit: 6fd9086a518d4f14213a32fe6c9ac17fabebbc1e.
>>
>> And I've figured out - the only  'modprobe -r ehci_hcd' is enough to
>> keep my suspend/resume sequence working. (Though I would have say,
>> that now it takes fairly noticable time to get keyboard and synaptics
>> usable - but it might be connected with my move to evdev and hal... :)
>> )
>>
>> So I'm adding cc: to David - maybe he has some suspected patches for
>> ehci_hcd ? (as doing a bisect in such a broken merge window is going
>> to give me probably a lot of unsable kernels nowdays....)
>>
>
> And I've forget to append trace from supend /resume with INFO trace:
> (which might be a part of problem??)

Hi


Just an update for  2.6.29-rc2 (f3b8436ad9a8ad36b3c9fa1fe030c7f38e5d3d0b)

With this kernel I still have to keep reverted patch commit:
6fd9086a518d4f14213a32fe6c9ac17fabebbc1e.
(otherwise I see the auto-wake-up immediately after suspend)

I also keep module ehci_hcd away from my kernel - so the
suspend-resume seems to be working.

I've checked the ideas from thread: 2.6.29-rc1: [SOLVED] thinkpad
problems during resume
http://lkml.org/lkml/2009/1/17/181  and they seems to produce some
ugly Ooops with my configuration.
so for now I stay with my revert/ehci fix.

Also I still get the INFO trace:
processor ACPI_CPU:01: legacy suspend
processor ACPI_CPU:00: legacy suspend
button LNXPWRBN:00: legacy suspend
acpi LNXSYSTM:00: legacy suspend
ACPI: Preparing to enter system sleep state S3
Disabling non-boot CPUs ...

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.29-rc2 #14
-------------------------------------------------------
pm-suspend/2873 is trying to acquire lock:
 (&per_cpu(cpu_policy_rwsem, cpu)){----}, at: [<ffffffff8049a27b>]
lock_policy_rwsem_write+0x4b/0x90

but task is already holding lock:
 (&cpu_hotplug.lock){--..}, at: [<ffffffff80246832>] cpu_hotplug_begin+0x22/0x60

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&cpu_hotplug.lock){--..}:
       [<ffffffff80270ce6>] __lock_acquire+0x1416/0x1db0
       [<ffffffff80271711>] lock_acquire+0x91/0xc0
       [<ffffffff8053d99c>] mutex_lock_nested+0xec/0x360
       [<ffffffff80246a4a>] get_online_cpus+0x3a/0x50
       [<ffffffff802594b7>] work_on_cpu+0x67/0xb0
       [<ffffffff8021e85e>] get_measured_perf+0x1e/0xb0
       [<ffffffff80499ec8>] __cpufreq_driver_getavg+0x78/0x80
       [<ffffffff8049bf4c>] do_dbs_timer+0x2ac/0x390
       [<ffffffff80258625>] run_workqueue+0x105/0x240
       [<ffffffff8025880f>] worker_thread+0xaf/0x130
       [<ffffffff8025cd49>] kthread+0x49/0x90
       [<ffffffff8020d5fa>] child_rip+0xa/0x20
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&per_cpu(cpu_policy_rwsem, cpu)){----}:
       [<ffffffff80270eac>] __lock_acquire+0x15dc/0x1db0
       [<ffffffff80271711>] lock_acquire+0x91/0xc0
       [<ffffffff8053e2a8>] down_write+0x48/0x80
       [<ffffffff8049a27b>] lock_policy_rwsem_write+0x4b/0x90
       [<ffffffff8053b8ad>] cpufreq_cpu_callback+0x6d/0x90
       [<ffffffff805432b5>] notifier_call_chain+0x65/0xa0
       [<ffffffff80261c29>] __raw_notifier_call_chain+0x9/0x10
       [<ffffffff8052a469>] _cpu_down+0xa9/0x2f0
       [<ffffffff8024692d>] disable_nonboot_cpus+0xbd/0x140
       [<ffffffff8027e805>] suspend_devices_and_enter+0x115/0x1c0
       [<ffffffff8027ea46>] enter_state+0x166/0x1e0
       [<ffffffff8027eb7a>] state_store+0xba/0x100
       [<ffffffff803a1e07>] kobj_attr_store+0x17/0x20
       [<ffffffff8033526a>] sysfs_write_file+0xca/0x140
       [<ffffffff802db34b>] vfs_write+0xcb/0x190
       [<ffffffff802db500>] sys_write+0x50/0x90
       [<ffffffff8020c51b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

4 locks held by pm-suspend/2873:
 #0:  (&buffer->mutex){--..}, at: [<ffffffff803351e3>]
sysfs_write_file+0x43/0x140
 #1:  (pm_mutex){--..}, at: [<ffffffff8027e951>] enter_state+0x71/0x1e0
 #2:  (cpu_add_remove_lock){--..}, at: [<ffffffff802468c3>]
disable_nonboot_cpus+0x53/0x140
 #3:  (&cpu_hotplug.lock){--..}, at: [<ffffffff80246832>]
cpu_hotplug_begin+0x22/0x60

stack backtrace:
Pid: 2873, comm: pm-suspend Not tainted 2.6.29-rc2 #14
Call Trace:
 [<ffffffff8026f430>] print_circular_bug_tail+0xe0/0xf0
 [<ffffffff80270eac>] __lock_acquire+0x15dc/0x1db0
 [<ffffffff8053fa82>] ? _spin_unlock_irq+0x32/0x50
 [<ffffffff8026edaa>] ? trace_hardirqs_on_caller+0x16a/0x1d0
 [<ffffffff803a0689>] ? __next_cpu+0x19/0x30
 [<ffffffff80258ed9>] ? __cancel_work_timer+0x129/0x230
 [<ffffffff80258e22>] ? __cancel_work_timer+0x72/0x230
 [<ffffffff80271711>] lock_acquire+0x91/0xc0
 [<ffffffff8049a27b>] ? lock_policy_rwsem_write+0x4b/0x90
 [<ffffffff8053e2a8>] down_write+0x48/0x80
 [<ffffffff8049a27b>] ? lock_policy_rwsem_write+0x4b/0x90
 [<ffffffff8049a27b>] lock_policy_rwsem_write+0x4b/0x90
 [<ffffffff8053b8ad>] cpufreq_cpu_callback+0x6d/0x90
 [<ffffffff805432b5>] notifier_call_chain+0x65/0xa0
 [<ffffffff80261c29>] __raw_notifier_call_chain+0x9/0x10
 [<ffffffff8052a469>] _cpu_down+0xa9/0x2f0
 [<ffffffff8024692d>] disable_nonboot_cpus+0xbd/0x140
 [<ffffffff8027e805>] suspend_devices_and_enter+0x115/0x1c0
 [<ffffffff8027ea46>] enter_state+0x166/0x1e0
 [<ffffffff8027eb7a>] state_store+0xba/0x100
 [<ffffffff803a1e07>] kobj_attr_store+0x17/0x20
 [<ffffffff8033526a>] sysfs_write_file+0xca/0x140
 [<ffffffff802db34b>] vfs_write+0xcb/0x190
 [<ffffffff802db500>] sys_write+0x50/0x90
 [<ffffffff8020c51b>] system_call_fastpath+0x16/0x1b
Broke affinity for irq 9
Broke affinity for irq 17
Broke affinity for irq 29
kvm: disabling virtualization on CPU1
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
thinkpad_hwmon thinkpad_hwmon: LATE suspend
thinkpad_acpi thinkpad_acpi: LATE suspend



Zdenek
