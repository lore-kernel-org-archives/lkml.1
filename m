Return-Path: <linux-kernel-owner+w=401wt.eu-S1762176AbXHVOCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762176AbXHVOCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 10:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758667AbXHVOCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 10:02:44 -0400
Received: from accolon.hansenpartnership.com ([64.109.89.108]:42610 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978AbXHVOCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 10:02:43 -0400
Subject: Re: [PATCH 2/3] dma: override "dma_flags_set_dmaflush" for sn-ia64
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jes Sorensen <jes@sgi.com>
Cc: akepner@sgi.com, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, rdreier@cisco.com,
       linux-ia64 <linux-ia64@vger.kernel.org>
In-Reply-To: <46CBE838.4000302@sgi.com>
References: <20070818002746.GU1813@sgi.com> <46C94FD5.6000006@sgi.com>
	 <20070821193522.GD5592@sgi.com>
	 <20070821130515.6e745b17.randy.dunlap@oracle.com>
	 <1187729729.18410.48.camel@localhost.localdomain>
	 <20070822003450.GM5592@sgi.com>
	 <1187745249.18410.67.camel@localhost.localdomain>
	 <46CBE838.4000302@sgi.com>
Content-Type: text/plain
Date: Wed, 22 Aug 2007 09:02:38 -0500
Message-Id: <1187791358.3410.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-22 at 09:39 +0200, Jes Sorensen wrote:
> James Bottomley wrote:
> > On Tue, 2007-08-21 at 17:34 -0700, akepner@sgi.com wrote:
> >> The term "posted DMA" is used to describe this behavior in the Altix 
> >> Device Driver Writer's Guide, but it may be confusing things here. 
> >> Maybe a better term will suggest itself if I can clarify....
> > 
> > OK, but posted DMA has a pretty specific meaning in terms of PCI, hence
> > the confusion.
> 
> Maybe it would be more better to refer to this as 'out of order DMA'?

Or Relaxed ordering DMA ... that's why the readX_relaxed()?

> >> On Altix, DMA from a device isn't guaranteed to arrive in host memory 
> >> in the order it was sent from the device. This reordering can happen 
> >> in the NUMA interconnect (it's specifically not a PCI reordering.)
> > 
> > This is mmiowb and read_relaxed() again, isn't it?
> 
> I believe it's the same problem, except this time it's when exposing
> structures to userland.

Hmm, so how does another kernel API exposing mmiowb in a different way
help with this?  Surely, if the driver is exporting something to user
space, it's simply up to the driver to call mmiowb when the user says
it's done?

James


