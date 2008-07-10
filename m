Return-Path: <linux-kernel-owner+w=401wt.eu-S1761694AbYGJTDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761694AbYGJTDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756941AbYGJTDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:03:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46695 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbYGJTDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:03:22 -0400
Date: Thu, 10 Jul 2008 16:02:58 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v3] Add bt8xxgpio driver
Message-ID: <20080710160258.4ddb5c61@gaivota>
In-Reply-To: <200807101914.10174.mb@bu3sch.de>
References: <200807101914.10174.mb@bu3sch.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.4; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Thu, 10 Jul 2008 19:14:09 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> +comment "PCI GPIO expanders:"
> +
> +config GPIO_BT8XX
> +	tristate "BT8XX GPIO abuser"
> +	depends on PCI && VIDEO_BT848=n
> +	help
> +	  The BT8xx frame grabber chip has 24 GPIO pins than can be abused
> +	  as a cheap PCI GPIO card.
> +
> +	  This chip can be found on Miro, Hauppauge and STB TV-cards.
> +
> +	  The card needs to be physically altered for using it as a
> +	  GPIO card. For more information on how to build a GPIO card
> +	  from a BT8xx TV card, see the documentation file at
> +	  Documentation/bt8xxgpio.txt
> +
> +	  If unsure, say N.
> +
>  comment "SPI GPIO expanders:"

... 

> +static struct pci_device_id bt8xxgpio_pci_tbl[] = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT848) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT849) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT878) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT879) },
> +	{ 0, },

Even being an old design, there are still several new cheap boards based on
those devices (for example, I received those days a new Encore board with a
bttv chip). So, a driver for electronics hackers for using this chip as a
generic io driver shouldn't cause regressions at the real video streaming
driver, that are used by a large number of people.

However, the way you've defined the pci table, and your Kconfig allows someone
to compile both the real driver and the gpio only driver, and they are
currently incompatible.

So, this will cause a regression.

One alternative would be to make the gpio driver dependent of !VIDEO_BT848.

However, a much better alternative would be if you can rework on it to be a
module that adds this functionality to the original driver, allowing to have
both video control and gpio control, since, on a few cases like surveillance
systems, the gpio's may be used for other things, like controlling security
sensors, or switching a video commutter.

Btw, if you are thinking on using it for your electronics hacking, one very
interesting feature would be to use the bttv 8-bit high speed ADC as a generic
ADC. On its normal operation, it samples from video inputs at 27 MHz (maybe you
can sample on even higher frequencies, by properly configuring the sampling divider).


Cheers,
Mauro
