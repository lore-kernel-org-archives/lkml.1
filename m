Return-Path: <linux-kernel-owner+w=401wt.eu-S1762330AbYFEVQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762330AbYFEVQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 17:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbYFEVQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 17:16:29 -0400
Received: from server.drzeus.cx ([85.8.24.28]:38181 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752422AbYFEVQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 17:16:28 -0400
Date: Thu, 5 Jun 2008 23:16:04 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: avorontsov@ru.mvista.com
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>,
       Gary Jennejohn <garyj@denx.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] mmc_spi: export probe and remove functions
Message-ID: <20080605231604.08cd04ca@mjolnir.drzeus.cx>
In-Reply-To: <20080602125337.GA2872@polina.dev.rtsoft.ru>
References: <20080523182754.GA26891@polina.dev.rtsoft.ru>
	<20080523182834.GA469@polina.dev.rtsoft.ru>
	<20080526141836.72db0623@mjolnir.drzeus.cx>
	<20080526122533.GA9595@polina.dev.rtsoft.ru>
	<20080526131009.GA19861@polina.dev.rtsoft.ru>
	<20080601121841.0392b01c@mjolnir.drzeus.cx>
	<20080602125337.GA2872@polina.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008 16:53:37 +0400
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> On Sun, Jun 01, 2008 at 12:18:41PM +0200, Pierre Ossman wrote:
> > On Mon, 26 May 2008 17:10:09 +0400
> > Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> > 
> > > 
> > > Btw, this isn't actually drivers encapsulating. This is about making
> > > mmc_spi export some "library" function which could be used by other
> > > bindings.
> > > 
> > > Think of usb_add_hcd() used by various drivers' bindings for e.g.
> > > drivers/usb/host/ehci-*.c. Though usb_add_hcd() is more generic
> > > than just "EHCI" bindings, but only because there is nothing to
> > > share between them. (for MMC over SPI bindings all we want to do is fill
> > > the platform data).
> > > 
> > 
> > There's a big difference.
> 
> This depends on the perception. :-)
> 
> > usb_add_hcd() is designed specifically to be called by other, real probe
> > functions.
> 
> Yes, by convention (or better, by design).
> 
> > mmc_spi_probe() _is_ a probe function. 
> 
> Yes, so far.
> 
> > Also exporting it as a library function is very confusing.
> 
> No, if designed/documented properly.
> 
> Just imagine this (100% similarity to USB code):
> 
> mmc_spi_create_hcd(&mmc_spi_driver, dev, dev->bus_id);
> mmc_spi_add_hcd(dev, irq, irqflags);
> 

I'm not necessarily against that idea. What I don't like is using a
function for different things. So you'd need to restructure things a
bit, and not just export the probe function.

> > 
> > From what I can tell, the OF stuff behaves very much like the PNP
> > system on PCs. The information relayed is a bit more versatile though.
> > Perhaps what is needed is a more advanced "platform" bus that is
> > modeled after the PNP bus, but with the extra ability of handling the
> > stuff currently crammed into the platform structures. mmc_spi would
> > then be extended to be driver for the "platform" bus and we could have
> > generic calls like platform_get_pin(dev, "ro");.
> 
> platform_get_pin()? Um, maybe platform_get_gpio(), as _irq()? Yes,
> this is doable (and someday this should be done). But this way we can
> pass only GPIOs and then teach mmc_spi to work with them directly
> (in addition to callbacks).
> 
> But this is not enough, there is still no way to pass real platform data,
> such as: caps and ocr_mask. Any idea how to deliver these?
> 

platform_get_attr("ocr") perhaps? I'm afraid I have not dealt enough
with the embedded parts of the kernel to give a complete suggestion as
to how this might be solved.

My concern is building something OF specific right now, only to have to
restructure things when the next firmware interface shows up and having
to deal with all the fallout caused by API changes.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
