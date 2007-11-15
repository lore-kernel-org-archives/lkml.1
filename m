Return-Path: <linux-kernel-owner+w=401wt.eu-S1763907AbXKOHgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763907AbXKOHgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757705AbXKOHgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 02:36:12 -0500
Received: from www.tglx.de ([62.245.132.106]:50473 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbXKOHgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 02:36:11 -0500
Date: Thu, 15 Nov 2007 08:35:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Brownell <david-b@pacbell.net>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
In-Reply-To: <200711142317.14230.david-b@pacbell.net>
Message-ID: <alpine.LFD.0.9999.0711150833250.3265@localhost.localdomain>
References: <200711091136.20051.david-b@pacbell.net> <200711121726.39263.david-b@pacbell.net> <alpine.LFD.0.9999.0711141228210.3265@localhost.localdomain> <200711142317.14230.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007, David Brownell wrote:

> On Wednesday 14 November 2007, Thomas Gleixner wrote:
> > struct gpio_desc {
> > 	   struct gpio_chip *chip;
> > 	   int pinoffset;
> > };
> 
> Eric Miao has a different notion of "gpio_desc" more analagous to
> the "irq_desc", so I'll not use that name for such a structure.
> 
> Let me call yours a "struct gpio_pin" instead -- purely for some
> discussion here.
>
> 
> There's been some desire for a "gpio_pin" struct for entirely
> different reasons ... as the identifiers passed into a slightly
> different type of GPIO programming interface.  So for example
> 
>   static inline void gpiopin_set_value(struct gpio_pin *p, int v)
>   {
> 	p->chip->set(p->chip, p->pinoffset, v);
>   }
> 
> One reason to be interested in gpio_chip is that it it would
> easily support interoperation between traditional GPIO ID schemes
> (numbered to match the SOC at the heart of a given board) and
> more dynamic ones that might be needed to use curiousities like
> a set of USB-to-GPIO adapters.

So can we please do this right from the beginning instead of adding a
new library first which suffers from bad design compromises.

    tglx
