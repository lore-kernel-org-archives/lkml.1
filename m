Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbZFPQak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbZFPQak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbZFPQab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:30:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763AbZFPQaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:30:30 -0400
Date: Tue, 16 Jun 2009 09:21:06 -0700
From: Greg KH <gregkh@suse.de>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 012/143] USB: move twl4030_usb's probe function to
	.devinit.text
Message-ID: <20090616162106.GC26879@suse.de>
References: <20090616051356.GB23627@kroah.com> <1245129858-23818-12-git-send-email-gregkh@suse.de> <20090616060559.GA18333@pengutronix.de> <20090616062035.GA32226@suse.de> <20090616091444.GA23840@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090616091444.GA23840@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 11:14:44AM +0200, Uwe Kleine-König wrote:
> Hi Greg,
> 
> On Mon, Jun 15, 2009 at 11:20:35PM -0700, Greg KH wrote:
> > On Tue, Jun 16, 2009 at 08:05:59AM +0200, Uwe Kleine-König wrote:
> > > Hi Greg,
> > > 
> > > On Mon, Jun 15, 2009 at 10:22:07PM -0700, Greg Kroah-Hartman wrote:
> > > > A pointer to twl4030_usb_probe is passed to the core via
> > > > platform_driver_register and so the function must not disappear when the
> > > > .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> > > > unbinding and binding a device to the driver via sysfs will result in an
> > > > oops as does a device being registered late.
> > > > 
> > > > An alternative to this patch is using platform_driver_probe instead of
> > > > platform_driver_register plus removing the pointer to the probe function
> > > > from the struct platform_driver.
> > > I wonder if this kind of error could be detected automatically.  That is
> > > at probe time check if the probe function is in the .init.text section.
> > 
> > There's nothing wrong with calling probe functions in the .init.text
> > section, _before_ we throw away the init.text section :)
> Ah, my fault:
> 
> I wonder if this kind of error could be detected automatically.  That is
> at *register* time check if the probe function is in the .init.text
> section.

But again, we can register devices with their probe functions in
.init.text and use them, before .init.text is thrown away, right?

So I don't see an easy way to check this and keep people from doing
stupid things...

thanks,

greg k-h
