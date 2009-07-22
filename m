Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbZGVRIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbZGVRIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 13:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbZGVRIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 13:08:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52651 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753864AbZGVRIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 13:08:39 -0400
Date: Wed, 22 Jul 2009 18:08:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       Peter Zijlstra <peterz@infradead.org>,
       Daniel Ribeiro <drwyrm@gmail.com>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
Message-ID: <20090722170837.GC21186@rakim.wolfsonmicro.main>
References: <20090721113642.GC13286@sirena.org.uk>
 <alpine.LFD.2.00.0907221427380.2813@localhost.localdomain>
 <20090722133131.GA28355@rakim.wolfsonmicro.main>
 <200907221004.11100.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907221004.11100.david-b@pacbell.net>
X-Cookie: Sign here without admitting guilt.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 10:04:10AM -0700, David Brownell wrote:
> On Wednesday 22 July 2009, Mark Brown wrote:

> > source for a PMIC then we've got generic code that expects to just take
> > a gpio/irq and interact with it.

> Is there a problem with how it works now?  GPIO calls come in
> sleeping (e.g. over I2C or SPI) and non-sleeping (classic SoC
> GPIOs) varieties.  And it's not gpiolib which would handle any

I don't think there's any problem at all with gpiolib at all, it's just
an example user here.

> IRQ support ... it's the driver for the GPIO chip, which would
> expose both irq_chip and gpio_chip facets.  (Just like classic
> SoC GPIO drivers.)

Ah, yeah.  If the chip IRQ driver handles the waking of the core thread 
then this'd not be a problem.  For some reason I was thinking of the
driver using gpiolib when I read Thomas' post.
