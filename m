Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbZASQNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbZASQNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 11:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbZASQNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 11:13:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59430 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbZASQNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 11:13:21 -0500
Date: Mon, 19 Jan 2009 17:13:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       dbrownell@users.sourceforge.net
Subject: Re: 2.6.29-rc1 does not resume on Lenove T61
Message-ID: <20090119161304.GA5537@elte.hu>
References: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com> <200901121340.21009.rjw@sisk.pl> <c4e36d110901120450q10278979j5cf726a5175cc3f1@mail.gmail.com> <200901121819.01042.rjw@sisk.pl> <c4e36d110901131436y79beaf40h2da44e5925d574b5@mail.gmail.com> <c4e36d110901131441t46fed880j6ac4641a011fb761@mail.gmail.com> <c4e36d110901190154y59436b74nbcd1c35712111741@mail.gmail.com> <b647ffbd0901190759l7a255005jdef3a927eb23f52b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0901190759l7a255005jdef3a927eb23f52b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> 2009/1/19 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> > 2009/1/13 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> >> 2009/1/13 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> >>> 2009/1/12 Rafael J. Wysocki <rjw@sisk.pl>:
> >>>> On Monday 12 January 2009, Zdenek Kabelac wrote:
> >>>
> >>>> Sure, good idea.  I've been running with this reverted recently.
> >>>>
> >>>>> PS: I'll do the above 'echo' trace later (being busy right now).
> >>>>
> >>>> That shouldn't be necessary if you can suspend-resume with
> >>>> 7503bfbae89eba07b46441a5d1594647f6b8ab7d reverted and the USB controller
> >>>> modules unloaded.
> >>>>
> >>>> Instead, with 7503bfbae89eba07b46441a5d1594647f6b8ab7d reverted, please write
> >>>> 'disabled' to the /sys/devices/.../power/wakeup files of all USB controllers
> >>>> and see if suspend-resume works in this configuration.
> >>>>
> >>>
> >>> Hi
> >>>
> >>> So I've check some   find /sys/device | grep usb | grep power/wakeup
> >>> and there was no difference.
> >>> I've updated to latest git to be in sync
> >>> (e0b325d310a6b11f1538413fd557d2eb98f2fae5)
> >>> I'm still keeping reverted commit: 6fd9086a518d4f14213a32fe6c9ac17fabebbc1e.
> >>>
> >>> And I've figured out - the only  'modprobe -r ehci_hcd' is enough to
> >>> keep my suspend/resume sequence working. (Though I would have say,
> >>> that now it takes fairly noticable time to get keyboard and synaptics
> >>> usable - but it might be connected with my move to evdev and hal... :)
> >>> )
> >>>
> >>> So I'm adding cc: to David - maybe he has some suspected patches for
> >>> ehci_hcd ? (as doing a bisect in such a broken merge window is going
> >>> to give me probably a lot of unsable kernels nowdays....)
> >>>
> >>
> >> And I've forget to append trace from supend /resume with INFO trace:
> >> (which might be a part of problem??)
> >
> > Hi
> >
> >
> > Just an update for  2.6.29-rc2 (f3b8436ad9a8ad36b3c9fa1fe030c7f38e5d3d0b)
> >
> > With this kernel I still have to keep reverted patch commit:
> > 6fd9086a518d4f14213a32fe6c9ac17fabebbc1e.
> > (otherwise I see the auto-wake-up immediately after suspend)
> >
> > I also keep module ehci_hcd away from my kernel - so the
> > suspend-resume seems to be working.
> >
> > I've checked the ideas from thread: 2.6.29-rc1: [SOLVED] thinkpad
> > problems during resume
> > http://lkml.org/lkml/2009/1/17/181  and they seems to produce some
> > ugly Ooops with my configuration.
> > so for now I stay with my revert/ehci fix.
> >
> > Also I still get the INFO trace:
> > processor ACPI_CPU:01: legacy suspend
> > processor ACPI_CPU:00: legacy suspend
> > button LNXPWRBN:00: legacy suspend
> > acpi LNXSYSTM:00: legacy suspend
> > ACPI: Preparing to enter system sleep state S3
> > Disabling non-boot CPUs ...
> >
> > =======================================================
> > [ INFO: possible circular locking dependency detected ]
> > 2.6.29-rc2 #14
> > -------------------------------------------------------
> > pm-suspend/2873 is trying to acquire lock:
> >  (&per_cpu(cpu_policy_rwsem, cpu)){----}, at: [<ffffffff8049a27b>]
> > lock_policy_rwsem_write+0x4b/0x90
> >
> > but task is already holding lock:
> >  (&cpu_hotplug.lock){--..}, at: [<ffffffff80246832>] cpu_hotplug_begin+0x22/0x60
> >
> > which lock already depends on the new lock.
> >
> >
> > the existing dependency chain (in reverse order) is:
> >
> > -> #1 (&cpu_hotplug.lock){--..}:
> >       [<ffffffff80270ce6>] __lock_acquire+0x1416/0x1db0
> >       [<ffffffff80271711>] lock_acquire+0x91/0xc0
> >       [<ffffffff8053d99c>] mutex_lock_nested+0xec/0x360
> >       [<ffffffff80246a4a>] get_online_cpus+0x3a/0x50
> >       [<ffffffff802594b7>] work_on_cpu+0x67/0xb0
> >       [<ffffffff8021e85e>] get_measured_perf+0x1e/0xb0
> 
> 
> Ingo,
> 
> 
> it looks like e39ad415ac15116df213dfa2aa2a4f1b0857af9c should have
> been reverted together with 7503bfbae89eba07b46441a5d1594647f6b8ab7d.
> 
> In general, perhaps all "set_cpus_allowed_ptr() -> work_on_cpu()"
> conversions - if they involve any cpu-hotplug callback paths - may
> lead to similar reports (and possible lockups).

Guys, could you please try the patch below? It improves work_on_cpu() to 
not be dependent on the kevent workqueue.

	Ingo

---------------->
>From e1d9ec6246a2668a5d037f529877efb7cf176af8 Mon Sep 17 00:00:00 2001
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 16 Jan 2009 15:31:15 -0800
Subject: [PATCH] work_on_cpu: Use our own workqueue.

Impact: remove potential clashes with generic kevent workqueue

Annoyingly, some places we want to use work_on_cpu are already in
workqueues.  As per Ingo's suggestion, we create a different workqueue
for work_on_cpu.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/workqueue.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a35afdb..1f0c509 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -971,6 +971,8 @@ undo:
 }
 
 #ifdef CONFIG_SMP
+static struct workqueue_struct *work_on_cpu_wq __read_mostly;
+
 struct work_for_cpu {
 	struct work_struct work;
 	long (*fn)(void *);
@@ -1001,7 +1003,7 @@ long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 	INIT_WORK(&wfc.work, do_work_for_cpu);
 	wfc.fn = fn;
 	wfc.arg = arg;
-	schedule_work_on(cpu, &wfc.work);
+	queue_work_on(cpu, work_on_cpu_wq, &wfc.work);
 	flush_work(&wfc.work);
 
 	return wfc.ret;
@@ -1019,4 +1021,8 @@ void __init init_workqueues(void)
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
+#ifdef CONFIG_SMP
+	work_on_cpu_wq = create_workqueue("work_on_cpu");
+	BUG_ON(!work_on_cpu_wq);
+#endif
 }
