Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbZGLIsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbZGLIsl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 04:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbZGLIse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 04:48:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36044 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbZGLIsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 04:48:33 -0400
Date: Sun, 12 Jul 2009 09:47:34 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: David Brownell <david-b@pacbell.net>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Philipp Zabel <philipp.zabel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH] move omap_udc's probe function to .devinit.text
Message-ID: <20090712084734.GA944@flint.arm.linux.org.uk>
References: <20090711170548.GC5205@suse.de> <1247345591-22643-37-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-38-git-send-email-u.kleine-koenig@pengutronix.de> <200907111530.44736.david-b@pacbell.net> <20090712083510.GA24424@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090712083510.GA24424@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 12, 2009 at 10:35:10AM +0200, Uwe Kleine-König wrote:
> Hello David,
> 
> On Sat, Jul 11, 2009 at 03:30:44PM -0700, David Brownell wrote:
> > On Saturday 11 July 2009, Uwe Kleine-König wrote:
> > > An alternative to this patch is using platform_driver_probe instead of
> > > platform_driver_register plus removing the pointer to the probe function
> > > from the struct platform_driver.
> > 
> > Repeat -- NAK on this.  Use platform_driver_probe() instead.
> > 
> > I really don't like this series of patches.  It's just adding
> > bloat to kernels, in chunks of up to a page per patch.
> I'm aware that in some cases platform_driver_probe is better.  But as I
> don't have access to most of the affected platforms I consider it saver.
> That's why I choosed this way.  The problem with platform_driver_probe
> is that if a device is added only after the driver is probed the
> device isn't bound.

Your approach is perfectly fine, and safe.  You're not adding any
additional bloat which isn't already there.  If it were adding any
bloat (which it isn't), it certainly is not "in chunks of up to a
page per patch".

Overall, this patch is an improvement, so all these get my ack, and
they should be applied as is.

Using platform_driver_probe() does allow you to reduce the kernel
footprint still further, but that requires knowledge of the platforms
affected (knowing that the platform devices are present before the
drivers get probed.)

I'll apply the ones for drivers I look after later today.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
