Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYHLQtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYHLQtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 12:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYHLQtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 12:49:17 -0400
Received: from 8bytes.org ([88.198.83.132]:46723 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbYHLQtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 12:49:17 -0400
Date: Tue, 12 Aug 2008 18:49:14 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, mingo@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, andi@firstfloor.org
Subject: Re: [PATCH 0/7] x86 dma_*_coherent rework patchset
Message-ID: <20080812164914.GC4342@8bytes.org>
References: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com> <20080812160658.GH30426@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080812160658.GH30426@il.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 07:06:58PM +0300, Muli Ben-Yehuda wrote:
> [added Andi to CC]
> 
> On Tue, Aug 12, 2008 at 05:24:10PM +0200, Joerg Roedel wrote:
> > Hi,
> > 
> > this patchset reworks the dma_*_coherent functions in the DMA layer
> > for the x86 architecture. The patch series extends the existing DMA
> > backends with missing *coherent callbacks and simplifies the generic
> > function to basically only call the registered backend. This allows
> > future optimizations in hardware specific IOMMU implementations.
> > The code ist tested on AMD64 with AMD IOMMU and GART as well as on
> > my old 486 box. It is not yet tested on a Calgary IOMMU system.
> 
> Now it is---appears to work fine on a Calgary system.
> 
> In general the patchset looks good and is definitely a step in the
> right direction. I am a bit concerned about the contortions that the
> generic dma_alloc_coherent went through before calling the ops
> version---have you verified they are no longer needed?

Most of the logic in the old dma_alloc_coherent function is moved to the
specific IOMMU implementations now. The old function tried to handle all
cases, hardware IOMMU, GART and NOMMU in one function which made it a
bit hard to read. This logic is split up and moved to the specific DMA
backends now.

Joerg

