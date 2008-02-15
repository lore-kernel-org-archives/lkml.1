Return-Path: <linux-kernel-owner+w=401wt.eu-S1759734AbYBOTjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734AbYBOTjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 14:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758170AbYBOTjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 14:39:05 -0500
Received: from wx-out-0506.google.com ([66.249.82.225]:34423 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758024AbYBOTjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 14:39:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xgtZkgTXpOwHlpjQ9IW+9Q2vAJI4AmVx/lTZwE2qR9vZ2/4eXNnt9p4vaBPyH8+v6VPllgpfmHYonPtJIgVbpOZbmaWr8FdqWKxCSOXxWDYljskvLcUi4KCWBsoib/4Lvk90QTyZM+tlQeMTc4lsjipyQSoM32GRqJbyzS7nfx0=
Message-ID: <86802c440802151138i303c58a2m2eca9e97566c3@mail.gmail.com>
Date: Fri, 15 Feb 2008 11:38:59 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Frans Pop" <elendil@planet.nl>
Subject: Re: [2.6.25-rc1] System no longer powers off after shutdown
Cc: "Greg KH" <gregkh@suse.de>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <200802151119.23325.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802111623.38478.elendil@planet.nl>
	 <86802c440802141538m44d64b6as827426174874979d@mail.gmail.com>
	 <20080215065746.GA8916@suse.de> <200802151119.23325.elendil@planet.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 2:19 AM, Frans Pop <elendil@planet.nl> wrote:
> On Friday 15 February 2008, Greg KH wrote:
>  > I swear someone sent this patch in before.  Can you try this one below,
>  > there seems to be an imbalance with kobject_get and _put.
>
>  I did remember seeing this patch before [1] and can confirm that it does
>  indeed fix the issue: with this patch applied to 2.6.25 git head my system
>  powers off correctly.
>
>  [1] See http://lkml.org/lkml/2008/2/8/342; also added to #9960.
>
>
>
>  > ---
>  >  drivers/cpufreq/cpufreq.c |    8 --------
>  >  1 file changed, 8 deletions(-)
>  >
>  > --- a/drivers/cpufreq/cpufreq.c
>  > +++ b/drivers/cpufreq/cpufreq.c
>  > @@ -1006,14 +1006,6 @@ static int __cpufreq_remove_dev (struct
>  >       }
>  >  #endif
>  >
>  > -
>  > -     if (!kobject_get(&data->kobj)) {
>  > -             spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
>  > -             cpufreq_debug_enable_ratelimit();
>  > -             unlock_policy_rwsem_write(cpu);
>  > -             return -EFAULT;
>  > -     }
>  > -
>  >  #ifdef CONFIG_SMP
>  >
>  >  #ifdef CONFIG_HOTPLUG_CPU
>
>

confirmed, with this patch, i still need disable CONFIG_DETECT_SOFTLOCKUP

assume watchdog thread for the dead cpu can not be stopped. hang somewhere.

YH
