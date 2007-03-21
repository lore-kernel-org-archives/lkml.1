Return-Path: <linux-kernel-owner+w=401wt.eu-S1751644AbXCUIby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbXCUIby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 04:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbXCUIbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 04:31:53 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44452 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751605AbXCUIbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 04:31:53 -0400
Date: Wed, 21 Mar 2007 09:31:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] swsusp: Fix SNAPSHOT_S2RAM ioctl
Message-ID: <20070321083146.GC4520@elf.ucw.cz>
References: <200703202248.08665.rjw@sisk.pl> <20070320223109.7158eb9e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320223109.7158eb9e.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The SNAPSHOT_S2RAM ioctl does not disable the nonboot CPUs before entering
> > the suspend, although it should do this.
> > 
> > --- linux-2.6.21-rc4.orig/kernel/power/user.c
> > +++ linux-2.6.21-rc4/kernel/power/user.c
> > @@ -374,9 +374,12 @@ static int snapshot_ioctl(struct inode *
> >  		if (error) {
> >  			printk(KERN_ERR "Failed to suspend some devices.\n");
> >  		} else {
> > -			/* Enter S3, system is already frozen */
> > -			suspend_enter(PM_SUSPEND_MEM);
> > -
> > +			error = disable_nonboot_cpus();
> > +			if (!error) {
> > +				/* Enter S3, system is already frozen */
> > +				suspend_enter(PM_SUSPEND_MEM);
> > +				enable_nonboot_cpus();
> > +			}
> >  			/* Wake up devices */
> >  			device_resume();
> >  		}
> 
> Do you consider this appropriate to 2.6.21?

Yes, this one is.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
