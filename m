Return-Path: <linux-kernel-owner+w=401wt.eu-S1763470AbYHEUEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763470AbYHEUEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762167AbYHEUEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:04:12 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51471 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762120AbYHEUEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:04:11 -0400
Date: Tue, 5 Aug 2008 21:57:06 +0200
From: Pavel Machek <pavel@suse.cz>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Zhang Rui <rui.zhang@intel.com>, Gautham R Shenoy <ego@in.ibm.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       harbour@sfinx.od.ua, rjw@sisk.pl
Subject: Re: +
	pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch
	added to -mm tree
Message-ID: <20080805195706.GD7939@elf.ucw.cz>
References: <200807111846.m6BIkeTj031024@imap1.linux-foundation.org> <20080712162149.GD603@tv-sign.ru> <20080722161900.GA17601@in.ibm.com> <20080724124349.GA182@tv-sign.ru> <1216948649.2669.21.camel@rzhang-dt> <20080725094246.GA110@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725094246.GA110@tv-sign.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > This means that
> > >
> > >         pm-schedule-sysrq-poweroff-on-boot-cpu.patch
> > >
> > > is not 100% right. It is still possible to hang/deadlock if we race
> > > with cpu_down(first_cpu(cpu_online_map)).
> >
> > Yes, you're right.
> > But then should we fix disable_nonboot_cpus as well?
> >
> > int disable_nonboot_cpus(void)
> > {
> >         first_cpu = first_cpu(cpu_online_map);
> > 	...
> >
> >         for_each_online_cpu(cpu) {
> >                 if (cpu == first_cpu)
> >                         continue;
> >                 error = _cpu_down(cpu, 1);
> > 		...
> >         }
> > 	...
> > }
> 
> Note that disable_nonboot_cpus() does first_cpu = first_cpu() under
> cpu_maps_update_begin(), so we can't race with cpu-hotplug.
> 
> However, this afaics means that its name is wrong, and
> printk("Disabling non-boot CPUs ...\n") is not right too.
> What it does is disable_all_but_one_cpus().

I thought that first cpu is defined to be boot cpu?

> And, it is not clear why disable_nonboot_cpus() assumes that
> all but first_cpu(cpu_online_map) must have .hotpluggable == 1.

Where does it assume that?

It will fail if some CPUs can't be unplugged, and I'm afraid suspend
can't work in such case... 

> And, if one of the callers really need to preserve the boot CPU,
> I don't understand how it is guaranteed it must be first_cpu().

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
