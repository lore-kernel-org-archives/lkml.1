Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbYGTT0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbYGTT0i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 15:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbYGTT0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 15:26:30 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:40444 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbYGTT03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 15:26:29 -0400
Message-ID: <4883913F.9040706@s5r6.in-berlin.de>
Date: Sun, 20 Jul 2008 21:25:51 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: dma_alloc_coherent() on PPC32: physical addresses above 2G possible?
References: <488385A7.4010509@s5r6.in-berlin.de> <20080720114358.6c88e048@infradead.org>
In-Reply-To: <20080720114358.6c88e048@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sun, 20 Jul 2008 20:36:23 +0200
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> 
>> PS:  I don't want to set the DMA mask of this device to
>> DMA_31BIT_MASK because that would be detrimental to other functions
>> of the device. It's a TI TSB43AB22A FireWire controller.
> 
> Hi,
> 
> just want to mention that you can set the coherent mask separately from
> the generic mask... is that sufficient for your load?
> (you can even set it just for this allocation..)

Hmm.  Would that be done this way?
During probe:

	if (chip_is_tsb43ab22a) {
		if (dma_supported(dev, DMA_31BIT_MASK))
			chip->needs_dma_mask_workaround = 1;
		else
			chip->needs_some_other_workaround = 1;
	}

Later on:

	if (dev->needs_dma_mask_workaround)
		pci_set_consistent_dma_mask(pdev, DMA_31BIT_MASK);
	allocate_something_special;
	if (dev->needs_dma_mask_workaround)
		pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);

Or is there a variant of dma_alloc_coherent() which directly accepts a
mask argument?
-- 
Stefan Richter
-=====-==--- -=== =-=--
http://arcgraph.de/sr/
