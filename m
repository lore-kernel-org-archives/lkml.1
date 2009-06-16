Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbZFPSXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbZFPSXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbZFPSXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:23:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49852 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbZFPSXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:23:08 -0400
Date: Tue, 16 Jun 2009 20:23:10 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 012/143] USB: move twl4030_usb's probe function to
	.devinit.text
Message-ID: <20090616182310.GC13048@pengutronix.de>
References: <20090616051356.GB23627@kroah.com> <1245129858-23818-12-git-send-email-gregkh@suse.de> <20090616060559.GA18333@pengutronix.de> <20090616062035.GA32226@suse.de> <20090616091444.GA23840@pengutronix.de> <20090616162106.GC26879@suse.de> <20090616175900.GA13048@pengutronix.de> <20090616180053.GA28158@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090616180053.GA28158@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jun 16, 2009 at 11:00:53AM -0700, Greg KH wrote:
> On Tue, Jun 16, 2009 at 07:59:00PM +0200, Uwe Kleine-König wrote:
> > Hello,
> > 
> > On Tue, Jun 16, 2009 at 09:21:06AM -0700, Greg KH wrote:
> > > On Tue, Jun 16, 2009 at 11:14:44AM +0200, Uwe Kleine-König wrote:
> > > > Hi Greg,
> > > > 
> > > > On Mon, Jun 15, 2009 at 11:20:35PM -0700, Greg KH wrote:
> > > > > On Tue, Jun 16, 2009 at 08:05:59AM +0200, Uwe Kleine-König wrote:
> > > > > > Hi Greg,
> > > > > > 
> > > > > > On Mon, Jun 15, 2009 at 10:22:07PM -0700, Greg Kroah-Hartman wrote:
> > > > > > > A pointer to twl4030_usb_probe is passed to the core via
> > > > > > > platform_driver_register and so the function must not disappear when the
> > > > > > > .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> > > > > > > unbinding and binding a device to the driver via sysfs will result in an
> > > > > > > oops as does a device being registered late.
> > > > > > > 
> > > > > > > An alternative to this patch is using platform_driver_probe instead of
> > > > > > > platform_driver_register plus removing the pointer to the probe function
> > > > > > > from the struct platform_driver.
> > > > > > I wonder if this kind of error could be detected automatically.  That is
> > > > > > at probe time check if the probe function is in the .init.text section.
> > > > > 
> > > > > There's nothing wrong with calling probe functions in the .init.text
> > > > > section, _before_ we throw away the init.text section :)
> > > > Ah, my fault:
> > > > 
> > > > I wonder if this kind of error could be detected automatically.  That is
> > > > at *register* time check if the probe function is in the .init.text
> > > > section.
> > > 
> > > But again, we can register devices with their probe functions in
> > > .init.text and use them, before .init.text is thrown away, right?
> > Yes, but only if you unregister the driver before .init.text is thrown
> > away, right?
> > 
> > If your driver is still active while .init.text already disappeared a new
> > device makes your kernel oops.
> 
> Yes, but for almost all platform devices, they can not have a new device
> appear after init runs, as they are fixed to the motherboard.
The same check could be implemented for drivers of the other bus types,
too.
 
> Anyway, if you want to send a patch to dynamically catch this kind of
> problem, that would be great.
I somehow feared that at one point someone wants a patch from me if I
ask if it's possible at all ... :-)

/me goes and searces if there is already a function to check if a
pointer points into .init.text.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
