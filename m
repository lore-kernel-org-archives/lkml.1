Return-Path: <linux-kernel-owner+w=401wt.eu-S1760675AbXIRWTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675AbXIRWTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 18:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbXIRWTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 18:19:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:54155 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748AbXIRWTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 18:19:43 -0400
Subject: Re: [PATCH] revert ath5k ioread32()/iowrite32() usage - use
	readl()/writel(), we're MMIO-only
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <43e72e890709181212u75ec6fe2x7aa639bac319c087@mail.gmail.com>
References: <43e72e890709171334y321dc2c8ke255a126a733dad6@mail.gmail.com>
	 <46EEE735.5050306@gmail.com> <46EEEA9B.70407@garzik.org>
	 <46EEF543.7060901@gmail.com>
	 <43e72e890709181203x30144451hf332da4032b5b770@mail.gmail.com>
	 <43e72e890709181212u75ec6fe2x7aa639bac319c087@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 19 Sep 2007 08:18:54 +1000
Message-Id: <1190153934.6403.123.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > > > If the driver knows its MMIO, using readX/writeX after pci_iomap() is
> > > > just fine, for all current implementations, and it makes sense that way.
> > >
> > > There is nothing that guarantees this is permitted, any more than there
> > > is anything saying not to use outb/outl. Some of the implementations do
> > > quite strange things. It may happen to work but its not in the
> > > documentation or the comments.
> >
> > I posted a patch to update the documentation with this.
> >
> > > Please, can anybody clarify it?
> >
> > Based on Alan's 'Review-by' remarks on my patch for updating the
> > documenation on pci_iomap() it seems this validates this patch. Please
> > see thread with subject:
> >
> > [PATCH] Clarify pci_iomap() usage for MMIO-only devices
> 
> Well spoke too soon. Now Linus disagrees. We'll see the outcome on the
> other thread then.

To be more precise, a platform has every right to return some kind of
"token" from ioport_map/pci_iomap that encodes the type of address, and
that is -different- from what a normal ioremap does. In which case, you
will -not- be able to use readb/writeb & cie on such a token.

The fact that current implementations seem to return something for MMIO
that is equivalent to what ioremap returns is an accident and cannot be
relied upon.

Cheers,
Ben.


