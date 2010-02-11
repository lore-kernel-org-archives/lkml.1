Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab0BKSt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 13:49:58 -0500
Received: from mail-yw0-f189.google.com ([209.85.211.189]:41415 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab0BKSt5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 13:49:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vKvtpkSENTkyBt/DCBoA+8RKN0TMXwEhAO8UspkWo1Bvp+Fl+ZfaCHcVaM+mMeqOkz
         ElKf/XBIiAJem4nRg5+uBL79bmHhitzgXduGcEYcWeOViIoqvNW+3gHuM2INRNWu8VA2
         ptkJk1UZGoUH3EMEPikYjlMGnmru9X2oySPjM=
MIME-Version: 1.0
In-Reply-To: <1265765687-14121-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1265765687-14121-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 11 Feb 2010 13:49:55 -0500
Message-ID: <b4198de61002111049xcd506f2yb2f8f30e3d568c78@mail.gmail.com>
Subject: Re: [PATCH v2 -mm 03/14] alpha: use include/linux/pci-dma.h
From: Matt Turner <mattst88@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 9, 2010 at 8:34 PM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Cc: Matt Turner <mattst88@gmail.com>
> ---
>  arch/alpha/Kconfig           |    3 +++
>  arch/alpha/include/asm/pci.h |   14 +-------------
>  2 files changed, 4 insertions(+), 13 deletions(-)
>
> diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
> index bd7261e..759f49d 100644
> --- a/arch/alpha/Kconfig
> +++ b/arch/alpha/Kconfig
> @@ -58,6 +58,9 @@ config ZONE_DMA
>        bool
>        default y
>
> +config NEED_DMA_MAP_STATE
> +       def_bool y
> +
>  config GENERIC_ISA_DMA
>        bool
>        default y
> diff --git a/arch/alpha/include/asm/pci.h b/arch/alpha/include/asm/pci.h
> index dd8dcab..4765946 100644
> --- a/arch/alpha/include/asm/pci.h
> +++ b/arch/alpha/include/asm/pci.h
> @@ -119,19 +119,7 @@ pci_dma_mapping_error(struct pci_dev *pdev, dma_addr_t dma_addr)
>  extern void pci_unmap_single(struct pci_dev *, dma_addr_t, size_t, int);
>  extern void pci_unmap_page(struct pci_dev *, dma_addr_t, size_t, int);
>
> -/* pci_unmap_{single,page} is not a nop, thus... */
> -#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)      \
> -       dma_addr_t ADDR_NAME;
> -#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)                \
> -       __u32 LEN_NAME;
> -#define pci_unmap_addr(PTR, ADDR_NAME)                 \
> -       ((PTR)->ADDR_NAME)
> -#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)                \
> -       (((PTR)->ADDR_NAME) = (VAL))
> -#define pci_unmap_len(PTR, LEN_NAME)                   \
> -       ((PTR)->LEN_NAME)
> -#define pci_unmap_len_set(PTR, LEN_NAME, VAL)          \
> -       (((PTR)->LEN_NAME) = (VAL))
> +#include <linux/pci-dma.h>
>
>  /* Map a set of buffers described by scatterlist in streaming mode for
>    PCI DMA.  This is the scatter-gather version of the above
> --
> 1.5.6.5
>
>

Acked-by: Matt Turner <mattst88@gmail.com>
