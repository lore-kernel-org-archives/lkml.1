Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbZFOIoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbZFOIoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbZFOIny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:43:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35123 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753766AbZFOInx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:43:53 -0400
Date: Mon, 15 Jun 2009 09:44:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Wolfram Sang <w.sang@pengutronix.de>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       devicetree-discuss@ozlabs.org, Magnus Damm <magnus.damm@gmail.com>,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 2/2] uio: add an of_genirq driver
Message-ID: <20090615094449.04b029f0@lxorguk.ukuu.org.uk>
In-Reply-To: <20090614234546.GJ3639@local>
References: <1244765062-14144-1-git-send-email-w.sang@pengutronix.de>
	<1244765062-14144-3-git-send-email-w.sang@pengutronix.de>
	<20090614122136.GD3639@local>
	<20090615001207.1829e7b5@lxorguk.ukuu.org.uk>
	<20090614234546.GJ3639@local>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I did it that way because I saw IRQ 0 in /proc/interrupts on every PC...
> 
> > 
> > It is the job of the platform to map a physical IRQ 0 to some other
> > representation if it exists outside of arch specific code.
> 
> Funny.
> 
> > This was
> > decided some years ago and a large part of the kernel simply doesn't
> > support any notion of a real IRQ 0.
> 
> Can you tell me the reason for that decision or point me to some ml archive?

The natural C way to write "No xxx" is if (!xxx) hence

	if (!dev->irq) {
		polling_start();
		return 0;
	}

The PC "IRQ 0" is the timer - which only appears in the arch code.

Alan
