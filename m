Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbYICSGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbYICSGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYICSGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:06:38 -0400
Received: from sh.osrg.net ([192.16.179.4]:33235 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbYICSGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:06:37 -0400
Date: Thu, 4 Sep 2008 03:05:21 +0900
To: joerg.roedel@amd.com
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, tony.luck@intel.com
Subject: Re: [PATCH] swiotlb: fix dma_alloc_coherent allocation failures
 with swiotlb
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1220454224-25985-1-git-send-email-joerg.roedel@amd.com>
References: <1220454224-25985-1-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080904024842J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008 17:03:44 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> The SWIOTLB version of dma_alloc_coherent allocates all memory with
> GFP_DMA unconditionally. This leads sometimes unnecessary to allocation
> failures. This patch makes the allocation strategy to use the DMA32 zone
> first if this is possible. The changes are boot tested on AMD64 and
> compile tested for i386 and IA64.
> 
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: tony.luck@intel.com
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  lib/swiotlb.c |   23 +++++++++++++++++------
>  1 files changed, 17 insertions(+), 6 deletions(-)

This doesn't look correct since IA64 doesn't need this flag hack.

Another problem about this patch is that swiotlb doesn't use GFP_DMA
for the fallback_dev.

I'll send patches to fix this problem differently.
