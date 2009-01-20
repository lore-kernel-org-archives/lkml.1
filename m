Return-Path: <linux-kernel-owner+w=401wt.eu-S1760819AbZATKlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760819AbZATKlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 05:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758787AbZATKlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 05:41:16 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:51887 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254AbZATKlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 05:41:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IACQHjX2298eFsnO/001WMl3AtI3B8iuzyyee57DFtRVhQ5L0AQf/c1csbIlWCvivB
         9vcwGpq34ZhODzEOFtJornbPtPB49R0nB8EdeiwN2+1kMzFKou1ROGN9mI4TEwV91c9k
         avvnR/Zsnl/97e38hOenKbZjkTitgkAUaeQFs=
Message-ID: <c4e36d110901200241x487092e9na0cda704de666d2b@mail.gmail.com>
Date: Tue, 20 Jan 2009 11:41:09 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.29-rc1 does not resume on Lenove T61
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Maciej Rutecki" <maciej.rutecki@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       dbrownell@users.sourceforge.net
In-Reply-To: <20090119234905.GC452@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com>
	 <b647ffbd0901190841j785172e5n24d29511a2e61332@mail.gmail.com>
	 <20090119164440.GA20754@elte.hu> <200901192025.37711.rjw@sisk.pl>
	 <c4e36d110901191431j62168b4yaf8a4ffdbbe38bea@mail.gmail.com>
	 <20090119234905.GC452@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/20 Ingo Molnar <mingo@elte.hu>:
>
> * Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:
>
>> 2009/1/19 Rafael J. Wysocki <rjw@sisk.pl>:
>> > On Monday 19 January 2009, Ingo Molnar wrote:
>> >>
>> >> * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
>> >>
>> >> > 2009/1/19 Ingo Molnar <mingo@elte.hu>:
>> >> > >
>> >> > > * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
>> >> > >
>> >> > >> 2009/1/19 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
>> >> > >> > 2009/1/13 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
>> >> > >> >> 2009/1/13 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
>> >> > >> >>> 2009/1/12 Rafael J. Wysocki <rjw@sisk.pl>:
>> >> > >> >>>> On Monday 12 January 2009, Zdenek Kabelac wrote:
>> >> > >> >>>
>> >> > >> >>>> Sure, good idea.  I've been running with this reverted recently.
>> >> > >> >>>>
>> >> > >> >>>>> PS: I'll do the above 'echo' trace later (being busy right now).
>> >> > >> >>>>
>> >> > >> >>>> That shouldn't be necessary if you can suspend-resume with
>> >> > >> >>>> 7503bfbae89eba07b46441a5d1594647f6b8ab7d reverted and the USB controller
>> >> > >> >>>> modules unloaded.
>> >> > >> >>>>
>> >> > >> >>>> Instead, with 7503bfbae89eba07b46441a5d1594647f6b8ab7d reverted, please write
>> >> > >> >>>> 'disabled' to the /sys/devices/.../power/wakeup files of all USB controllers
>> >> > >> >>>> and see if suspend-resume works in this configuration.
>> >> > >> >>>>
>> >> > >> >>>
>>
>> The second one  (From 68564a46976017496c2227660930d81240f82355)
>> creates the same fault.
>>
>> Thus obviously  Rafael is probably right and some series of patches
>> are necessary  though I'd prefer to get a nice clean patch against the
>> current git which I should try to apply as both Ingo's patches
>> generated some reject (solvable by hand).
>
> You can pull the current set of patches/fixes in this area via:
>
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus
>
> does that do the trick?
>

Ok - there are some changes - though I'll need to do more tests - thus
I'll probably add few more post after checking what happens after
couple suspend/resume cycles.

But here is at least the first output from my log - seems to be
related to my  USB EHCI problem:
(Before the machine usually died without logging this traceback)
Also - please note the message SPIN IRQ ALREADY DISABLED is from my
own little patch.
Usually when I keep ehci_hcd module in memory my machine dies after printing:
Extended CMOS year: 2000 - but this time it survived


Broke affinity for irq 1
Broke affinity for irq 12
Broke affinity for irq 20
kvm: disabling virtualization on CPU1
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU1 is down
SPIN IRQ ALREADY DISABLED
Pid: 2982, comm: pm-suspend Not tainted 2.6.29-rc2 #17
Call Trace:
 [<ffffffff8053ff37>] _spin_lock_irq+0x87/0x90
 [<ffffffff80250976>] ? lock_timer_base+0x36/0x70
 [<ffffffff8053bfbe>] schedule+0x13e/0x4ad
 [<ffffffff80250c6e>] ? __mod_timer+0xbe/0xe0
 [<ffffffff80250976>] ? lock_timer_base+0x36/0x70
 [<ffffffff8026c56d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff8053fc17>] ? _spin_unlock_irqrestore+0x57/0x70
 [<ffffffff80250c6e>] ? __mod_timer+0xbe/0xe0
 [<ffffffff8053cfa2>] schedule_timeout+0x62/0xd0
 [<ffffffff80250500>] ? process_timeout+0x0/0x10
 [<ffffffff8053cf9d>] ? schedule_timeout+0x5d/0xd0
 [<ffffffff8053d029>] schedule_timeout_uninterruptible+0x19/0x20
 [<ffffffff80250cad>] msleep+0x1d/0x30
 [<ffffffff803b5058>] pci_set_power_state+0x268/0x300
 [<ffffffffa00162bc>] usb_hcd_pci_suspend_late+0x6c/0x150 [usbcore]
 [<ffffffff803b722f>] pci_legacy_suspend_late+0x2f/0x60
 [<ffffffff803b745d>] pci_pm_suspend_noirq+0xad/0xc0
 [<ffffffff80441ba2>] pm_noirq_op+0x162/0x1b0
 [<ffffffff80442ae8>] device_power_down+0x48/0x180
 [<ffffffff8027e8f6>] suspend_devices_and_enter+0x156/0x1c0
 [<ffffffff8027eaf6>] enter_state+0x166/0x1e0
 [<ffffffff8027ec2a>] state_store+0xba/0x100
 [<ffffffff803a1eb7>] kobj_attr_store+0x17/0x20
 [<ffffffff8033531a>] sysfs_write_file+0xca/0x140
 [<ffffffff802db40b>] vfs_write+0xcb/0x190
 [<ffffffff802db5c0>] sys_write+0x50/0x90
 [<ffffffff8020c51b>] system_call_fastpath+0x16/0x1b
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
Extended CMOS year: 2000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Extended CMOS year: 2000

=================================
[ INFO: inconsistent lock state ]
2.6.29-rc2 #17
---------------------------------
inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
pm-suspend/2982 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&cpu_base->lock){++..}, at: [<ffffffff80260403>]
retrigger_next_event+0x93/0xf0
{in-hardirq-W} state was registered at:
  [<ffffffffffffffff>] 0xffffffffffffffff
irq event stamp: 337381
hardirqs last  enabled at (337381): [<ffffffff8053fc03>]
_spin_unlock_irqrestore+0x43/0x70
hardirqs last disabled at (337380): [<ffffffff8053ff60>]
_spin_lock_irqsave+0x20/0x90
softirqs last  enabled at (336752): [<ffffffff8024b67a>]
__do_softirq+0x12a/0x180
softirqs last disabled at (336595): [<ffffffff8020d6fc>] call_softirq+0x1c/0x50

other info that might help us debug this:
3 locks held by pm-suspend/2982:
 #0:  (&buffer->mutex){--..}, at: [<ffffffff80335293>]
sysfs_write_file+0x43/0x140
 #1:  (pm_mutex){--..}, at: [<ffffffff8027ea01>] enter_state+0x71/0x1e0
 #2:  (dpm_list_mtx){--..}, at: [<ffffffff80441cb2>] device_pm_lock+0x12/0x20

stack backtrace:
Pid: 2982, comm: pm-suspend Not tainted 2.6.29-rc2 #17
Call Trace:
 [<ffffffff8026db3e>] print_usage_bug+0x18e/0x1f0
 [<ffffffff8026eb10>] mark_lock+0xc40/0xcb0
 [<ffffffff802700d8>] __lock_acquire+0x758/0x1db0
 [<ffffffff80265909>] ? getnstimeofday+0x59/0xe0
 [<ffffffff8026ebd6>] ? mark_held_locks+0x56/0xa0
 [<ffffffff8053fc03>] ? _spin_unlock_irqrestore+0x43/0x70
 [<ffffffff8026ee5a>] ? trace_hardirqs_on_caller+0x16a/0x1d0
 [<ffffffff802717c1>] lock_acquire+0x91/0xc0
 [<ffffffff80260403>] ? retrigger_next_event+0x93/0xf0
 [<ffffffff8053fe01>] _spin_lock+0x31/0x70
 [<ffffffff80260403>] ? retrigger_next_event+0x93/0xf0
 [<ffffffff80260403>] retrigger_next_event+0x93/0xf0
 [<ffffffff8026059b>] hres_timers_resume+0xb/0x10
 [<ffffffff8026511d>] timekeeping_resume+0xfd/0x140
 [<ffffffff8043b1a0>] __sysdev_resume+0x20/0x60
 [<ffffffff8043b269>] sysdev_resume+0x89/0x180
 [<ffffffff80442c30>] device_power_up+0x10/0x20
 [<ffffffff8027e914>] suspend_devices_and_enter+0x174/0x1c0
 [<ffffffff8027eaf6>] enter_state+0x166/0x1e0
 [<ffffffff8027ec2a>] state_store+0xba/0x100
 [<ffffffff803a1eb7>] kobj_attr_store+0x17/0x20
 [<ffffffff8033531a>] sysfs_write_file+0xca/0x140
 [<ffffffff802db40b>] vfs_write+0xcb/0x190
 [<ffffffff802db5c0>] sys_write+0x50/0x90
 [<ffffffff8020c51b>] system_call_fastpath+0x16/0x1b
ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1

I do not see now the previous workqueue backtrace.

Zdenek
