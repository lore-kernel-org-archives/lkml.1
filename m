Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbXE0Aak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbXE0Aak (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 20:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbXE0Aad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 20:30:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53248
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750995AbXE0Aad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 20:30:33 -0400
Date: Sat, 26 May 2007 17:30:37 -0700 (PDT)
Message-Id: <20070526.173037.45196275.davem@davemloft.net>
To: grundler@parisc-linux.org
Cc: abraham.manu@gmail.com, rdreier@cisco.com, greg@kroah.com,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: PCIE
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070527001631.GC31023@colo.lackof.org>
References: <20070526235515.GA31023@colo.lackof.org>
	<20070526.170039.119261389.davem@davemloft.net>
	<20070527001631.GC31023@colo.lackof.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Grundler <grundler@parisc-linux.org>
Date: Sat, 26 May 2007 18:16:31 -0600

> Are they really? The device is generating the transaction on the bus.
> The PCI host controller (in general) will be routing that transaction
> to wherever the "dest addr" of the MSI lives. It doesn't have to be
> in the CPU but it will certainly be a proxy for that CPU if it's not.
> We won't care if the proxy only have one IRQ line going to the CPU
> as long as the de-muxing of the "data" portion results in a unique
> identifier that can be mapped to exactly one interrupt handler.

True, on sparc64 PCI-E controllers, for example, the MSI vector is
received by the PCI-E host controller, and the host controller turns
this into a cpu format interrupt packet for the system bus.

I guess on IRQ pin starved systems, the PCI-E host controller or
something similar would get interrogated by the cpu for the MSI vector
number.

I don't want to be the person who has to code up support for
that, as it's not easy to shim mid-level vectoring into the
generic IRQ layer currently.  I'd love to be able to do that
on sparc64 instead of what arch/sparc64/kernel/pci_sun4v.c's
pci_sun4v_msi_prehandler() is doing.

There is a lot of information and vectoring capabilities present
that I'm simply not taking advantage of yet :-)
