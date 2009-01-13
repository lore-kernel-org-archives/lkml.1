Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbZAMWl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbZAMWl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbZAMWls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:41:48 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:36103 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbZAMWlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:41:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oCNX5sFJbPzGlxNBbGb4nbQdpgH2ck6g0clFld8Sp08Z6uFXdwTWwcnPvADK9cNDmw
         N3rzXzHKWx+iXGkIEw5B10MyW02QsQMjUxkLuxl6Zv7vQnGU12Beon8x4A5umhyCiyCS
         ugWA9v/Q10OqRYa2clkLgYS/Doi/ScNhPQarE=
Message-ID: <c4e36d110901131441t46fed880j6ac4641a011fb761@mail.gmail.com>
Date: Tue, 13 Jan 2009 23:41:43 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.29-rc1 does not resume on Lenove T61
Cc: "Maciej Rutecki" <maciej.rutecki@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       dbrownell@users.sourceforge.net
In-Reply-To: <c4e36d110901131436y79beaf40h2da44e5925d574b5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com>
	 <200901121340.21009.rjw@sisk.pl>
	 <c4e36d110901120450q10278979j5cf726a5175cc3f1@mail.gmail.com>
	 <200901121819.01042.rjw@sisk.pl>
	 <c4e36d110901131436y79beaf40h2da44e5925d574b5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/13 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> 2009/1/12 Rafael J. Wysocki <rjw@sisk.pl>:
>> On Monday 12 January 2009, Zdenek Kabelac wrote:
>
>> Sure, good idea.  I've been running with this reverted recently.
>>
>>> PS: I'll do the above 'echo' trace later (being busy right now).
>>
>> That shouldn't be necessary if you can suspend-resume with
>> 7503bfbae89eba07b46441a5d1594647f6b8ab7d reverted and the USB controller
>> modules unloaded.
>>
>> Instead, with 7503bfbae89eba07b46441a5d1594647f6b8ab7d reverted, please write
>> 'disabled' to the /sys/devices/.../power/wakeup files of all USB controllers
>> and see if suspend-resume works in this configuration.
>>
>
> Hi
>
> So I've check some   find /sys/device | grep usb | grep power/wakeup
> and there was no difference.
> I've updated to latest git to be in sync
> (e0b325d310a6b11f1538413fd557d2eb98f2fae5)
> I'm still keeping reverted commit: 6fd9086a518d4f14213a32fe6c9ac17fabebbc1e.
>
> And I've figured out - the only  'modprobe -r ehci_hcd' is enough to
> keep my suspend/resume sequence working. (Though I would have say,
> that now it takes fairly noticable time to get keyboard and synaptics
> usable - but it might be connected with my move to evdev and hal... :)
> )
>
> So I'm adding cc: to David - maybe he has some suspected patches for
> ehci_hcd ? (as doing a bisect in such a broken merge window is going
> to give me probably a lot of unsable kernels nowdays....)
>

And I've forget to append trace from supend /resume with INFO trace:
(which might be a part of problem??)

acpi PNP0C14:00: legacy suspend
acpi device:2a: legacy suspend
acpi device:29: legacy suspend
acpi device:28: legacy suspend
acpi device:27: legacy suspend
acpi device:26: legacy suspend
acpi device:25: legacy suspend
acpi device:24: legacy suspend
acpi device:23: legacy suspend
acpi device:22: legacy suspend
acpi device:21: legacy suspend
acpi device:20: legacy suspend
acpi device:1f: legacy suspend
acpi device:1e: legacy suspend
acpi device:1d: legacy suspend
acpi device:1c: legacy suspend
acpi device:1b: legacy suspend
acpi device:1a: legacy suspend
acpi device:19: legacy suspend
acpi device:18: legacy suspend
acpi device:17: legacy suspend
acpi device:16: legacy suspend
acpi device:15: legacy suspend
acpi device:14: legacy suspend
acpi device:13: legacy suspend
acpi device:12: legacy suspend
acpi device:11: legacy suspend
acpi device:10: legacy suspend
acpi device:0f: legacy suspend
acpi device:0e: legacy suspend
acpi device:0d: legacy suspend
acpi device:0c: legacy suspend
acpi device:0b: legacy suspend
acpi device:0a: legacy suspend
acpi device:09: legacy suspend
acpi device:08: legacy suspend
acpi device:07: legacy suspend
acpi device:06: legacy suspend
acpi device:05: legacy suspend
acpi device:04: legacy suspend
acpi device:03: legacy suspend
acpi device:02: legacy suspend
thinkpad_hotkey IBM0068:00: legacy suspend
ac ACPI0003:00: legacy suspend
battery PNP0C0A:00: legacy suspend
power LNXPOWER:00: legacy suspend
ec PNP0C09:00: legacy suspend
acpi ATM1200:00: legacy suspend
acpi IBM0057:00: legacy suspend
acpi PNP0303:00: legacy suspend
acpi PNP0B00:00: legacy suspend
acpi PNP0C04:00: legacy suspend
acpi PNP0800:00: legacy suspend
acpi PNP0200:00: legacy suspend
acpi PNP0103:00: legacy suspend
acpi PNP0100:00: legacy suspend
acpi PNP0000:00: legacy suspend
acpi PNP0C02:00: legacy suspend
acpi device:01: legacy suspend
pci_root PNP0A08:00: legacy suspend
button PNP0C0E:00: legacy suspend
button PNP0C0D:00: legacy suspend
acpi PNP0C01:00: legacy suspend
pci_link PNP0C0F:07: legacy suspend
pci_link PNP0C0F:06: legacy suspend
pci_link PNP0C0F:05: legacy suspend
pci_link PNP0C0F:04: legacy suspend
pci_link PNP0C0F:03: legacy suspend
pci_link PNP0C0F:02: legacy suspend
pci_link PNP0C0F:01: legacy suspend
pci_link PNP0C0F:00: legacy suspend
acpi device:00: legacy suspend
processor ACPI_CPU:01: legacy suspend
processor ACPI_CPU:00: legacy suspend
button LNXPWRBN:00: legacy suspend
acpi LNXSYSTM:00: legacy suspend
ACPI: Preparing to enter system sleep state S3
Disabling non-boot CPUs ...

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.29-rc1 #9
-------------------------------------------------------
pm-suspend/1734 is trying to acquire lock:
 (&per_cpu(cpu_policy_rwsem, cpu)){----}, at: [<ffffffff80499fab>]
lock_policy_rwsem_write+0x4b/0x90

but task is already holding lock:
 (&cpu_hotplug.lock){--..}, at: [<ffffffff80246742>] cpu_hotplug_begin+0x22/0x60

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&cpu_hotplug.lock){--..}:
       [<ffffffff80270bf6>] __lock_acquire+0x1416/0x1db0
       [<ffffffff80271621>] lock_acquire+0x91/0xc0
       [<ffffffff8053d66c>] mutex_lock_nested+0xec/0x360
       [<ffffffff8024695a>] get_online_cpus+0x3a/0x50
       [<ffffffff802593c7>] work_on_cpu+0x67/0xb0
       [<ffffffff8021e85e>] get_measured_perf+0x1e/0xb0
       [<ffffffff80499bf8>] __cpufreq_driver_getavg+0x78/0x80
       [<ffffffff8049bc7c>] do_dbs_timer+0x2ac/0x390
       [<ffffffff80258535>] run_workqueue+0x105/0x240
       [<ffffffff8025871f>] worker_thread+0xaf/0x130
       [<ffffffff8025cc59>] kthread+0x49/0x90
       [<ffffffff8020d5fa>] child_rip+0xa/0x20
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&per_cpu(cpu_policy_rwsem, cpu)){----}:
       [<ffffffff80270dbc>] __lock_acquire+0x15dc/0x1db0
       [<ffffffff80271621>] lock_acquire+0x91/0xc0
       [<ffffffff8053df78>] down_write+0x48/0x80
       [<ffffffff80499fab>] lock_policy_rwsem_write+0x4b/0x90
       [<ffffffff8053b57d>] cpufreq_cpu_callback+0x6d/0x90
       [<ffffffff80542f85>] notifier_call_chain+0x65/0xa0
       [<ffffffff80261b39>] __raw_notifier_call_chain+0x9/0x10
       [<ffffffff8052a129>] _cpu_down+0xa9/0x2f0
       [<ffffffff8024683d>] disable_nonboot_cpus+0xbd/0x140
       [<ffffffff8027e715>] suspend_devices_and_enter+0x115/0x1c0
       [<ffffffff8027e956>] enter_state+0x166/0x1e0
       [<ffffffff8027ea8a>] state_store+0xba/0x100
       [<ffffffff803a1cb7>] kobj_attr_store+0x17/0x20
       [<ffffffff8033512a>] sysfs_write_file+0xca/0x140
       [<ffffffff802db22b>] vfs_write+0xcb/0x190
       [<ffffffff802db3e0>] sys_write+0x50/0x90
       [<ffffffff8020c51b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

4 locks held by pm-suspend/1734:
 #0:  (&buffer->mutex){--..}, at: [<ffffffff803350a3>]
sysfs_write_file+0x43/0x140
 #1:  (pm_mutex){--..}, at: [<ffffffff8027e861>] enter_state+0x71/0x1e0
 #2:  (cpu_add_remove_lock){--..}, at: [<ffffffff802467d3>]
disable_nonboot_cpus+0x53/0x140
 #3:  (&cpu_hotplug.lock){--..}, at: [<ffffffff80246742>]
cpu_hotplug_begin+0x22/0x60

stack backtrace:
Pid: 1734, comm: pm-suspend Not tainted 2.6.29-rc1 #9
Call Trace:
 [<ffffffff8026f340>] print_circular_bug_tail+0xe0/0xf0
 [<ffffffff80270dbc>] __lock_acquire+0x15dc/0x1db0
 [<ffffffff8053f752>] ? _spin_unlock_irq+0x32/0x50
 [<ffffffff8026ecba>] ? trace_hardirqs_on_caller+0x16a/0x1d0
 [<ffffffff803a0539>] ? __next_cpu+0x19/0x30
 [<ffffffff80258de9>] ? __cancel_work_timer+0x129/0x230
 [<ffffffff80258d32>] ? __cancel_work_timer+0x72/0x230
 [<ffffffff80271621>] lock_acquire+0x91/0xc0
 [<ffffffff80499fab>] ? lock_policy_rwsem_write+0x4b/0x90
 [<ffffffff8053df78>] down_write+0x48/0x80
 [<ffffffff80499fab>] ? lock_policy_rwsem_write+0x4b/0x90
 [<ffffffff80499fab>] lock_policy_rwsem_write+0x4b/0x90
 [<ffffffff8053b57d>] cpufreq_cpu_callback+0x6d/0x90
 [<ffffffff80542f85>] notifier_call_chain+0x65/0xa0
 [<ffffffff80261b39>] __raw_notifier_call_chain+0x9/0x10
 [<ffffffff8052a129>] _cpu_down+0xa9/0x2f0
 [<ffffffff8024683d>] disable_nonboot_cpus+0xbd/0x140
 [<ffffffff8027e715>] suspend_devices_and_enter+0x115/0x1c0
 [<ffffffff8027e956>] enter_state+0x166/0x1e0
 [<ffffffff8027ea8a>] state_store+0xba/0x100
 [<ffffffff803a1cb7>] kobj_attr_store+0x17/0x20
 [<ffffffff8033512a>] sysfs_write_file+0xca/0x140
 [<ffffffff802db22b>] vfs_write+0xcb/0x190
 [<ffffffff802db3e0>] sys_write+0x50/0x90
 [<ffffffff8020c51b>] system_call_fastpath+0x16/0x1b
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
CPU1 is down
thinkpad_hwmon thinkpad_hwmon: LATE suspend
thinkpad_acpi thinkpad_acpi: LATE suspend
platform regulatory.0: LATE suspend
iTCO_wdt iTCO_wdt: LATE suspend
platform hdaps: LATE suspend
i8042 i8042: LATE suspend
serial8250 serial8250: LATE suspend
platform vesafb.0: LATE suspend
platform pcspkr: LATE suspend
pci 0000:15:00.5: LATE suspend
pci 0000:15:00.4: LATE suspend
pci 0000:15:00.3: LATE suspend
sdhci-pci 0000:15:00.2: LATE suspend
pci 0000:15:00.0: LATE suspend
iwl3945 0000:03:00.0: LATE suspend
i801_smbus 0000:00:1f.3: LATE suspend
ahci 0000:00:1f.2: LATE suspend
ata_piix 0000:00:1f.1: LATE suspend
pci 0000:00:1f.0: LATE suspend
pci 0000:00:1e.0: LATE suspend
pci 0000:00:1d.7: LATE suspend
uhci_hcd 0000:00:1d.2: LATE suspend
uhci_hcd 0000:00:1d.2: --> PCI D0 legacy
uhci_hcd 0000:00:1d.1: LATE suspend
uhci_hcd 0000:00:1d.1: --> PCI D0 legacy
uhci_hcd 0000:00:1d.0: LATE suspend
uhci_hcd 0000:00:1d.0: --> PCI D0 legacy
pcieport-driver 0000:00:1c.4: LATE suspend
pcieport-driver 0000:00:1c.3: LATE suspend
pcieport-driver 0000:00:1c.2: LATE suspend
pcieport-driver 0000:00:1c.1: LATE suspend
pcieport-driver 0000:00:1c.0: LATE suspend
HDA Intel 0000:00:1b.0: LATE suspend
pci 0000:00:1a.7: LATE suspend
uhci_hcd 0000:00:1a.1: LATE suspend
uhci_hcd 0000:00:1a.1: --> PCI D0 legacy
uhci_hcd 0000:00:1a.0: LATE suspend
uhci_hcd 0000:00:1a.0: --> PCI D0 legacy
e1000e 0000:00:19.0: LATE suspend, may wakeup
pci 0000:00:02.1: LATE suspend
pci 0000:00:02.0: LATE suspend
agpgart-intel 0000:00:00.0: LATE suspend
platform dock.2: LATE suspend
platform dock.1: LATE suspend
platform dock.0: LATE suspend
Extended CMOS year: 2000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Back to C!
Extended CMOS year: 2000
platform dock.0: EARLY resume
platform dock.1: EARLY resume
platform dock.2: EARLY resume
agpgart-intel 0000:00:00.0: EARLY resume
pci 0000:00:02.0: EARLY resume
pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007,
writing 0x900403)
pci 0000:00:02.1: EARLY resume
pci 0000:00:02.1: restoring config space at offset 0x1 (was 0x900000,
writing 0x900007)
e1000e 0000:00:19.0: EARLY resume
uhci_hcd 0000:00:1a.0: EARLY resume
uhci_hcd 0000:00:1a.0: PCI legacy resume
uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was
0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1a.1: EARLY resume
uhci_hcd 0000:00:1a.1: PCI legacy resume
uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 (was
0x2800005, writing 0x2800001)
pci 0000:00:1a.7: EARLY resume
pci 0000:00:1a.7: restoring config space at offset 0x1 (was 0x2900106,
writing 0x2900102)
HDA Intel 0000:00:1b.0: EARLY resume
HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was
0x100106, writing 0x100102)
pcieport-driver 0000:00:1c.0: EARLY resume
pcieport-driver 0000:00:1c.0: restoring config space at offset 0x7
(was 0x20002020, writing 0x2020)
pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1
(was 0x100107, writing 0x100507)
pcieport-driver 0000:00:1c.1: EARLY resume
pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1
(was 0x100107, writing 0x100507)
pcieport-driver 0000:00:1c.2: EARLY resume
pcieport-driver 0000:00:1c.2: restoring config space at offset 0x7
(was 0x20004040, writing 0x4040)
pcieport-driver 0000:00:1c.2: restoring config space at offset 0x1
(was 0x100107, writing 0x100507)
pcieport-driver 0000:00:1c.3: EARLY resume
pcieport-driver 0000:00:1c.3: restoring config space at offset 0x7
(was 0x20005050, writing 0x5050)
pcieport-driver 0000:00:1c.3: restoring config space at offset 0x1
(was 0x100107, writing 0x100507)
pcieport-driver 0000:00:1c.4: EARLY resume
pcieport-driver 0000:00:1c.4: restoring config space at offset 0x7
(was 0x20006060, writing 0x6060)
pcieport-driver 0000:00:1c.4: restoring config space at offset 0x1
(was 0x100107, writing 0x100507)
uhci_hcd 0000:00:1d.0: EARLY resume
uhci_hcd 0000:00:1d.0: PCI legacy resume
uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was
0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.1: EARLY resume
uhci_hcd 0000:00:1d.1: PCI legacy resume
uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was
0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.2: EARLY resume
uhci_hcd 0000:00:1d.2: PCI legacy resume
uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was
0x2800005, writing 0x2800001)
pci 0000:00:1d.7: EARLY resume
pci 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106,
writing 0x2900102)
pci 0000:00:1e.0: EARLY resume
pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100005,
writing 0x100003)
pci 0000:00:1f.0: EARLY resume
ata_piix 0000:00:1f.1: EARLY resume
ahci 0000:00:1f.2: EARLY resume
i801_smbus 0000:00:1f.3: EARLY resume
iwl3945 0000:03:00.0: EARLY resume
pci 0000:15:00.0: EARLY resume
sdhci-pci 0000:15:00.2: EARLY resume
pci 0000:15:00.3: EARLY resume
pci 0000:15:00.4: EARLY resume
pci 0000:15:00.5: EARLY resume
platform pcspkr: EARLY resume
platform vesafb.0: EARLY resume
serial8250 serial8250: EARLY resume
i8042 i8042: EARLY resume
platform hdaps: EARLY resume
iTCO_wdt iTCO_wdt: EARLY resume
platform regulatory.0: EARLY resume
thinkpad_acpi thinkpad_acpi: EARLY resume
thinkpad_hwmon thinkpad_hwmon: EARLY resume
Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1



> Zdenek
>
