Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbZFOJqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbZFOJqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZFOJqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:46:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:36829 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbZFOJqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:46:06 -0400
Subject: Re: [PATCH 2/2] uio: add an of_genirq driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Hans J. Koch" <hjk@linutronix.de>, devicetree-discuss@ozlabs.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Greg KH <gregkh@suse.de>
In-Reply-To: <20090615001207.1829e7b5@lxorguk.ukuu.org.uk>
References: <1244765062-14144-1-git-send-email-w.sang@pengutronix.de>
	 <1244765062-14144-3-git-send-email-w.sang@pengutronix.de>
	 <20090614122136.GD3639@local> <20090615001207.1829e7b5@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 19:45:39 +1000
Message-Id: <1245059139.12400.4.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 00:12 +0100, Alan Cox wrote:
> > > +	if (!uioinfo->irq)
> > > +		uioinfo->irq = UIO_IRQ_NONE;
> > 
> > Please don't do this. It's inconsistent if all other UIO drivers require
> > people to use UIO_IRQ_NONE and you also allow zero. UIO_IRQ_NONE was
> > introduced because 0 may be a legal interrupt number on some platforms.
> 
> Zero is not a valid IRQ number in the kernel (except in arch specific
> depths). IRQ numbers are also *unsigned* so -1 isn't a safe definition.
> 
> Zero means no IRQ. If any old UIO code is assuming otherwise it wants
> fixing.
> 
> It is the job of the platform to map a physical IRQ 0 to some other
> representation if it exists outside of arch specific code. This was
> decided some years ago and a large part of the kernel simply doesn't
> support any notion of a real IRQ 0.

Right, and powerpc complies with that rule, so 0 is fine for us.

Cheers,
Ben.

