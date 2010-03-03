Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab0CCQXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:23:21 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:34775 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751502Ab0CCQXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:23:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=c3hTT80s5Chbd2h1F3ksrflBzl8/l/68fih+KBJNh1WT9/Klh+n5Giki+KNEH6MH2VPLQBy5hNmQCsWgPpuPzwuh6OS20ufFQ2sNsjqPLsWYDczM0eYBuGsW/unOVPe7;
Date: Wed, 3 Mar 2010 08:23:15 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 7/7] pci: move pci_set_dma_mask and
 pci_set_consistent_dma_mask to pci-dma-compat.h
Message-ID: <20100303082315.64c57c0b@jbarnes-piketon>
In-Reply-To: <20100303115805Q.fujita.tomonori@lab.ntt.co.jp>
References: <1265967212-9126-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1265967212-9126-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20100302182927.0099eb68.akpm@linux-foundation.org>
	<20100303115805Q.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010 11:58:31 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Tue, 2 Mar 2010 18:29:27 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 12 Feb 2010 18:33:32 +0900 FUJITA Tomonori
> > <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> > > We can use pci-dma-compat.h to implement pci_set_dma_mask and
> > > pci_set_consistent_dma_mask as we do with the other PCI DMA API.
> > > 
> > > We can remove HAVE_ARCH_PCI_SET_DMA_MASK too.
> > 
> > i386 allnoconfig:
> 
> Sorry about that.
> 
> > include/asm-generic/pci-dma-compat.h:105: error: redefinition of
> > 'pci_set_dma_mask' include/linux/pci.h:1092: error: previous
> > definition of 'pci_set_dma_mask' was here
> > include/asm-generic/pci-dma-compat.h:110: error: redefinition of
> > 'pci_set_consistent_dma_mask' include/linux/pci.h:1097: error:
> > previous definition of 'pci_set_consistent_dma_mask' was here
> > 
> > In fact the whole of include/asm-generic/pci-dma-compat.h seems a
> > bit fishy when CONFIG_PCI=n.  Shouldn't all those functions be
> > EIO-returning stubs?
> 
> Might be (and it should work). However, when CONFIG_PCI=n, we has
> silently converted the PCI DMA API to the generic DMA API.
> 
> In the long term, we remove the pci_dma_* API.
> 
> Can you fold this into the above patch?
> 
> diff --git a/include/asm-generic/pci-dma-compat.h
> b/include/asm-generic/pci-dma-compat.h index ddfa9c5..1437b7d 100644
> --- a/include/asm-generic/pci-dma-compat.h
> +++ b/include/asm-generic/pci-dma-compat.h
> @@ -101,6 +101,7 @@ pci_dma_mapping_error(struct pci_dev *pdev,
> dma_addr_t dma_addr) return dma_mapping_error(&pdev->dev, dma_addr);
>  }
>  
> +#ifdef CONFIG_PCI
>  static inline int pci_set_dma_mask(struct pci_dev *dev, u64 mask)
>  {
>  	return dma_set_mask(&dev->dev, mask);
> @@ -110,5 +111,6 @@ static inline int
> pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask) {
>  	return dma_set_coherent_mask(&dev->dev, mask);
>  }
> +#endif
>  
>  #endif

Oops, I missed these in my last round of applications because they
weren't in PCI patchwork; can you cc linux-pci@vger.kernel.org in the
future so the patchwork bot picks them up?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
