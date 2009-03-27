Return-Path: <linux-kernel-owner+w=401wt.eu-S1757673AbZC0Snd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbZC0Snd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 14:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbZC0SnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 14:43:23 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:38543 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZC0SnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 14:43:22 -0400
Date: Fri, 27 Mar 2009 19:45:22 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: liqin.chen@sunplusct.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 6/13] score - New architecure port to SunplusCT S+CORE processor
Message-ID: <20090327184522.GC21149@uranus.ravnborg.org>
References: <OF48378D81.6667BB0D-ON48257586.0008F474-48257586.00093CBC@sunplusct.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF48378D81.6667BB0D-ON48257586.0008F474-48257586.00093CBC@sunplusct.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> linux-2.6-git.ori/arch/score/include/asm/types.h 
> linux-2.6-git.new/arch/score/include/asm/types.h
> --- linux-2.6-git.ori/arch/score/include/asm/types.h    1970-01-01 
> 08:00:00.000000000 +0800
> +++ linux-2.6-git.new/arch/score/include/asm/types.h    2009-03-23 
> 15:03:24.000000000 +0800
> @@ -0,0 +1,24 @@
> +#ifndef _ASM_TYPES_H
> +#define _ASM_TYPES_H
> +
> +#include <asm-generic/int-ll64.h>
> +
> +#ifndef __ASSEMBLY__
> +typedef unsigned short umode_t;
> +#endif /* __ASSEMBLY__ */
> +
> +#ifdef __KERNEL__
> +#define BITS_PER_LONG  32
> +#ifndef __ASSEMBLY__
> +
> +typedef u32 dma_addr_t;
> +typedef u64 dma64_addr_t;
> +
> +/*
> + * Don't use phys_t. You've been warned.
> + */
> +typedef unsigned long phys_t;

If you do not use it drop it from this file.

> diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
> linux-2.6-git.ori/arch/score/include/asm/unaligned.h 
> linux-2.6-git.new/arch/score/include/asm/unaligned.h
> --- linux-2.6-git.ori/arch/score/include/asm/unaligned.h        1970-01-01 
> 08:00:00.000000000 +0800
> +++ linux-2.6-git.new/arch/score/include/asm/unaligned.h        2009-03-23 
> 15:07:26.000000000 +0800
> @@ -0,0 +1,21 @@
> +#ifndef _ASM_SCORE_UNALIGNED_H
> +#define _ASM_SCORE_UNALIGNED_H
> +
> +#include <linux/compiler.h>
> +#if defined(__SCOREEB__)
> +# include <linux/unaligned/be_struct.h>
> +# include <linux/unaligned/le_byteshift.h>
> +# include <linux/unaligned/generic.h>
> +# define get_unaligned __get_unaligned_be
> +# define put_unaligned __put_unaligned_be
> +#elif defined(__SCOREEL__)
> +# include <linux/unaligned/le_struct.h>
> +# include <linux/unaligned/be_byteshift.h>
> +# include <linux/unaligned/generic.h>
> +# define get_unaligned __get_unaligned_le
> +# define put_unaligned __put_unaligned_le
> +#else
> +# error "SCORE, but neither __SCOREEB__, nor __SCOREEL__???"
> +#endif

Where does __SCOREEB__ and __SCOREEL__ comes from?
Can we use a CONFIG_ symbol here?

The header is not exported so it is OK to use CONFIG_ and
if we can puch the definition to Kconfig time then this is preferred.

	Sam
