Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbYLPPYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbYLPPYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856AbYLPPYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:24:33 -0500
Received: from mail.openmoko.org ([88.198.124.205]:55481 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbYLPPYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:24:32 -0500
Date: Tue, 16 Dec 2008 20:54:17 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org, Andy Green <andy@openmoko.com>,
       Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 5/7] power_supply: PCF50633 battery charger driver
Message-ID: <20081216152416.GB23859@cff.thadambail>
References: <20081214110152.3307.50843.stgit@cff.thadambail> <20081214110323.3307.84154.stgit@cff.thadambail> <20081215223811.GA2210@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081215223811.GA2210@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 01:38:11AM +0300, Anton Vorontsov wrote:
> Hello Balaji,
> 
> It's great to see OpenMoko patches submitted, much thanks
> for your work!
> 

Hi Anton,

You are welcome!

> > +
> > +	/* Set up IRQ handlers */
> > +	for (i = 0; i < ARRAY_SIZE(mbc_irq_handlers); i++)
> > +		pcf->irq_handler[mbc_irq_handlers[i]] =
> > +					pcf50633_mbc_irq_handler;
> 
> Ugh. Is there any particular reason why you don't implement a
> chained interrupt controller in the PCF core? (as in
> drivers/mfd/asic3.c, for example).
> 
> That way you could do ordinary request_irq() for the MFD devices'
> interrupts.
> 
> (I can only guess: you didn't make it because PCF is on the
> I2C bus, and it's just easier to handle devices via single
> workqueue in the core driver?)
> 

Since we have a fixed number of irq consumers, it's much simpler doing
chained interrupts this way. Using an irq_chip is going to introduce
unnecessary complezity, I feel.

The V2, of the series (about to be sent) changes how irq managemt
is done - pcf50633_request_irq and pcf50633_free_irq are used.

Thank you for the review.

Will send a new version soon.

	- Balaji
