Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbXHVAgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbXHVAgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 20:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbXHVAfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 20:35:53 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35434 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750820AbXHVAfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 20:35:52 -0400
From: akepner@sgi.com
Date: Tue, 21 Aug 2007 17:34:50 -0700
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Jes Sorensen <jes@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, rdreier@cisco.com,
       linux-ia64 <linux-ia64@vger.kernel.org>
Subject: Re: [PATCH 2/3] dma: override "dma_flags_set_dmaflush" for sn-ia64
Message-ID: <20070822003450.GM5592@sgi.com>
References: <20070818002746.GU1813@sgi.com> <46C94FD5.6000006@sgi.com> <20070821193522.GD5592@sgi.com> <20070821130515.6e745b17.randy.dunlap@oracle.com> <1187729729.18410.48.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187729729.18410.48.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 03:55:29PM -0500, James Bottomley wrote:

> .....
> Almost every platform supports posted DMA ... its a property of most PCI
> bridge chips.
> 

The term "posted DMA" is used to describe this behavior in the Altix 
Device Driver Writer's Guide, but it may be confusing things here. 
Maybe a better term will suggest itself if I can clarify....

On Altix, DMA from a device isn't guaranteed to arrive in host memory 
in the order it was sent from the device. This reordering can happen 
in the NUMA interconnect (it's specifically not a PCI reordering.)

> ......
> This isn't possible on most platforms.  PCI write posting can only be
> flushed by a read transaction on the device (or sometimes any device on
> the bridge).  Either this interface is misnamed and misdescribed, or it
> can't work for most systems.
> 

Clearly it wasn't described adequately...

A read transaction on the device will flush pending writes to the 
device. But I'm worried about DMA from the device to host memory. 
On Altix, there are two mechanisms that flush all in-flight DMA 
to host memory: 1) an interrupt, and 2) a write to a memory region 
which has a "barrier" attribute set. Obviously option 1 isn't 
viable for performance reasons. This new interface is about making 
"option 2" generally available. (As it is now, the only way to get 
memory with the "barrier" attribute is to allocate it with 
dma_alloc_coherent().)

-- 
Arthur

