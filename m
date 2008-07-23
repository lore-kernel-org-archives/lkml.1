Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbYGWWKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbYGWWKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 18:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYGWWKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 18:10:37 -0400
Received: from 8bytes.org ([88.198.83.132]:59951 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbYGWWKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 18:10:36 -0400
Date: Thu, 24 Jul 2008 00:10:33 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
Message-ID: <20080723221033.GD13662@8bytes.org>
References: <20080723111928.15828.42561.sendpatchset@prarit.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723111928.15828.42561.sendpatchset@prarit.bos.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 07:19:43AM -0400, Prarit Bhargava wrote:
> pci_alloc_consistent/dma_alloc_coherent does not return size aligned
> addresses.
> 
> >From Documentation/DMA-mapping.txt:
> 
> "pci_alloc_consistent returns two values: the virtual address which you
> can use to access it from the CPU and dma_handle which you pass to the
> card.
> 
> The cpu return address and the DMA bus master address are both
> guaranteed to be aligned to the smallest PAGE_SIZE order which
> is greater than or equal to the requested size.  This invariant
> exists (for example) to guarantee that if you allocate a chunk
> which is smaller than or equal to 64 kilobytes, the extent of the
> buffer you receive will not cross a 64K boundary."

Interesting. Have you experienced any problems because of that
misbehavior in the GART code? AMD IOMMU currently also violates this
requirement. I will send a patch to fix that there too.

Joerg

