Return-Path: <linux-kernel-owner+w=401wt.eu-S1765579AbXJTGOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765579AbXJTGOW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 02:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXJTGOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 02:14:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:32943 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbXJTGON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 02:14:13 -0400
Subject: Re: [PATCH] synchronize_irq needs a barrier
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
In-Reply-To: <200710200806.41562.maximlevitsky@gmail.com>
References: <1192670742.12879.5.camel@pasglop>
	 <200710200736.22129.maximlevitsky@gmail.com>
	 <1192859184.6745.8.camel@pasglop>
	 <200710200806.41562.maximlevitsky@gmail.com>
Content-Type: text/plain
Date: Sat, 20 Oct 2007 16:13:31 +1000
Message-Id: <1192860811.6745.11.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-10-20 at 08:06 +0200, Maxim Levitsky wrote:

> 	/* Disable interrupts, DMA, and rest of the chip*/
> 	saa_writel(SAA7134_IRQ1, 0);
> 	saa_writel(SAA7134_IRQ2, 0);
> 	saa_writel(SAA7134_MAIN_CTRL, 0);
	
> 	dev->insuspend = 1;
> 	synchronize_irq(pci_dev->irq);
> 
> 	/* ACK pending interrupts just in case*/
> 	saa_writel(SAA7134_IRQ_REPORT,saa_readl(SAA7134_IRQ_REPORT));
> 
> 	......
> This should be bullet-proof.

Hopefully :-)

Cheers,
Ben.


