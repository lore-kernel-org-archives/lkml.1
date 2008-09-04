Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440AbYIDEN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbYIDEN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 00:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYIDENA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 00:13:00 -0400
Received: from sh.osrg.net ([192.16.179.4]:53981 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbYIDEM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 00:12:59 -0400
Date: Thu, 4 Sep 2008 13:11:47 +0900
To: andi@firstfloor.org
Cc: joerg.roedel@amd.com, mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, tony.luck@intel.com
Subject: Re: [PATCH] swiotlb: fix dma_alloc_coherent allocation failures
 with swiotlb
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <877i9sx4nk.fsf@basil.nowhere.org>
References: <1220454224-25985-1-git-send-email-joerg.roedel@amd.com>
	<877i9sx4nk.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080904131130E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep 2008 00:09:51 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Joerg Roedel <joerg.roedel@amd.com> writes:
> 
> > The SWIOTLB version of dma_alloc_coherent allocates all memory with
> > GFP_DMA unconditionally. This leads sometimes unnecessary to allocation
> > failures. This patch makes the allocation strategy to use the DMA32 zone
> > first if this is possible. The changes are boot tested on AMD64 and
> > compile tested for i386 and IA64.
> 
> The high level dma_alloc_coherent() does that anyways.

The high level dma_alloc_coherent means the tricks in
arch/x86/pci-dma.c? If so, all the tricks has gone in tip/master.


> The swiotlb fallback really should only allocate from the swiotlb,
> nowhere else.

Agreed.

