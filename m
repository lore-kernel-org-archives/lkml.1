Return-Path: <linux-kernel-owner+w=401wt.eu-S1761107AbZFONJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761107AbZFONJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZFONJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:09:21 -0400
Received: from trinity.fluff.org ([89.16.178.74]:53482 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760868AbZFONJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:09:20 -0400
Date: Mon, 15 Jun 2009 14:09:06 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Florian Fainelli <florian@openwrt.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Alek Du <alek.du@intel.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpiolib: Add gpio_detect, gpio_debounce and gpio_alt_func features to GPIOLIB
Message-ID: <20090615130906.GA14476@trinity.fluff.org>
References: <20090615171502.2a981bf5@dxy.sh.intel.com> <20090615125146.GC19873@fluff.org.uk> <200906151504.51934.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200906151504.51934.florian@openwrt.org>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 03:04:50PM +0200, Florian Fainelli wrote:
> Le Monday 15 June 2009 14:51:46 Ben Dooks, vous avez écrit :
> > On Mon, Jun 15, 2009 at 05:15:02PM +0800, Alek Du wrote:
> > > >From 7a76916ccea4a376a260ea67fbc79ac4d958757f Mon Sep 17 00:00:00 2001
> > >
> > > From: Alek Du <alek.du@intel.com>
> > > Date: Fri, 8 May 2009 09:46:49 +0800
> > > Subject: [PATCH] gpiolib: Add gpio_detect, gpio_debounce and
> > > gpio_alt_func features to GPIOLIB
> > >
> > > Add some more functions to GPIOLIB, they are:
> > > * gpio_detect is to set GPIO interrupt triggering method (edge, level,
> > > high, low, etc.)
> 
> The name does not seem to reflect what it does, what about gpio_set_type or 
> gpio_set_int_type for instance ?

You seem to have made the same case as myself to why this call is irrelevant
to the gpiolib layer.
 
> >
> > This is the wrong way of doing it, there is as a definit set_type
> > method in the irq_chip structure which should be used to alter the
> > way the IRQ is triggered.
> 
> I would expect your architecture IRQ handler to have a set_type callback for 
> the GPIO lines capables of generating an interrupt. See how we have beeing 
> doing it for rb532 for instance: 
> http://www.linux-mips.org/git?p=linux-queue.git;a=blob;f=arch/mips/rb532/irq.c;h=f07882029a90d3d155c17b462812c2936229458c;hb=HEAD#l173

Yes, or if the GPIO driver is exporting interrupts, the relevant handler
for that chip should have the .set_type method defined.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

