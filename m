Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbZAST0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbZAST0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 14:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZAST0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 14:26:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39227 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbZAST0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 14:26:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.29-rc1 does not resume on Lenove T61
Date: Mon, 19 Jan 2009 20:25:36 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       dbrownell@users.sourceforge.net
References: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com> <b647ffbd0901190841j785172e5n24d29511a2e61332@mail.gmail.com> <20090119164440.GA20754@elte.hu>
In-Reply-To: <20090119164440.GA20754@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901192025.37711.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2009, Ingo Molnar wrote:
> 
> * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> 
> > 2009/1/19 Ingo Molnar <mingo@elte.hu>:
> > >
> > > * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> > >
> > >> 2009/1/19 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> > >> > 2009/1/13 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> > >> >> 2009/1/13 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> > >> >>> 2009/1/12 Rafael J. Wysocki <rjw@sisk.pl>:
> > >> >>>> On Monday 12 January 2009, Zdenek Kabelac wrote:
> > >> >>>
> > >> >>>> Sure, good idea.  I've been running with this reverted recently.
> > >> >>>>
> > >> >>>>> PS: I'll do the above 'echo' trace later (being busy right now).
> > >> >>>>
> > >> >>>> That shouldn't be necessary if you can suspend-resume with
> > >> >>>> 7503bfbae89eba07b46441a5d1594647f6b8ab7d reverted and the USB controller
> > >> >>>> modules unloaded.
> > >> >>>>
> > >> >>>> Instead, with 7503bfbae89eba07b46441a5d1594647f6b8ab7d reverted, please write
> > >> >>>> 'disabled' to the /sys/devices/.../power/wakeup files of all USB controllers
> > >> >>>> and see if suspend-resume works in this configuration.
> > >> >>>>
> > >> >>>
> > >> >>> Hi
> > >> >>>
> > >> >>> So I've check some   find /sys/device | grep usb | grep power/wakeup
> > >> >>> and there was no difference.
> > >> >>> I've updated to latest git to be in sync
> > >> >>> (e0b325d310a6b11f1538413fd557d2eb98f2fae5)
> > >> >>> I'm still keeping reverted commit: 6fd9086a518d4f14213a32fe6c9ac17fabebbc1e.
> > >> >>>
> > >> >>> And I've figured out - the only  'modprobe -r ehci_hcd' is enough to
> > >> >>> keep my suspend/resume sequence working. (Though I would have say,
> > >> >>> that now it takes fairly noticable time to get keyboard and synaptics
> > >> >>> usable - but it might be connected with my move to evdev and hal... :)
> > >> >>> )
> > >> >>>
> > >> >>> So I'm adding cc: to David - maybe he has some suspected patches for
> > >> >>> ehci_hcd ? (as doing a bisect in such a broken merge window is going
> > >> >>> to give me probably a lot of unsable kernels nowdays....)
> > >> >>>
> > >> >>
> > >> >> And I've forget to append trace from supend /resume with INFO trace:
> > >> >> (which might be a part of problem??)
> > >> >
> > >> > Hi
> > >> >
> > >> >
> > >> > Just an update for  2.6.29-rc2 (f3b8436ad9a8ad36b3c9fa1fe030c7f38e5d3d0b)
> > >> >
> > >> > With this kernel I still have to keep reverted patch commit:
> > >> > 6fd9086a518d4f14213a32fe6c9ac17fabebbc1e.
> > >> > (otherwise I see the auto-wake-up immediately after suspend)
> > >> >
> > >> > I also keep module ehci_hcd away from my kernel - so the
> > >> > suspend-resume seems to be working.
> > >> >
> > >> > I've checked the ideas from thread: 2.6.29-rc1: [SOLVED] thinkpad
> > >> > problems during resume
> > >> > http://lkml.org/lkml/2009/1/17/181  and they seems to produce some
> > >> > ugly Ooops with my configuration.
> > >> > so for now I stay with my revert/ehci fix.
> > >> >
> > >> > Also I still get the INFO trace:
> > >> > processor ACPI_CPU:01: legacy suspend
> > >> > processor ACPI_CPU:00: legacy suspend
> > >> > button LNXPWRBN:00: legacy suspend
> > >> > acpi LNXSYSTM:00: legacy suspend
> > >> > ACPI: Preparing to enter system sleep state S3
> > >> > Disabling non-boot CPUs ...
> > >> >
> > >> > =======================================================
> > >> > [ INFO: possible circular locking dependency detected ]
> > >> > 2.6.29-rc2 #14
> > >> > -------------------------------------------------------
> > >> > pm-suspend/2873 is trying to acquire lock:
> > >> >  (&per_cpu(cpu_policy_rwsem, cpu)){----}, at: [<ffffffff8049a27b>]
> > >> > lock_policy_rwsem_write+0x4b/0x90
> > >> >
> > >> > but task is already holding lock:
> > >> >  (&cpu_hotplug.lock){--..}, at: [<ffffffff80246832>] cpu_hotplug_begin+0x22/0x60
> > >> >
> > >> > which lock already depends on the new lock.
> > >> >
> > >> >
> > >> > the existing dependency chain (in reverse order) is:
> > >> >
> > >> > -> #1 (&cpu_hotplug.lock){--..}:
> > >> >       [<ffffffff80270ce6>] __lock_acquire+0x1416/0x1db0
> > >> >       [<ffffffff80271711>] lock_acquire+0x91/0xc0
> > >> >       [<ffffffff8053d99c>] mutex_lock_nested+0xec/0x360
> > >> >       [<ffffffff80246a4a>] get_online_cpus+0x3a/0x50
> > >> >       [<ffffffff802594b7>] work_on_cpu+0x67/0xb0
> > >> >       [<ffffffff8021e85e>] get_measured_perf+0x1e/0xb0
> > >>
> > >>
> > >> Ingo,
> > >>
> > >>
> > >> it looks like e39ad415ac15116df213dfa2aa2a4f1b0857af9c should have
> > >> been reverted together with 7503bfbae89eba07b46441a5d1594647f6b8ab7d.
> > >>
> > >> In general, perhaps all "set_cpus_allowed_ptr() -> work_on_cpu()"
> > >> conversions - if they involve any cpu-hotplug callback paths - may
> > >> lead to similar reports (and possible lockups).
> > >
> > > Guys, could you please try the patch below? It improves work_on_cpu() to
> > > not be dependent on the kevent workqueue.
> > 
> > I guess, the following patch should also be applied (since
> > get_online_cpus() is a culprit here):
> > 
> > [PATCH 1/3] work_on_cpu: dont try to get_online_cpus() in work_on_cpu
> > 
> > the patch is available here:
> > 
> > http://lkml.indiana.edu/hypermail/linux/kernel/0901.2/00375.html
> 
> yeah - also attached below.

In fact I believe all three patches in the series at
http://lkml.org/lkml/2009/1/16/377
are necessary.

Thanks,
Rafael
