Return-Path: <linux-kernel-owner+w=401wt.eu-S932595AbYBMS5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595AbYBMS5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762803AbYBMS5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:57:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43144 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762602AbYBMS5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:57:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@suse.de>
Subject: Re: [2.6.25-rc1] System no longer powers off after shutdown
Date: Wed, 13 Feb 2008 19:55:53 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <200802111623.38478.elendil@planet.nl> <200802131239.14305.elendil@planet.nl> <20080213165837.GA10129@suse.de>
In-Reply-To: <20080213165837.GA10129@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802131955.53821.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 13 of February 2008, Greg KH wrote:
> On Wed, Feb 13, 2008 at 12:39:13PM +0100, Frans Pop wrote:
> > On Tuesday 12 February 2008, Greg KH wrote:
> > > On Tue, Feb 12, 2008 at 09:39:14PM +0100, Frans Pop wrote:
> > > > On Monday 11 February 2008, Frans Pop wrote:
> > > > > In general 2.6.25 if looking quite good on my desktop, but there's
> > > > > one important issue: the system no longer powers off after shutdown.
> > > > > This works fine with 2.6.24.
> > > >
> > > > Don't ask me why, but bisection shows this commit to be the cause of
> > > > the failure to power off:
> > > > commit c10997f6575f476ff38442fa18fd4a0d80345f9d
> > > > Author: Greg Kroah-Hartman <gregkh@suse.de>
> > > > Date:   Thu Dec 20 08:13:05 2007 -0800
> > > >
> > > >     Kobject: convert drivers/* from kobject_unregister() to
> > > > kobject_put()
> > > >
> > > > Because it seemed somewhat unlikely, I have double checked this by
> > > > doing an extra compilation for this commit and its predecessor.
> > >
> > > What is the symptom of not powering off?
> > 
> > I already noticed yesterday that there's one hunk in that commit that's not
> > a straight replacement:
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > index 9e102af..5efd555 100644
> > --- a/drivers/cpufreq/cpufreq.c
> > +++ b/drivers/cpufreq/cpufreq.c
> > @@ -1030,8 +1030,6 @@ static int __cpufreq_remove_dev (struct sys_device * sys_dev)
> > 
> >         unlock_policy_rwsem_write(cpu);
> > 
> > -       kobject_unregister(&data->kobj);
> > -
> >         kobject_put(&data->kobj);
> > 
> >         /* we need to make sure that the underlying kobj is actually
> > 
> > 
> > So, just on the off chance, I applied the patch below and bingo, the system
> > powers off again. I doubt this will be the correct solution, but just in
> > case it is, here's my signed off. A comment why the double put is needed
> > would probably be good though.
> 
> There is a bug in the cpufreq kref logic that makes this "double put"
> necessary.  A real fix has already been posted to solve this issue, and
> I think it should be on it's way to Linus for -rc2 already.
> 
> Please let me know if -rc2 comes out without this needed fix.

Can you point me to the fix, please?

Thanks,
Rafael
