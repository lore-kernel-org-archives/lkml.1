Return-Path: <linux-kernel-owner+w=401wt.eu-S932493AbXIIShB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbXIIShB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 14:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757831AbXIISgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 14:36:53 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:6993 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757784AbXIISgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 14:36:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KGSz64PiSAKWV/JkSazaQm2CfmDOT6dLCCZVKPEqVOC9vJZE2niw0jppFwEOROSVub9c7J9lSf4lsT0d4DKZGR9Hs4SvwaMMN2T9rTXIEb2MyCiV5hfVozHB9cfVBDjfEjv1cYauoB2VYEDUxM4d9KYcA6U5ymXXmSzqIiV4YgI=
Message-ID: <8b67d60709091136s4629d8e7tb1ec0e583a2ac52f@mail.gmail.com>
Date: Sun, 9 Sep 2007 19:36:52 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH 1/3] Maple bus support for the Sega Dreamcast
Cc: "Paul Mundt" <lethal@linux-sh.org>, linuxsh-dev@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070909192807.3bc2410d@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8b67d60709090946y31508ffhf752414872368d8c@mail.gmail.com>
	 <20070909192807.3bc2410d@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/07, Arjan van de Ven <arjan@infradead.org> wrote:
> On Sun, 9 Sep 2007 17:46:54 +0100
> "Adrian McMenamin" <lkmladrian@gmail.com> wrote:
>
> > This patch adds support for Sega's proprietary Maple bus - which is
> > required to support the Dreamcast's peripherals.
>

>
> First of all, I'm a little concerned about the lack of locking that
> this driver seems to have; what guarantees the integrity of the lists
> used in the driver?
>
Could you explain what you think the issue is? The lists are only
handled by this driver and not anything else.


> Second, you have a lot of use of likely() and unlikely(); so much that I think it's waaaay overkill. The code it's in generally isn't hotpath, and gcc also does a pretty decent job without giving these hints in general.
>
>
>

Fair enough.

> > +
> > +void maple_add_packet(struct mapleq *mq)
> > +{
> > +     list_add((struct list_head *) mq, &maple_waitq);
> > +}
>
> for example this list.. what makes sure that no 2 pieces of code muck with it at the same time?
>
>

Because everything is handled by one kernel thread on a uniprocessor machine.


> > +static irqreturn_t maplebus_dma_interrupt(int irq, void *dev_id)
> > +{
> > +     /* Load everything into the bottom half */
> > +     schedule_work(&maple_dma_process);
> > +     return IRQ_HANDLED;
> > +}
>
> I wonder if you want to at least check if the work was really for you before returning IRQ_HANDLED....
>

It's *always* for me - this is an end of DMA interrupt for the bus.
