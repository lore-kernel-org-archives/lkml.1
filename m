Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbXHWF7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbXHWF7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 01:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbXHWF7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 01:59:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49884 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752186AbXHWF67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 01:58:59 -0400
Date: Wed, 22 Aug 2007 22:58:56 -0700
From: Jeremy Higdon <jeremy@sgi.com>
To: Jes Sorensen <jes@sgi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, akepner@sgi.com,
       Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, rdreier@cisco.com,
       linux-ia64 <linux-ia64@vger.kernel.org>
Subject: Re: [PATCH 2/3] dma: override "dma_flags_set_dmaflush" for sn-ia64
Message-ID: <20070823055856.GN89849@sgi.com>
References: <20070818002746.GU1813@sgi.com> <46C94FD5.6000006@sgi.com> <20070821193522.GD5592@sgi.com> <20070821130515.6e745b17.randy.dunlap@oracle.com> <1187729729.18410.48.camel@localhost.localdomain> <20070822003450.GM5592@sgi.com> <1187745249.18410.67.camel@localhost.localdomain> <46CBE838.4000302@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CBE838.4000302@sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 09:39:36AM +0200, Jes Sorensen wrote:
> James Bottomley wrote:
> >On Tue, 2007-08-21 at 17:34 -0700, akepner@sgi.com wrote:
> >>The term "posted DMA" is used to describe this behavior in the Altix 
> >>Device Driver Writer's Guide, but it may be confusing things here. 
> >>Maybe a better term will suggest itself if I can clarify....
> >
> >OK, but posted DMA has a pretty specific meaning in terms of PCI, hence
> >the confusion.
> 
> Maybe it would be more better to refer to this as 'out of order DMA'?
> 
> >>On Altix, DMA from a device isn't guaranteed to arrive in host memory 
> >>in the order it was sent from the device. This reordering can happen 
> >>in the NUMA interconnect (it's specifically not a PCI reordering.)
> >
> >This is mmiowb and read_relaxed() again, isn't it?
> 
> I believe it's the same problem, except this time it's when exposing
> structures to userland.

Actually, it's a different problem, but with a similar cause.

mmiowb() is for the case PIO (or MMIO) write order from two different CPUs
can invert somewhere in the NL fabric.

read_relaxed() is a performance optimization to avoid the flush that's
necessary to avoid inversion in order between a PIO (or MMIO) read and
a DMA write.

What Arthur's trying to do here is avoid inversion in the order of two
DMA writes.

jeremy
