Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab0CCVYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:24:12 -0500
Received: from cantor.suse.de ([195.135.220.2]:54122 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756304Ab0CCVYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:24:00 -0500
Date: Wed, 3 Mar 2010 13:23:35 -0800
From: Greg KH <gregkh@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Lennart Poettering <mzxreary@0pointer.de>,
       "Lee, Chun-Yi" <jlee@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 61/62] msi-laptop: depends on RFKILL
Message-ID: <20100303212335.GB9732@suse.de>
References: <20100302230933.GA32287@kroah.com>
 <1267572541-410-61-git-send-email-gregkh@suse.de>
 <20100303060955.GA2244@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100303060955.GA2244@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 10:09:56PM -0800, Dmitry Torokhov wrote:
> On Tue, Mar 02, 2010 at 03:29:00PM -0800, Greg Kroah-Hartman wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > msi-laptop uses rfkill*() interfaces so it should depend on RFKILL.
> > 
> > msi-laptop.c:(.text+0x1fcd1b): undefined reference to `rfkill_alloc'
> > msi-laptop.c:(.text+0x1fcd76): undefined reference to `rfkill_register'
> > msi-laptop.c:(.text+0x1fcdc8): undefined reference to `rfkill_destroy'
> > msi-laptop.c:(.text+0x1fcdd9): undefined reference to `rfkill_unregister'
> > 
> > This repairs "msi-laptop: Detect 3G device exists by standard ec command",
> > which is in some gregkh tree.
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > Cc: Lennart Poettering <mzxreary@0pointer.de>
> > Cc: Lee, Chun-Yi <jlee@novell.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > ---
> >  drivers/platform/x86/Kconfig |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> > index 6848f21..d911de3 100644
> > --- a/drivers/platform/x86/Kconfig
> > +++ b/drivers/platform/x86/Kconfig
> > @@ -148,6 +148,7 @@ config MSI_LAPTOP
> >  	tristate "MSI Laptop Extras"
> >  	depends on ACPI
> >  	depends on BACKLIGHT_CLASS_DEVICE
> > +	depends on RFKILL
> 
> I must say I really dislike when "depends" is used with drivers like
> this for high-level subsystems. How would a user (advanced, I agree)
> know about existence of such a driver when doing make oldconfig unless
> he examines entirety of the pull (new rc patch, tarball, whatever)? And
> even if he is aware of the new driver he needs to know exact config name
> to see the dependencies (even if he knows how)...
> 
> We all know dangers of "select" but I think it is useful when used
> judiciously, for entire subsystems only (like selecting serio,
> backlight, leds, etc) that do not have additional dependencies.

Yeah, it is an issue, but without using 'select', one that we have to
live with for now.

thanks,

greg k-h
