Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbXEIRFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbXEIRFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 13:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbXEIREx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 13:04:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50259 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbXEIREw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 13:04:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: tglx@linutronix.de
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
Date: Wed, 9 May 2007 19:09:24 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
References: <20070430102837.748238000@linutronix.de> <200705091512.13171.rjw@sisk.pl> <1178716776.3042.485.camel@localhost.localdomain>
In-Reply-To: <1178716776.3042.485.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705091909.25443.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 9 May 2007 15:19, Thomas Gleixner wrote:
> On Wed, 2007-05-09 at 15:12 +0200, Rafael J. Wysocki wrote:
> > On Wednesday, 9 May 2007 14:24, Thomas Gleixner wrote:
> > > On Wed, 2007-05-09 at 13:45 +0200, Rafael J. Wysocki wrote:
> > > > On Wednesday, 9 May 2007 10:59, Thomas Gleixner wrote:
> > > > > On Wed, 2007-05-09 at 01:31 -0700, Andrew Morton wrote:
> > > > > > > I suspect I just tested the wrong thing yesterday.  Let me recheck just
> > > > > > > these patches against 2.6.21.
> > > > > > 
> > > > > > yup, same hang with just these three:
> > > > > > 
> > > > > > origin
> > > > > > clocksource-fix-resume-logic
> > > > > > clockevents-fix-resume-logic-updated-version
> > > > > 
> > > > > I have no idea, how this affects acpi_evaluate_object()
> > > > 
> > > > I think the problem is that the ACPI code ordering here is broken in a
> > > > difficult to fix way.
> > > 
> > > Any explanation aside of witchcraft why this is affected by the clock
> > > event resume changes ?
> > 
> > Well, where is unregister_time_interpolator() called from?
> 
> # grep -rn unregister_time_interpolator .
> ./kernel/timer.c:1893:unregister_time_interpolator(struct time_interpolator *ti)
> ./include/linux/timex.h:270:extern void unregister_time_interpolator(struct time_interpolator *);
> 
> I don't see a caller. i386 does not use time interpolator anyway.
> 
> # find -iname Kconfig | xargs grep TIME_INTERPOLATION
> ./arch/sparc64/Kconfig:37:config TIME_INTERPOLATION
> ./arch/ia64/Kconfig:60:config TIME_INTERPOLATION

But clocksource_resume() has no other caller, AFAICS ...

Well, I don't see any explanation that wouldn't involve witchcraft.

Rafael
