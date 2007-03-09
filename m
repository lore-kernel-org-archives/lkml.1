Return-Path: <linux-kernel-owner+w=401wt.eu-S1767561AbXCIWbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767561AbXCIWbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933413AbXCIWbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:31:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33989 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933410AbXCIWbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:31:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] swsusp: Disable nonboot CPUs before entering platform suspend
Date: Fri, 9 Mar 2007 23:34:00 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200703072044.12021.rjw@sisk.pl> <200703092224.20432.rjw@sisk.pl> <20070309221300.GB1818@elf.ucw.cz>
In-Reply-To: <20070309221300.GB1818@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703092334.01189.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 9 March 2007 23:13, Pavel Machek wrote:
> Hi!
> 
> > > > Index: linux-2.6.21-rc3/kernel/power/user.c
> > > > ===================================================================
> > > > --- linux-2.6.21-rc3.orig/kernel/power/user.c
> > > > +++ linux-2.6.21-rc3/kernel/power/user.c
> > > > @@ -402,9 +402,10 @@ static int snapshot_ioctl(struct inode *
> > > >  
> > > >  		case PMOPS_ENTER:
> > > >  			if (data->platform_suspend) {
> > > > +				disable_nonboot_cpus();
> > > >  				kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
> > > >  				error = pm_ops->enter(PM_SUSPEND_DISK);
> > > > -				error = 0;
> > > > +				enable_nonboot_cpus();
> > > 
> > > Why did we discard return code in previous versions? Do we still want
> > > to do that?
> > 
> > I think it was a mistake.
> 
> I took a look at git-annotate, and it is yours code, so I assume you
> are right. ACK, then.

Thanks!

BTW, what about the patch at http://lkml.org/lkml/2007/3/8/363?

Rafael
