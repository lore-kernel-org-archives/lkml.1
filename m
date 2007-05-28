Return-Path: <linux-kernel-owner+w=401wt.eu-S1760834AbXE1CyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760834AbXE1CyK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 22:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758857AbXE1Cx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 22:53:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42734
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753299AbXE1Cx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 22:53:56 -0400
Date: Sun, 27 May 2007 19:54:05 -0700 (PDT)
Message-Id: <20070527.195405.41633170.davem@davemloft.net>
To: rdreier@cisco.com
Cc: abraham.manu@gmail.com, greg@kroah.com, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: PCIE
From: David Miller <davem@davemloft.net>
In-Reply-To: <ada3b1h3gke.fsf@cisco.com>
References: <46584C30.4030206@gmail.com>
	<20070526.154910.78725926.davem@davemloft.net>
	<ada3b1h3gke.fsf@cisco.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 27 May 2007 18:03:29 -0700

> I have a hard time imagining a PCI host bus controller that converts
> MSI interrupts back to wire interrupts that go to pins on the CPU.
> For one thing it would be hard to maintain the guarantee that
> MSI interrupts can't pass DMAs.  And it would be an absolutely silly
> architecture too.

We are definitely going to see systems like this, and the DMA issue
will be taken care of by the PCI host controller, it will either pull
out all queued up DMA writes by the device in question itself
(somehow) or require the driver for the PCI host controller do a dummy
read out to the device before servicing an interrupt handler to
guanentee this semantic.

We already have pre-PCI-E controllers on sparc64 where I have to do a
dummy config space read to pull out all the pending DMA requests
before servicing an interrupt, so this kind of scheme would be nothing
new.

People are going to use PCI-E on very inexpensive and primitive cpu
platforms.

The thing to do for such platforms is the use virtual IRQ numbers and
interrogate the PCI-E controller for the MSI number when the CPU level
interrupt arrives and translate that into the appropriate virtual IRQ.
