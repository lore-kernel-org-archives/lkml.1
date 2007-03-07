Return-Path: <linux-kernel-owner+w=401wt.eu-S965719AbXCGXNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965719AbXCGXNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965714AbXCGXNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:13:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51847 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965719AbXCGXNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:13:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] swsusp: Disable nonboot CPUs before entering platform suspend
Date: Thu, 8 Mar 2007 00:14:10 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200703072044.12021.rjw@sisk.pl> <200703072314.30265.rjw@sisk.pl> <20070307221953.GA5953@elf.ucw.cz>
In-Reply-To: <20070307221953.GA5953@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703080014.11081.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 7 March 2007 23:19, Pavel Machek wrote:
> Hi!
> 
> > > > Prevent the WARN_ON() in arch/x86_64/kernel/acpi/sleep.c:init_low_mapping()
> > > > from triggering by disabling nonboot CPUs before we finally enter the platform
> > > > suspend.
> > > > 
> > > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > > ---
> > > >  kernel/power/disk.c |    1 +
> > > >  kernel/power/user.c |    2 +-
> > > >  2 files changed, 2 insertions(+), 1 deletion(-)
> > > > 
> > > > Index: linux-2.6.21-rc2-mm2/kernel/power/disk.c
> > > > ===================================================================
> > > > --- linux-2.6.21-rc2-mm2.orig/kernel/power/disk.c
> > > > +++ linux-2.6.21-rc2-mm2/kernel/power/disk.c
> > > > @@ -61,6 +61,7 @@ static void power_down(suspend_disk_meth
> > > >  	switch(mode) {
> > > >  	case PM_DISK_PLATFORM:
> > > >  		if (pm_ops && pm_ops->enter) {
> > > > +			disable_nonboot_cpus();
> > > >  			kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
> > > >  			pm_ops->enter(PM_SUSPEND_DISK);
> > > >  			break;
> > > > Index: linux-2.6.21-rc2-mm2/kernel/power/user.c
> > > > ===================================================================
> > > > --- linux-2.6.21-rc2-mm2.orig/kernel/power/user.c
> > > > +++ linux-2.6.21-rc2-mm2/kernel/power/user.c
> > > > @@ -398,9 +398,9 @@ static int snapshot_ioctl(struct inode *
> > > >  
> > > >  		case PMOPS_ENTER:
> > > >  			if (data->platform_suspend) {
> > > > +				disable_nonboot_cpus();
> > > >  				kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
> > > >  				error = pm_ops->enter(PM_SUSPEND_DISK);
> > > > -				error = 0;
> > > >  			}
> > > >  			break;
> > > 
> > > Is this considered 2.6.21 material?  If so why?
> > 
> > Well, the WARN_ON() in arch/x86_64/kernel/acpi/sleep.c:init_low_mapping()
> > triggers every time an SMP x86_64 box is suspended to disk using the platform
> > mode (default), which is quite annoying IMHO and users think something wrong is
> > going on.  This will probably cause them to report the problem and I'd rather
> > like to avoid handling these reports. ;-)
> 
> I do not quite like the patch (explanation in separate mail). Can we
> remove the WARN_ON() ? ;-).

Yes, if you can tell me why it's there. :-)

Rafael
