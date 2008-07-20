Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbYGTTsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbYGTTsx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 15:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbYGTTso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 15:48:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:47678 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbYGTTso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 15:48:44 -0400
Date: Sun, 20 Jul 2008 12:48:41 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: dma_alloc_coherent() on PPC32: physical addresses above 2G
 possible?
Message-ID: <20080720124841.0e5e8de0@infradead.org>
In-Reply-To: <4883913F.9040706@s5r6.in-berlin.de>
References: <488385A7.4010509@s5r6.in-berlin.de>
	<20080720114358.6c88e048@infradead.org>
	<4883913F.9040706@s5r6.in-berlin.de>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jul 2008 21:25:51 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Arjan van de Ven wrote:
> > On Sun, 20 Jul 2008 20:36:23 +0200
> > Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> > 
> >> PS:  I don't want to set the DMA mask of this device to
> >> DMA_31BIT_MASK because that would be detrimental to other functions
> >> of the device. It's a TI TSB43AB22A FireWire controller.
> > 
> > Hi,
> > 
> > just want to mention that you can set the coherent mask separately
> > from the generic mask... is that sufficient for your load?
> > (you can even set it just for this allocation..)
> 
> Hmm.  Would that be done this way?
> During probe:
> 
> 	if (chip_is_tsb43ab22a) {
> 		if (dma_supported(dev, DMA_31BIT_MASK))
> 			chip->needs_dma_mask_workaround = 1;
> 		else
> 			chip->needs_some_other_workaround = 1;
> 	}

btw it might be nicer to make this

chip->something_special_mask = DMA_31BIT_MASK;

then you can just use the mask from this struct rather than another
check


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
