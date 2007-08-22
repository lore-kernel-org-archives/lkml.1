Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbXHVBO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbXHVBO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 21:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbXHVBOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 21:14:17 -0400
Received: from accolon.hansenpartnership.com ([64.109.89.108]:40174 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752315AbXHVBOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 21:14:16 -0400
Subject: Re: [PATCH 2/3] dma: override "dma_flags_set_dmaflush" for sn-ia64
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: akepner@sgi.com
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Jes Sorensen <jes@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, rdreier@cisco.com,
       linux-ia64 <linux-ia64@vger.kernel.org>
In-Reply-To: <20070822003450.GM5592@sgi.com>
References: <20070818002746.GU1813@sgi.com> <46C94FD5.6000006@sgi.com>
	 <20070821193522.GD5592@sgi.com>
	 <20070821130515.6e745b17.randy.dunlap@oracle.com>
	 <1187729729.18410.48.camel@localhost.localdomain>
	 <20070822003450.GM5592@sgi.com>
Content-Type: text/plain
Date: Tue, 21 Aug 2007 20:14:09 -0500
Message-Id: <1187745249.18410.67.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-21 at 17:34 -0700, akepner@sgi.com wrote:
> On Tue, Aug 21, 2007 at 03:55:29PM -0500, James Bottomley wrote:
> 
> > .....
> > Almost every platform supports posted DMA ... its a property of most PCI
> > bridge chips.
> > 
> 
> The term "posted DMA" is used to describe this behavior in the Altix 
> Device Driver Writer's Guide, but it may be confusing things here. 
> Maybe a better term will suggest itself if I can clarify....

OK, but posted DMA has a pretty specific meaning in terms of PCI, hence
the confusion.

> On Altix, DMA from a device isn't guaranteed to arrive in host memory 
> in the order it was sent from the device. This reordering can happen 
> in the NUMA interconnect (it's specifically not a PCI reordering.)

This is mmiowb and read_relaxed() again, isn't it?

> > ......
> > This isn't possible on most platforms.  PCI write posting can only be
> > flushed by a read transaction on the device (or sometimes any device on
> > the bridge).  Either this interface is misnamed and misdescribed, or it
> > can't work for most systems.
> > 
> 
> Clearly it wasn't described adequately...
> 
> A read transaction on the device will flush pending writes to the 
> device. But I'm worried about DMA from the device to host memory. 
> On Altix, there are two mechanisms that flush all in-flight DMA 
> to host memory: 1) an interrupt, and 2) a write to a memory region 
> which has a "barrier" attribute set. Obviously option 1 isn't 
> viable for performance reasons. This new interface is about making 
> "option 2" generally available. (As it is now, the only way to get 
> memory with the "barrier" attribute is to allocate it with 
> dma_alloc_coherent().)

Which sounds exactly what mmiowb does ... is there a need for a new API;
can't you just use mmiowb()?

James


