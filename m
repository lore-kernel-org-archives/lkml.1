Return-Path: <linux-kernel-owner+w=401wt.eu-S1760068AbYG2VNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068AbYG2VNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 17:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbYG2VNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 17:13:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44138 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbYG2VM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 17:12:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>, Ben Collins <ben.collins@canonical.com>
Subject: Re: [PATCH 6/7] pm: Config option to disable handling of console during suspend/resume
Date: Tue, 29 Jul 2008 23:15:35 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <24762.90.138.930.038.1036103001.ben.collins@canonical.com> <E1KKl4J-00068V-6f@swissweb.swissdisk.com> <20080729033309.GB12085@kroah.com>
In-Reply-To: <20080729033309.GB12085@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807292315.36511.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 29 of July 2008, Greg KH wrote:
> On Sun, Jul 20, 2008 at 09:48:28PM -0400, Ben Collins wrote:
> > Config option allows userspace to handle console during suspend/resume
> > instead of the kernel.
> > 
> > Signed-off-by: Ben Collins <ben.collins@canonical.com>
> > ---
> >  kernel/power/Kconfig   |   15 +++++++++++++++
> >  kernel/power/console.c |    4 ++++
> >  2 files changed, 19 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> > index b45da40..6855299 100644
> > --- a/kernel/power/Kconfig
> > +++ b/kernel/power/Kconfig
> > @@ -105,6 +105,21 @@ config SUSPEND_FREEZER
> >  
> >  	  Turning OFF this setting is NOT recommended! If in doubt, say Y.
> >  
> > +config PM_DISABLE_CONSOLE
> > +	bool "Disable Power Management messing with the active console"
> > +	depends on PM
> > +	default n
> > +	---help---
> > +	  By default, PM will take over the active console (generally, this means
> > +	  switching to the console when suspending from X). This can at times cause
> > +	  problems, especially if userspace suspend scripts try to do things with
> > +	  the console before or after suspending (e.g. calling vbestate).
> > +
> > +	  To work around this, enable this option so that PM will not handle the
> > +	  console.
> > +
> > +	  If unsure, say N.
> > +
> >  config HIBERNATION
> >  	bool "Hibernation (aka 'suspend to disk')"
> >  	depends on PM && SWAP && ARCH_HIBERNATION_POSSIBLE
> > diff --git a/kernel/power/console.c b/kernel/power/console.c
> > index b8628be..8b9706f 100644
> > --- a/kernel/power/console.c
> > +++ b/kernel/power/console.c
> > @@ -33,6 +33,7 @@ EXPORT_SYMBOL(pm_set_vt_switch);
> >  
> >  int pm_prepare_console(void)
> >  {
> > +#ifndef CONFIG_PM_DISABLE_CONSOLE
> 
> Can't you do this in a .h file instead?
> 
> And is this really needed?  Why has no other distro needed this change?
> What is so wierd about your suspend setup to require this?

Reportedly, some systems have problems with graphics restoration from user
space if the switch is done.

Anyway, I'd prefer to use the (already existing) pm_set_vt_switch() thing for
that, maybe with the help of a command line parameter, to adding the .config
option like this.

Thanks,
Rafael
