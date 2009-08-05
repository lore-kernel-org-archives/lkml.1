Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbZHEQRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbZHEQRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbZHEQRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:17:47 -0400
Received: from kroah.org ([198.145.64.141]:47824 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbZHEQRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:17:47 -0400
Date: Wed, 5 Aug 2009 09:06:52 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Dream in staging: separate Kconfig/Makefile into subdirectory
Message-ID: <20090805160652.GA9474@kroah.com>
References: <20090720103532.GD19341@elf.ucw.cz>
 <20090727153711.GA4323@kroah.com>
 <20090805152721.GA8337@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805152721.GA8337@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 05:27:21PM +0200, Pavel Machek wrote:
> On Mon 2009-07-27 08:37:11, Greg KH wrote:
> > On Mon, Jul 20, 2009 at 12:35:32PM +0200, Pavel Machek wrote:
> > > Separate Kconfig/Makefile glue from dream into subdirectory. I plan to
> > > add few more drivers, and changing staging/Makefile each time sounds
> > > like inviting conflicts.
> > >     
> > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > > 
> > > diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
> > > index 300b83e..50f9ab0 100644
> > > --- a/drivers/staging/Kconfig
> > > +++ b/drivers/staging/Kconfig
> > > @@ -133,11 +133,9 @@ source "drivers/staging/cpc-usb/Kconfig"
> > >  
> > >  source "drivers/staging/pata_rdc/Kconfig"
> > >  
> > > -source "drivers/staging/dream/smd/Kconfig"
> > > -
> > > -source "drivers/staging/dream/camera/Kconfig"
> > > -
> > >  source "drivers/staging/udlfb/Kconfig"
> > >  
> > > +source "drivers/staging/dream/Kconfig"
> > > +
> > >  endif # !STAGING_EXCLUDE_BUILD
> > >  endif # STAGING
> > > diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
> > > index 8d2e1c2..4fa2e07 100644
> > > --- a/drivers/staging/Makefile
> > > +++ b/drivers/staging/Makefile
> > > @@ -1,7 +1,7 @@
> > >  # Makefile for staging directory
> > >  
> > >  # fix for build system bug...
> > > -obj-$(CONFIG_STAGING)		+= staging.o
> > > +obj-$(CONFIG_STAGING)		+= staging.o dream/
> > 
> > Ick, no, you shouldn't have to do this.
> > 
> > Please jump into the dream subdir based on a Kconfig option, don't go
> > there every single time.
> > 
> > Care to fix this up?
> 
> I'm afraid I don't quite have suitable config option. At least
> synaptics touchpad should be usable outside dream.
> 
> OTOH Dream is still major user; and I guess I can just introduce
> "CONFIG_DREAM". Should I?

What's wrong with using the CONFIG_ANDROID dependancy here?  Actually,
why not use it for all of the dream files?

Or yes, you can create CONFIG_DREAM if you want, but there's probably a
better, arch-specific config item that you want to use.

thanks,

greg k-h
