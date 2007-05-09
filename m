Return-Path: <linux-kernel-owner+w=401wt.eu-S1758074AbXEISbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074AbXEISbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 14:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756787AbXEISbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 14:31:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50593 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756763AbXEISbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 14:31:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: tglx@linutronix.de
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
Date: Wed, 9 May 2007 20:36:20 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
References: <20070430102837.748238000@linutronix.de> <200705091909.25443.rjw@sisk.pl> <1178730950.3042.533.camel@localhost.localdomain>
In-Reply-To: <1178730950.3042.533.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705092036.20953.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 9 May 2007 19:15, Thomas Gleixner wrote:
> On Wed, 2007-05-09 at 19:09 +0200, Rafael J. Wysocki wrote:
> > > > Well, where is unregister_time_interpolator() called from?
> > > 
> > > # grep -rn unregister_time_interpolator .
> > > ./kernel/timer.c:1893:unregister_time_interpolator(struct time_interpolator *ti)
> > > ./include/linux/timex.h:270:extern void unregister_time_interpolator(struct time_interpolator *);
> > > 
> > > I don't see a caller. i386 does not use time interpolator anyway.
> > > 
> > > # find -iname Kconfig | xargs grep TIME_INTERPOLATION
> > > ./arch/sparc64/Kconfig:37:config TIME_INTERPOLATION
> > > ./arch/ia64/Kconfig:60:config TIME_INTERPOLATION
> > 
> > But clocksource_resume() has no other caller, AFAICS ...
> 
> Eeep ?
> 
> clocksource_resume is called from timekeeping_resume()
> 
> timestatic int timekeeping_resume(struct sys_device *dev)
> {
>         unsigned long flags;
>         unsigned long now = read_persistent_clock();
> 
>         clocksource_resume();
> ....
> }
> 
> keeping_resume() called via the sysdev resume 
> 
> static struct sysdev_class timekeeping_sysclass = {
>         .resume         = timekeeping_resume,
>         .suspend        = timekeeping_suspend,
>         set_kset_name("timekeeping"),
> };

Well, apparently, not in -mm2:

rafael@albercik:~/src/mm/linux-2.6.21-mm2> grep -r -I -l 'timekeeping_resume' *
kernel/time/timekeeping.c
rafael@albercik:~/src/mm/linux-2.6.21-mm2> grep clocksource_resume kernel/time/timekeeping.c
rafael@albercik:~/src/mm/linux-2.6.21-mm2>

Hmm?

Rafael
