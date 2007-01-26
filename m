Return-Path: <linux-kernel-owner+w=401wt.eu-S1030582AbXAZD26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030582AbXAZD26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 22:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030721AbXAZD26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 22:28:58 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48140 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030582AbXAZD25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 22:28:57 -0500
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
	controllers
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@pobox.com>,
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
Date: Fri, 26 Jan 2007 11:28:26 +0800
Message-Id: <1169782107.3593.219.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-01-25 at 18:58 -0800, Linus Torvalds wrote:
> And it's why I decreed, that the ONLY SANE THING is to just let people do 
> the obvious thing:
> 
>         if (!dev->irq)
>                 return -ENODEV;
> 
> you don't have to know ANYTHING, and that code just works, and just looks 
> obvious. And you know what? If it causes a bit of pain for some platform 
> maintainer, I don't care one whit. Because it's obviously much better than 
> the alternatives.

I do understand the benefits; I'm just dubious about the trade-off. If
we could _completely_ isolate our poor crack-addled driver authors from
the nasty number zero then perhaps I'd be less unimpressed, but as it is
they still have to wake up and smell the coffee when it comes to DMA
addresses _anyway_.

When I eventually get to go home, which will hopefully still be some
time this month, I'll give some more coherent thought to the idea of
just using a (struct irq_desc *) directly instead of an integer. Then
you get to use NULL as a special case still. It's not as if people
should be pulling 'raw' IRQ numbers out of a hat or even module
parameters these days, except for ISA drivers where they can do
something like isa_irq[7] for the parallel port etc. Although that kind
of stuff should be done through a platform_device anyway too these days.

> But in the meantime: if nobody complains, and it happens to work on 
> hardware even though some devices _can_ see a port of zero, I also
> don't care. So I'm certainly not going to claim that your laptop "must
> be fixed". If it works, it works. Hey fine.

It's not just "my laptop", I believe. It's the generic resource code,
which is happy to assign address zero since it's never been taught that
zero is now a special case. If we're not going to ask for the bug I
observed to be fixed -- if we're going to declare that driver authors
don't have to sober up and clean up their code -- then the resource code
should be modified accordingly.

-- 
dwmw2

