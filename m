Return-Path: <linux-kernel-owner+w=401wt.eu-S1767590AbXCIWsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767590AbXCIWsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767589AbXCIWsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:48:21 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49631 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767588AbXCIWsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:48:20 -0500
Date: Fri, 9 Mar 2007 23:48:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] swsusp: Disable nonboot CPUs before entering platform suspend
Message-ID: <20070309224806.GD1818@elf.ucw.cz>
References: <200703072044.12021.rjw@sisk.pl> <200703092224.20432.rjw@sisk.pl> <20070309221300.GB1818@elf.ucw.cz> <200703092334.01189.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703092334.01189.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-03-09 23:34:00, Rafael J. Wysocki wrote:
> On Friday, 9 March 2007 23:13, Pavel Machek wrote:
> > Hi!
> > 
> > > > > Index: linux-2.6.21-rc3/kernel/power/user.c
> > > > > ===================================================================
> > > > > --- linux-2.6.21-rc3.orig/kernel/power/user.c
> > > > > +++ linux-2.6.21-rc3/kernel/power/user.c
> > > > > @@ -402,9 +402,10 @@ static int snapshot_ioctl(struct inode *
> > > > >  
> > > > >  		case PMOPS_ENTER:
> > > > >  			if (data->platform_suspend) {
> > > > > +				disable_nonboot_cpus();
> > > > >  				kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
> > > > >  				error = pm_ops->enter(PM_SUSPEND_DISK);
> > > > > -				error = 0;
> > > > > +				enable_nonboot_cpus();
> > > > 
> > > > Why did we discard return code in previous versions? Do we still want
> > > > to do that?
> > > 
> > > I think it was a mistake.
> > 
> > I took a look at git-annotate, and it is yours code, so I assume you
> > are right. ACK, then.
> 
> Thanks!
> 
> BTW, what about the patch at http://lkml.org/lkml/2007/3/8/363?

Seems obviously correct to me (ACK), but I did not have time to test it.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
