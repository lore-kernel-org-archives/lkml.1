Return-Path: <linux-kernel-owner+w=401wt.eu-S932965AbXA1XEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbXA1XEZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 18:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932957AbXA1XEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 18:04:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:53686 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932963AbXA1XEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 18:04:24 -0500
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
	controllers
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0701251832040.25027@woody.linux-foundation.org>
References: <20070125150905.652f9ce2@localhost.localdomain>
	 <1169741658.3593.98.camel@shinybook.infradead.org>
	 <20070125172739.0c990a9a@localhost.localdomain>
	 <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org>
	 <1169770985.3593.146.camel@shinybook.infradead.org>
	 <Pine.LNX.4.64.0701251703570.25027@woody.linux-foundation.org>
	 <1169778239.3593.195.camel@shinybook.infradead.org>
	 <Pine.LNX.4.64.0701251832040.25027@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 10:04:10 +1100
Message-Id: <1170025451.26655.104.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> We could have done it for interrupts too. A "struct irqnum" that has a bit 
> that specifies "valid". That would work. But it tends to be painful, so it 
> really has to give you something more than "zero is disabled".
> 
> It's just not worth it.
> 
> And it's why I decreed, that the ONLY SANE THING is to just let people do 
> the obvious thing:
> 
> 	if (!dev->irq)
> 		return -ENODEV;
> 
> you don't have to know ANYTHING, and that code just works, and just looks 
> obvious. And you know what? If it causes a bit of pain for some platform 
> maintainer, I don't care one whit. Because it's obviously much better than 
> the alternatives.

I'd rather have dev->irq be a struct interrupt * :-) The NULL check
would then make more sense and we completely remove "numbers" from
drivers, they have to obtain their struct interrupt via some interrupt
mapping code....

Ben.

