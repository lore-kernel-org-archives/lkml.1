Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbYGILia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbYGILia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbYGILiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:38:22 -0400
Received: from trinity.fluff.org ([89.145.97.151]:52044 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbYGILiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:38:21 -0400
Date: Wed, 9 Jul 2008 12:38:19 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Dmitry <dbaryshkov@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [patch 3/4] MFD: Remove unnecessary fields if mfd_cell structure.
Message-ID: <20080709113818.GJ8517@trinity.fluff.org>
References: <20080709104916.200210922@fluff.org> <20080709104932.905074060@fluff.org> <bc64b4640807090409h2ebb8f4embae20b8511fbe459@mail.gmail.com> <20080709111215.GL8489@trinity.fluff.org> <bc64b4640807090416k7ab2f24aj1eae0cfd6c79b106@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc64b4640807090416k7ab2f24aj1eae0cfd6c79b106@mail.gmail.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 03:16:47PM +0400, Dmitry wrote:
> 2008/7/9 Ben Dooks <ben-linux@fluff.org>:
> > On Wed, Jul 09, 2008 at 03:09:12PM +0400, Dmitry wrote:
> >> 2008/7/9 Ben Dooks <ben-linux@fluff.org>:
> >> > The enable,disable,suspend and resume entry in the struct mfd_cell
> >> > do not seem to be necessary as they should be handled by the
> >> > platform driver that the device created has bound to.
> >>
> >> NAK. It's used e.g. by the tmio-nand driver. These fields provide easy
> >> way to support
> >> enhanced power management, etc.
> >
> > What enhancements over the standard platform device model do you need?
> 
> As an example of what  we need, please check the tmio-nand driver.

As posted below, the driver on the linux-mtd list does not use this,
and further more in [1] the method of getting to the the mfd_cell from
a given platform_device has gone which would be used by [2] if it
actually touched the mfd_cell information.
 
[1] http://lists.arm.linux.org.uk/lurker/message/20080708.153450.bb33046d.en.html
[2] http://lists.infradead.org/pipermail/linux-mtd/2008-June/022137.html

> >
> >> >
> >> > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> >> >
> >> > Index: linux-2.6.26-rc9-next20080709/include/linux/mfd/core.h
> >> > ===================================================================
> >> > --- linux-2.6.26-rc9-next20080709.orig/include/linux/mfd/core.h 2008-07-09 10:44:45.000000000 +0100
> >> > +++ linux-2.6.26-rc9-next20080709/include/linux/mfd/core.h      2008-07-09 10:45:06.000000000 +0100
> >> > @@ -23,12 +26,6 @@
> >> >  */
> >> >  struct mfd_cell {
> >> >        const char              *name;
> >> > -
> >> > -       int                     (*enable)(struct platform_device *dev);
> >> > -       int                     (*disable)(struct platform_device *dev);
> >> > -       int                     (*suspend)(struct platform_device *dev);
> >> > -       int                     (*resume)(struct platform_device *dev);
> >> > -
> >> >        void                    *driver_data; /* driver-specific data */
> >> >
> >> >        /*
> >> >
> >> > --
> >> >
> >>
> >>
> >>
> >> --
> >> With best wishes
> >> Dmitry
> >
> > --
> > --
> > Ben
> >
> > Q:      What's a light-year?
> > A:      One-third less calories than a regular year.
> >
> >
> 
> 
> 
> -- 
> With best wishes
> Dmitry
> 
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

