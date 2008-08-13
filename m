Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbYHMArt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbYHMArt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbYHMAq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:46:57 -0400
Received: from sh.osrg.net ([192.16.179.4]:50974 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381AbYHMAq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:46:56 -0400
Date: Wed, 13 Aug 2008 09:45:51 +0900
To: joerg.roedel@amd.com
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com
Subject: Re: [PATCH 6/7] x86: cleanup dma_*_coherent functions
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1218554657-16070-7-git-send-email-joerg.roedel@amd.com>
References: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com>
	<1218554657-16070-7-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080813093727Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 17:24:16 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> All dma_ops implementations support the alloc_coherent and free_coherent
> callbacks now. This allows a big simplification of the dma_alloc_coherent
> function which is done with this patch. The dma_free_coherent functions is also
> cleaned up and calls now the free_coherent callback of the dma_ops
> implementation.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kernel/pci-dma.c |  116 ++++-----------------------------------------
>  1 files changed, 10 insertions(+), 106 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index f704cb5..60fa80d 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c

How about moving dma_free_coherent and dma_alloc_coherent to
asm-x86/dma-mapping.h? It would be nice to have all the dma operations
in one place.
