Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbZFPIj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbZFPIj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZFPIjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:39:51 -0400
Received: from trinity.fluff.org ([89.16.178.74]:51565 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbZFPIju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:39:50 -0400
Date: Tue, 16 Jun 2009 09:39:48 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Alek Du <alek.du@intel.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Florian Fainelli <florian@openwrt.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpiolib: Add gpio_detect, gpio_debounce and gpio_alt_func features to GPIOLIB
Message-ID: <20090616083948.GB14476@trinity.fluff.org>
References: <20090615171502.2a981bf5@dxy.sh.intel.com> <20090615125146.GC19873@fluff.org.uk> <200906151504.51934.florian@openwrt.org> <20090615130906.GA14476@trinity.fluff.org> <20090616092848.7bb60f21@dxy.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616092848.7bb60f21@dxy.sh.intel.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 09:28:48AM +0800, Alek Du wrote:
> On Mon, 15 Jun 2009 21:09:06 +0800
> Ben Dooks <ben-linux@fluff.org> wrote:
> 
> > > 
> > > I would expect your architecture IRQ handler to have a set_type callback for 
> > > the GPIO lines capables of generating an interrupt. See how we have beeing 
> > > doing it for rb532 for instance: 
> > > http://www.linux-mips.org/git?p=linux-queue.git;a=blob;f=arch/mips/rb532/irq.c;h=f07882029a90d3d155c17b462812c2936229458c;hb=HEAD#l173
> > 
> > Yes, or if the GPIO driver is exporting interrupts, the relevant handler
> > for that chip should have the .set_type method defined.
> > 
> 
> In the .set_type method, you finally will call the GPIO driver's function to set interrupt trigger mode, right?

No, that's totaly the wrong way around. GPIOLIB provides an GPIO to IRQ
function that the driver providing the GPIOLIB chip needs to provide. To do
IRQs, the same driver will have to provide a irq chip and that is the place
where this functionality should reside.

> Current GPIOLIB do not provide such an interface. Current driver always exports a separate function to do that --
> that's not good.
> My patch provide a general API to do that.

When there's already an extant API to do that. There are drivers already
doing it this way.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

