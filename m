Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbZEARq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbZEARq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZEARqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:46:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48783 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbZEARqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:46:17 -0400
Date: Fri, 1 May 2009 13:46:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 34/35] powerpc use generic ptemap.h
Message-ID: <20090501174617.GB8104@infradead.org>
References: <20090501144201.D31EF417@kernel> <20090501144254.52127677@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501144254.52127677@kernel>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 07:42:54AM -0700, Dave Hansen wrote:
> 
> powerpc is a bid of an oddball here.  It seems to have CONFIG_HIGHPTE
> behavior at all times when compiled as 32-bit.  There's even an
> #ifdef CONFIG_HIGHPTE in arch/powerpc/mm/pgtable_32.c, but there's no
> trace of HIGHPTE in Kconfig anywhere.
> 
> This gives ppc32 an explicit HIGHPTE in Kconfig so that we can use
> the #ifdef in asm-generic/ptemap.h and let ppc use the generic code
> with x86 and frv.

But if you enabled HIGHPTE you need to remove that ifdef in pgtable_32.c
because it didn't get triggered before.

>  #define _POWERPC_ASM_PTEMAP_H
>  
>  #ifndef __powerpc64__
> +/*
> + * This lets us use the x86 implementation
> + * in the generic ptemap.h
> + */
> +#define kmap_atomic_pte(page, type) kmap_atomic(page, type)
> +#endif

That comment doesn't make any sense to me, x86 should have nothing to do
with it.  Also the comment would comfortably fit into a single line
instead of two.

