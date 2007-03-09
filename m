Return-Path: <linux-kernel-owner+w=401wt.eu-S1767559AbXCIWNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767559AbXCIWNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766786AbXCIWNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:13:14 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56877 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767559AbXCIWNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:13:12 -0500
Date: Fri, 9 Mar 2007 23:13:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] swsusp: Disable nonboot CPUs before entering platform suspend
Message-ID: <20070309221300.GB1818@elf.ucw.cz>
References: <200703072044.12021.rjw@sisk.pl> <200703092107.23820.rjw@sisk.pl> <20070309210746.GA6374@ucw.cz> <200703092224.20432.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703092224.20432.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Index: linux-2.6.21-rc3/kernel/power/user.c
> > > ===================================================================
> > > --- linux-2.6.21-rc3.orig/kernel/power/user.c
> > > +++ linux-2.6.21-rc3/kernel/power/user.c
> > > @@ -402,9 +402,10 @@ static int snapshot_ioctl(struct inode *
> > >  
> > >  		case PMOPS_ENTER:
> > >  			if (data->platform_suspend) {
> > > +				disable_nonboot_cpus();
> > >  				kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
> > >  				error = pm_ops->enter(PM_SUSPEND_DISK);
> > > -				error = 0;
> > > +				enable_nonboot_cpus();
> > 
> > Why did we discard return code in previous versions? Do we still want
> > to do that?
> 
> I think it was a mistake.

I took a look at git-annotate, and it is yours code, so I assume you
are right. ACK, then.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
