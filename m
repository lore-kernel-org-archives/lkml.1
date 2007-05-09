Return-Path: <linux-kernel-owner+w=401wt.eu-S1757657AbXEINQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657AbXEINQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 09:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbXEINQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 09:16:45 -0400
Received: from www.osadl.org ([213.239.205.134]:37677 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753664AbXEINQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 09:16:43 -0400
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
In-Reply-To: <200705091512.13171.rjw@sisk.pl>
References: <20070430102837.748238000@linutronix.de>
	 <200705091345.55207.rjw@sisk.pl>
	 <1178713442.3042.480.camel@localhost.localdomain>
	 <200705091512.13171.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 09 May 2007 15:19:36 +0200
Message-Id: <1178716776.3042.485.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 15:12 +0200, Rafael J. Wysocki wrote:
> On Wednesday, 9 May 2007 14:24, Thomas Gleixner wrote:
> > On Wed, 2007-05-09 at 13:45 +0200, Rafael J. Wysocki wrote:
> > > On Wednesday, 9 May 2007 10:59, Thomas Gleixner wrote:
> > > > On Wed, 2007-05-09 at 01:31 -0700, Andrew Morton wrote:
> > > > > > I suspect I just tested the wrong thing yesterday.  Let me recheck just
> > > > > > these patches against 2.6.21.
> > > > > 
> > > > > yup, same hang with just these three:
> > > > > 
> > > > > origin
> > > > > clocksource-fix-resume-logic
> > > > > clockevents-fix-resume-logic-updated-version
> > > > 
> > > > I have no idea, how this affects acpi_evaluate_object()
> > > 
> > > I think the problem is that the ACPI code ordering here is broken in a
> > > difficult to fix way.
> > 
> > Any explanation aside of witchcraft why this is affected by the clock
> > event resume changes ?
> 
> Well, where is unregister_time_interpolator() called from?

# grep -rn unregister_time_interpolator .
./kernel/timer.c:1893:unregister_time_interpolator(struct time_interpolator *ti)
./include/linux/timex.h:270:extern void unregister_time_interpolator(struct time_interpolator *);

I don't see a caller. i386 does not use time interpolator anyway.

# find -iname Kconfig | xargs grep TIME_INTERPOLATION
./arch/sparc64/Kconfig:37:config TIME_INTERPOLATION
./arch/ia64/Kconfig:60:config TIME_INTERPOLATION

	tglx


