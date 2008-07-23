Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbYGWXPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbYGWXPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 19:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbYGWXPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 19:15:38 -0400
Received: from sh.osrg.net ([192.16.179.4]:52574 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058AbYGWXPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 19:15:37 -0400
Date: Thu, 24 Jul 2008 08:14:47 +0900
To: joro@8bytes.org
Cc: prarit@redhat.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080723221033.GD13662@8bytes.org>
References: <20080723111928.15828.42561.sendpatchset@prarit.bos.redhat.com>
	<20080723221033.GD13662@8bytes.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080724081528F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008 00:10:33 +0200
Joerg Roedel <joro@8bytes.org> wrote:

> On Wed, Jul 23, 2008 at 07:19:43AM -0400, Prarit Bhargava wrote:
> > pci_alloc_consistent/dma_alloc_coherent does not return size aligned
> > addresses.
> > 
> > >From Documentation/DMA-mapping.txt:
> > 
> > "pci_alloc_consistent returns two values: the virtual address which you
> > can use to access it from the CPU and dma_handle which you pass to the
> > card.
> > 
> > The cpu return address and the DMA bus master address are both
> > guaranteed to be aligned to the smallest PAGE_SIZE order which
> > is greater than or equal to the requested size.  This invariant
> > exists (for example) to guarantee that if you allocate a chunk
> > which is smaller than or equal to 64 kilobytes, the extent of the
> > buffer you receive will not cross a 64K boundary."
> 
> Interesting. Have you experienced any problems because of that
> misbehavior in the GART code? AMD IOMMU currently also violates this
> requirement. I will send a patch to fix that there too.

IIRC, only PARISC and POWER IOMMUs follow the above rule. So I also
wondered what problem he hit.
