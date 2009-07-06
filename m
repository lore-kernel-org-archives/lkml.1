Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140AbZGFVio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbZGFVio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 17:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbZGFVig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 17:38:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57281 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093AbZGFVif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 17:38:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.30: hibernation/swsusp lockup due to acpi-cpufreq
Date: Mon, 6 Jul 2009 23:39:17 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Michael Witten <mfwitten@gmail.com>, Johannes Stezenbach <js@sig21.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cNOy0-5C5-23@gated-at.bofh.it> <200907042329.04926.rjw@sisk.pl> <1246915230.11545.61.camel@localhost.localdomain>
In-Reply-To: <1246915230.11545.61.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907062339.18578.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 July 2009, Pallipadi, Venkatesh wrote:
> On Sat, 2009-07-04 at 14:29 -0700, Rafael J. Wysocki wrote:
> > On Saturday 04 July 2009, Michael Witten wrote:
> > > On Tue, 16 Jun 2009 23:39:59 +0200, Rafael J. Wysocki wrote
> > > (http://www.spinics.net/lists/linux-acpi/msg22661.html):
> > > 
> > > > In fact, we need to do this entire thing differently.
> > > > 
> > > > The basic problem is that cpufreq_suspend() is a sysdev thing, so it will 
> > > > always be called with iterrupts off and *only* for CPU0.  So, it looks like
> > > > the majority of things we do there is just unnecessary (at least).
> > > 
> > > What's the status? This bug is driving me nuts.
> > 
> > Unfortunately, still unresolved.
> 
> Looked at this a bit more from acpi cpufreq angle.

Thanks!

> But, I feel the patch that Johannes had here
> http://lkml.indiana.edu/hypermail/linux/kernel/0906.2/00335.html
> is the right fix as we do the same saving and restoring of flags on SMP
> when cpu==this_cpu. This change will make code in UP same as that in SMP
> with 1 CPU active.

Andrew didn't like this patch IIRC.

> We can avoid the driver->get call from cpufreq_suspend for the drivers
> that do not do any freq changes in their suspend methods. But, then we
> will hit this same problem in cpufreq_resume() path and there we do want
> to check for adjust_jiffies for all drivers as long as CONSTANT_LOOPS is
> not set.

Why do we need to call that driver->get from cpufreq_suspend() in the first
place?  We know we are on CPU0, there are no any other CPUs active and
interrupts are disabled, so why do we need to care for any races?

Rafael
