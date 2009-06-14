Return-Path: <linux-kernel-owner+w=401wt.eu-S1762323AbZFNXJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762323AbZFNXJV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 19:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761378AbZFNXJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 19:09:11 -0400
Received: from kroah.org ([198.145.64.141]:36334 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760495AbZFNXJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 19:09:10 -0400
Date: Sun, 14 Jun 2009 16:04:00 -0700
From: Greg KH <greg@kroah.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt@pengutronix.de,
       Thomas Gleixner <tglx@linutronix.de>, Ian Abbott <abbotti@mev.co.uk>,
       Frank Mori Hess <fmhess@users.sourceforge.net>
Subject: Re: [PATCH -rt] disable building all staging drivers
Message-ID: <20090614230400.GA12366@kroah.com>
References: <1244929118-23326-1-git-send-email-u.kleine-koenig@pengutronix.de> <20090614112802.GA4502@kroah.com> <20090614230044.GA21624@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090614230044.GA21624@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 01:00:44AM +0200, Uwe Kleine-König wrote:
> Hi Greg,
> 
> On Sun, Jun 14, 2009 at 04:28:02AM -0700, Greg KH wrote:
> > On Sat, Jun 13, 2009 at 11:38:38PM +0200, Uwe Kleine-König wrote:
> > > I know that at least COMEDI and RT2870 are broken with -rt,
> > 
> > I didn't know this, has anyone sent me a bug report?  What in -rt causes
> > these drivers to break?
> > 
> > > but Thomas requested disabling all of staging.  He's the maintainer.
> > 
> > This seems like a patch to ensure that the staging drivers never get a
> > chance to be fixed for any potential -rt issues.  How about just sending
> > me bug reports instead?
> COMEDI has:
> 
>   CC [M]  drivers/staging/comedi/comedi_fops.o
> In file included from drivers/staging/comedi/comedidev.h:40,
>                  from drivers/staging/comedi/comedi_fops.c:45:
> drivers/staging/comedi/interrupt.h:27: error: conflicting types for ‘irqreturn_t’
> include/linux/irqreturn.h:14: error: previous declaration of ‘irqreturn_t’ was here
> In file included from drivers/staging/comedi/comedidev.h:40,
>                  from drivers/staging/comedi/comedi_fops.c:45:
> drivers/staging/comedi/interrupt.h:30:1: warning: "IRQ_RETVAL" redefined
> In file included from include/linux/interrupt.h:10,
>                  from drivers/staging/comedi/interrupt.h:22,
>                  from drivers/staging/comedi/comedidev.h:40,
>                  from drivers/staging/comedi/comedi_fops.c:45:
> include/linux/irqreturn.h:15:1: warning: this is the location of the previous definition
> make[3]: *** [drivers/staging/comedi/comedi_fops.o] Error 1
> make[2]: *** [drivers/staging/comedi] Error 2
> make[1]: *** [drivers/staging] Error 2
> make: *** [drivers] Error 2

This should be resolved with the linux-next tree, right?  There are a
few hundred staging patches in there that fix a lot of issues.  They
will all go to Linus in a day or so.

thanks,

greg k-h
