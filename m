Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab0CBMDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 07:03:41 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52646 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab0CBMDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 07:03:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] sparc: use asm-generic/scatterlist.h
Date: Tue, 2 Mar 2010 13:03:25 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: davem@davemloft.net, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20100226.043536.63730567.davem@davemloft.net> <201003011229.51399.arnd@arndb.de> <20100302123326H.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100302123326H.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003021303.26064.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19anwVp4ATiycq1nb2KLacGDZRDYO8OAibuPsI
 lZy306Rt6VDUp/FXkweSpp+7J1DpHql32NIuM/MobcGbMsS8JM
 Wyj9aZNQ7wsGFU0deeCKQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 March 2010, FUJITA Tomonori wrote:
> If we go with such approach, then we could use something like the
> following. There are only two kinds of scatterlist definitions (use
> dma_length or not) so we can cover all the architectures.
> 
> diff --git a/include/asm-generic/scatterlist.h b/include/asm-generic/scatterlist.h
> index 8b94544..1bf620d 100644
> --- a/include/asm-generic/scatterlist.h
> +++ b/include/asm-generic/scatterlist.h
> @@ -11,7 +11,9 @@ struct scatterlist {
>         unsigned int    offset;
>         unsigned int    length;
>         dma_addr_t      dma_address;
> +#ifdef CONFIG_NEED_SG_DMA_LENGTH
>         unsigned int    dma_length;
> +#endif
>  };

Yes, that sounds good. If the only reason to need dma_length is virtual merging,
a clearer (from the Kconfig perspective, not from the implementation) name 
might be CONFIG_HAVE_IOMMU_VMERGE, similar to the CONFIG_IOMMU_VMERGE option
on PPC64 that determines the default for the virtual merging runtime option.

	Arnd
