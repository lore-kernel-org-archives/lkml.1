Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbZHEP13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbZHEP13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 11:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755723AbZHEP12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 11:27:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38005 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbZHEP12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 11:27:28 -0400
Date: Wed, 5 Aug 2009 17:27:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Dream in staging: separate Kconfig/Makefile into subdirectory
Message-ID: <20090805152721.GA8337@elf.ucw.cz>
References: <20090720103532.GD19341@elf.ucw.cz> <20090727153711.GA4323@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090727153711.GA4323@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-07-27 08:37:11, Greg KH wrote:
> On Mon, Jul 20, 2009 at 12:35:32PM +0200, Pavel Machek wrote:
> > Separate Kconfig/Makefile glue from dream into subdirectory. I plan to
> > add few more drivers, and changing staging/Makefile each time sounds
> > like inviting conflicts.
> >     
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > 
> > diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
> > index 300b83e..50f9ab0 100644
> > --- a/drivers/staging/Kconfig
> > +++ b/drivers/staging/Kconfig
> > @@ -133,11 +133,9 @@ source "drivers/staging/cpc-usb/Kconfig"
> >  
> >  source "drivers/staging/pata_rdc/Kconfig"
> >  
> > -source "drivers/staging/dream/smd/Kconfig"
> > -
> > -source "drivers/staging/dream/camera/Kconfig"
> > -
> >  source "drivers/staging/udlfb/Kconfig"
> >  
> > +source "drivers/staging/dream/Kconfig"
> > +
> >  endif # !STAGING_EXCLUDE_BUILD
> >  endif # STAGING
> > diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
> > index 8d2e1c2..4fa2e07 100644
> > --- a/drivers/staging/Makefile
> > +++ b/drivers/staging/Makefile
> > @@ -1,7 +1,7 @@
> >  # Makefile for staging directory
> >  
> >  # fix for build system bug...
> > -obj-$(CONFIG_STAGING)		+= staging.o
> > +obj-$(CONFIG_STAGING)		+= staging.o dream/
> 
> Ick, no, you shouldn't have to do this.
> 
> Please jump into the dream subdir based on a Kconfig option, don't go
> there every single time.
> 
> Care to fix this up?

I'm afraid I don't quite have suitable config option. At least
synaptics touchpad should be usable outside dream.

OTOH Dream is still major user; and I guess I can just introduce
"CONFIG_DREAM". Should I?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
