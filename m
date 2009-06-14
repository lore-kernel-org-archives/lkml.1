Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbZFNXvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbZFNXvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 19:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZFNXvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 19:51:05 -0400
Received: from www.tglx.de ([62.245.132.106]:33556 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbZFNXvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 19:51:03 -0400
Date: Mon, 15 Jun 2009 01:50:53 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: "Hans J. Koch" <hjk@linutronix.de>,
       Wolfgang Grandegger <wg@grandegger.com>, devicetree-discuss@ozlabs.org,
       Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 2/2] uio: add an of_genirq driver
Message-ID: <20090614235053.GK3639@local>
References: <20090614122136.GD3639@local> <20090614171406.GA1010@pengutronix.de> <20090614183357.GE3639@local> <20090614190533.GA7387@pengutronix.de> <20090614192359.GG3639@local> <4A355155.4020500@grandegger.com> <20090614203444.GH3639@local> <20090614220022.GB24323@pengutronix.de> <20090614230135.GI3639@local> <20090614234643.GA17791@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090614234643.GA17791@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 01:46:43AM +0200, Wolfram Sang wrote:
> 
> > driver. A user _has_ to setup irq, if there is none, he still has to set
> > irq=UIO_IRQ_NONE. For that matter, 'not specified' and 'not found' is both
> > the same bad thing.
> 
> Hmm, what should I do?
> 
> A typical interrupts-property in a device-tree is specified as:
> 
> 	interrupts = <&irq_controller_node irq_number irq_sense>;
> 
> Something like UIO_IRQ_NONE does not fit into this scheme, even more as it is
> Linux-specific and device trees need to be OS independant.
> 
> I'm pretty sure the correct way to state that you don't need an interrupt in
> the device-tree is to simply not specify the above interrupt property.
> 
> Well, yes, that means you can't distinguish between 'forgotten' and
> 'intentionally left out'. I wonder if it is really that bad? If something does
> not work (= one is missing interrupts), the first place to look at is the
> device tree. If one does not see an interrupt-property, voila, problem solved.
> 
> (Note that with my latest suggestion, a _wrong_ interrupt is handled the same
> way as with platform_data. request_irq() should equally fail if the
> return-value from irq_of_parse_and_map() is simply forwarded.)

I agree. And assuming Alan is right, forget what I said about IRQ 0 being a
valid interrupt number.

Thanks,
Hans

> 
> -- 
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |


