Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbYKHSpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbYKHSpR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 13:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYKHSpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 13:45:03 -0500
Received: from mx1.suse.de ([195.135.220.2]:51337 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbYKHSpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 13:45:01 -0500
Date: Sat, 8 Nov 2008 10:30:44 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: only build the tree if we really want to
Message-ID: <20081108183044.GA16504@suse.de>
References: <20081108054511.GA28846@kroah.com> <1226123143-28859-1-git-send-email-greg@kroah.com> <4915B769.6090403@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4915B769.6090403@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2008 at 04:59:37PM +0100, Stefan Richter wrote:
> Greg KH wrote:
> > --- a/drivers/staging/Kconfig
> > +++ b/drivers/staging/Kconfig
> > @@ -21,7 +21,23 @@ menuconfig STAGING
> >  
> >  	  If in doubt, say N here.
> >  
> > -if STAGING
> > +
> > +config STAGING_EXCLUDE_BUILD
> > +	bool "Exclude Staging drivers from being built"
> > +	default y
> > +	---help---
> ...
> > +if !STAGING_EXCLUDE_BUILD
> >  
> >  source "drivers/staging/et131x/Kconfig"
> >  
> > @@ -45,4 +61,4 @@ source "drivers/staging/at76_usb/Kconfig"
> >  
> >  source "drivers/staging/poch/Kconfig"
> >  
> > -endif # STAGING
> > +endif # !STAGING_EXCLUDE_BUILD
> 
> Which purpose is the STAGING kconfig variable serving after this?

Sitting there and looking pretty :)

> It controls the visibility of the menu, but switching it off won't
> switch off the staging drivers if they were previously enabled, would
> it?

Try it and look in wonder :)

If something affects the visibility of the menu for those config
options, it controls if those options can be enabled or not.

thanks,

greg k-h
