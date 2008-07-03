Return-Path: <linux-kernel-owner+w=401wt.eu-S1753746AbYGCL4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbYGCL4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 07:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbYGCLzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 07:55:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:36305 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbYGCLzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 07:55:14 -0400
Subject: Re: Multiple MSI
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: michaele@au1.ibm.com, Matthew Wilcox <matthew@wil.cx>,
       linux-pci@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Dan Williams <dan.j.williams@intel.com>, Martine.Silbermann@hp.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <200807031110.30072.arnd@arndb.de>
References: <20080703024445.GA14894@parisc-linux.org>
	 <1215060119.21182.77.camel@pasglop> <1215067484.17950.35.camel@localhost>
	 <200807031110.30072.arnd@arndb.de>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 19:17:00 +1000
Message-Id: <1215076620.19689.2.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Some years ago, we had discussions about getting rid of IRQ numbers
> altogether, or at least the requirement to have device drivers know
> about them. Does anyone remember what happened to that idea?

I think it's not totally dead. Last I heard, someone (jgarzik ?) was
slowly, bit by bit, removing the dependencies on the irq argument on irq
handlers which is one step in the direction.

> I think the concept was that you pass around struct irq_desc pointers
> that may or may not be dynamically allocated by the interrupt controller
> code.

Yup. There are still a few hard dependencies on numbers left and right
tho. The main issue is old userspace tied to the layout of things
like /proc/interrupts though I'd be happy to special case the 16
"legacy" interrupts (like we do on powerpc in our remapping layer) and
only show these here ...

> Another simplification that should really help here is encapsulating
> request_irq() per subsystem so that you can do something like
> 
> int my_irq(struct pci_dev *dev);
> err = pci_request_irq(pci_dev, &my_irq, IRQF_SHARED);
> 
> Most PCI drivers should be trivial to convert to this model. If you want
> to have multiple MSI/MSI-X interrupts for one PCI device with this model,
> you'd need to introduce the number back as an offset, I guess.

Might indeed be a good idea.

Cheers,
Ben.


