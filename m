Return-Path: <linux-kernel-owner+w=401wt.eu-S1758196AbZFNXqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbZFNXqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 19:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbZFNXqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 19:46:01 -0400
Received: from www.tglx.de ([62.245.132.106]:41088 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbZFNXqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 19:46:00 -0400
Date: Mon, 15 Jun 2009 01:45:46 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Wolfram Sang <w.sang@pengutronix.de>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       devicetree-discuss@ozlabs.org, Magnus Damm <magnus.damm@gmail.com>,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 2/2] uio: add an of_genirq driver
Message-ID: <20090614234546.GJ3639@local>
References: <1244765062-14144-1-git-send-email-w.sang@pengutronix.de> <1244765062-14144-3-git-send-email-w.sang@pengutronix.de> <20090614122136.GD3639@local> <20090615001207.1829e7b5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615001207.1829e7b5@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 12:12:07AM +0100, Alan Cox wrote:
> > > +	if (!uioinfo->irq)
> > > +		uioinfo->irq = UIO_IRQ_NONE;
> > 
> > Please don't do this. It's inconsistent if all other UIO drivers require
> > people to use UIO_IRQ_NONE and you also allow zero. UIO_IRQ_NONE was
> > introduced because 0 may be a legal interrupt number on some platforms.
> 
> Zero is not a valid IRQ number in the kernel (except in arch specific
> depths). IRQ numbers are also *unsigned* so -1 isn't a safe definition.

The above uioinfo->irq is a signed long.

> 
> Zero means no IRQ. If any old UIO code is assuming otherwise it wants
> fixing.

It doesn't. It won't complain about IRQ 0 and will pass it on to
request_irq, which will probably fail if it is as you say.

I did it that way because I saw IRQ 0 in /proc/interrupts on every PC...

> 
> It is the job of the platform to map a physical IRQ 0 to some other
> representation if it exists outside of arch specific code.

Funny.

> This was
> decided some years ago and a large part of the kernel simply doesn't
> support any notion of a real IRQ 0.

Can you tell me the reason for that decision or point me to some ml archive?

Thanks,
Hans

> 
> Alan
