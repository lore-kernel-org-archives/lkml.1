Return-Path: <linux-kernel-owner+w=401wt.eu-S1765210AbYBOVFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765210AbYBOVFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756956AbYBOVFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:05:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:55504 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756067AbYBOVFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:05:04 -0500
Date: Fri, 15 Feb 2008 12:58:26 -0800
From: Greg KH <gregkh@suse.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [2.6.25-rc1] System no longer powers off after shutdown
Message-ID: <20080215205826.GB7583@suse.de>
References: <200802111623.38478.elendil@planet.nl> <86802c440802141538m44d64b6as827426174874979d@mail.gmail.com> <20080215065746.GA8916@suse.de> <200802151119.23325.elendil@planet.nl> <86802c440802151138i303c58a2m2eca9e97566c3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440802151138i303c58a2m2eca9e97566c3@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 11:38:59AM -0800, Yinghai Lu wrote:
> On Fri, Feb 15, 2008 at 2:19 AM, Frans Pop <elendil@planet.nl> wrote:
> > On Friday 15 February 2008, Greg KH wrote:
> >  > I swear someone sent this patch in before.  Can you try this one below,
> >  > there seems to be an imbalance with kobject_get and _put.
> >
> >  I did remember seeing this patch before [1] and can confirm that it does
> >  indeed fix the issue: with this patch applied to 2.6.25 git head my system
> >  powers off correctly.
> >
> >  [1] See http://lkml.org/lkml/2008/2/8/342; also added to #9960.
> >
> >
> >
> >  > ---
> >  >  drivers/cpufreq/cpufreq.c |    8 --------
> >  >  1 file changed, 8 deletions(-)
> >  >
> >  > --- a/drivers/cpufreq/cpufreq.c
> >  > +++ b/drivers/cpufreq/cpufreq.c
> >  > @@ -1006,14 +1006,6 @@ static int __cpufreq_remove_dev (struct
> >  >       }
> >  >  #endif
> >  >
> >  > -
> >  > -     if (!kobject_get(&data->kobj)) {
> >  > -             spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
> >  > -             cpufreq_debug_enable_ratelimit();
> >  > -             unlock_policy_rwsem_write(cpu);
> >  > -             return -EFAULT;
> >  > -     }
> >  > -
> >  >  #ifdef CONFIG_SMP
> >  >
> >  >  #ifdef CONFIG_HOTPLUG_CPU
> >
> >
> 
> confirmed, with this patch, i still need disable CONFIG_DETECT_SOFTLOCKUP

Great, thanks for testing and letting us know.

greg k-h
