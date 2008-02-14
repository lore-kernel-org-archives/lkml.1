Return-Path: <linux-kernel-owner+w=401wt.eu-S1761358AbYBNFOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761358AbYBNFOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 00:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbYBNFOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 00:14:09 -0500
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:60618 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbYBNFOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 00:14:07 -0500
Date: Thu, 14 Feb 2008 00:14:04 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: rubisher <rubi.sher@scarlet.be>
Cc: kyle <kyle@mcmartin.ca>, clameter <clameter@sgi.com>,
       bunk <bunk@kernel.org>, kyle <kyle@parisc-linux.org>,
       matthew <matthew@wil.cx>, grundler <grundler@parisc-linux.org>,
       linux-parisc <linux-parisc@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       rubisher <rubisher@scarlet.be>
Subject: Re: parisc compile error
Message-ID: <20080214051404.GA29980@phobos.i.cabal.ca>
References: <JW60A0$CF80A6CA85E28806A3D1EDDACE158868@scarlet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <JW60A0$CF80A6CA85E28806A3D1EDDACE158868@scarlet.be>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 07:49:12AM +0100, rubisher wrote:
> --- include/asm-parisc/pgtable.h.Orig	2007-10-22 08:19:20.000000000 +0000
> +++ include/asm-parisc/pgtable.h	2008-02-12 16:28:36.000000000 +0000
> +extern  void *vmalloc_start;
> +#define PCXL_DMA_MAP_SIZE   (8*1024*1024)
> +#define VMALLOC_START   ((unsigned long)vmalloc_start)
> +/* this is a fixmap remnant, see fixmap.h */
> +#define VMALLOC_END	(KERNEL_MAP_END)
> +

i moved this to fixmap.h, since i think it makes more sense there,
really.

> static inline void pte_free_kernel(struct mm_struct *mm, struct page *pte)
> {
>         pgtable_page_dtor(pte);
>         pte_free_kernel(page_address((pte));
> }
> 

this is a stunning bit of ignorant patching courtesy of
2f569afd9ced9ebec9a6eb3dbf6f83429be0a7b4 which:

-#define pte_free(mm, page) pte_free_kernel(page_address(page))
+static inline void pte_free_kernel(struct mm_struct *mm, struct page
*pte)
+{
+       pgtable_page_dtor(pte);
+       pte_free_kernel(page_address((pte));
+}

only wrong on *two* counts.

anyway, fixed this up. sigh.
