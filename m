Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbXEISvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbXEISvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 14:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757211AbXEISvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 14:51:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50685 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757118AbXEISvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 14:51:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
Date: Wed, 9 May 2007 20:55:44 +0200
User-Agent: KMail/1.9.5
Cc: tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
References: <20070430102837.748238000@linutronix.de> <200705091452.08092.rjw@sisk.pl> <20070509101445.fa6b60cb.akpm@linux-foundation.org>
In-Reply-To: <20070509101445.fa6b60cb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705092055.45688.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 9 May 2007 19:14, Andrew Morton wrote:
> On Wed, 9 May 2007 14:52:07 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > > Andrew, could you please apply the appended patch and see if that
> > > helps (should apply to -mm2)?
> > 
> > Argh, sorry.  This needs yet another patch (sent for review to linux-pm) to
> > be applied.  The following one is against -mm2:
> > 
> > ---
> > NOTE: This is not a complete solution, because it removes the enabling of GPEs
> > from the resume-during-hibernation code path entirely, which probbably is not a
> > good idea in general.
> > ---
> >  kernel/power/disk.c |    1 -
> >  1 file changed, 1 deletion(-)
> > 
> > Index: linux-2.6.21-mm2/kernel/power/disk.c
> > ===================================================================
> > --- linux-2.6.21-mm2.orig/kernel/power/disk.c
> > +++ linux-2.6.21-mm2/kernel/power/disk.c
> > @@ -205,7 +205,6 @@ int hibernate(void)
> >  
> >  	if (in_suspend) {
> >  		enable_nonboot_cpus();
> > -		platform_finish();
> >  		device_resume();
> >  		resume_console();
> >  		pr_debug("PM: writing image.\n");
> 
> It now hangs in a similar fashion in the device_resume() call.
> 
> If I back off Thomas's clockevents-fix-resume-logic-updated-version.patch
> and include just the above patch the machine does suspend and resume
> correctly.
> 
> I can delve further into the device_resume() hang if we think it would be
> useful.

Frankly, I'm not sure.  On the one hand, I'd like to know wth is going on in
there, but on the other hand, I don't know if that knowledge will help us in
general.

It looks like we'll need to revamp the ACPI stuff in the hibernation/suspend
code paths anyway.

> Maybe Linus's clock-stomping tracer can help here, if I can remember how to
> use it. 

It's described a bit in Documentation/power/s2ram.txt .
