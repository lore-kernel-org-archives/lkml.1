Return-Path: <linux-kernel-owner+w=401wt.eu-S1761297AbZFNXLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761297AbZFNXLS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 19:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755606AbZFNXLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 19:11:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48124 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751507AbZFNXLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 19:11:06 -0400
Date: Mon, 15 Jun 2009 00:12:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, devicetree-discuss@ozlabs.org,
       Magnus Damm <magnus.damm@gmail.com>, "Hans J. Koch" <hjk@linutronix.de>,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 2/2] uio: add an of_genirq driver
Message-ID: <20090615001207.1829e7b5@lxorguk.ukuu.org.uk>
In-Reply-To: <20090614122136.GD3639@local>
References: <1244765062-14144-1-git-send-email-w.sang@pengutronix.de>
	<1244765062-14144-3-git-send-email-w.sang@pengutronix.de>
	<20090614122136.GD3639@local>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	if (!uioinfo->irq)
> > +		uioinfo->irq = UIO_IRQ_NONE;
> 
> Please don't do this. It's inconsistent if all other UIO drivers require
> people to use UIO_IRQ_NONE and you also allow zero. UIO_IRQ_NONE was
> introduced because 0 may be a legal interrupt number on some platforms.

Zero is not a valid IRQ number in the kernel (except in arch specific
depths). IRQ numbers are also *unsigned* so -1 isn't a safe definition.

Zero means no IRQ. If any old UIO code is assuming otherwise it wants
fixing.

It is the job of the platform to map a physical IRQ 0 to some other
representation if it exists outside of arch specific code. This was
decided some years ago and a large part of the kernel simply doesn't
support any notion of a real IRQ 0.

Alan
