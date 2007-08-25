Return-Path: <linux-kernel-owner+w=401wt.eu-S932734AbXHYAUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734AbXHYAUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 20:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756911AbXHYAUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 20:20:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55699 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247AbXHYAUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 20:20:43 -0400
Date: Fri, 24 Aug 2007 17:20:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH] include linux/pagemap.h in asm-generic/tlb.h
Message-Id: <20070824172027.0ad5d2c0.akpm@linux-foundation.org>
In-Reply-To: <20070824184616.GA9442@c2.user-mode-linux.org>
References: <20070824184616.GA9442@c2.user-mode-linux.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 14:46:16 -0400
Jeff Dike <jdike@addtoit.com> wrote:

> [ This looks non-urgent to me ]
> 
> Without linux/pagemap.h, asm-generic/tlb.h is missing declarations of
> page_cache_release and release_pages.
> 
> Signed-off-by: Jeff Dike <jdike@linux.intel.com>
> --
>  include/asm-generic/tlb.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6.22/include/asm-generic/tlb.h
> ===================================================================
> --- linux-2.6.22.orig/include/asm-generic/tlb.h	2007-07-08 19:32:17.000000000 -0400
> +++ linux-2.6.22/include/asm-generic/tlb.h	2007-08-22 17:29:45.000000000 -0400
> @@ -13,6 +13,7 @@
>  #ifndef _ASM_GENERIC__TLB_H
>  #define _ASM_GENERIC__TLB_H
>  
> +#include <linux/pagemap.h>
>  #include <linux/swap.h>
>  #include <asm/pgalloc.h>
>  #include <asm/tlbflush.h>

This is worrisome.  If you look at pagemap.h, it includes a pile of things
which could easily themsleves try to include tlb.h via some path or
another.  I fear that this patch will cause explosions with some config
and/or architecture.

If you like, tlb.h is a low-level sort of thing whereas pagemap.h is a
higher-level VFS thing.  It is more appropriate that pagemap.h be including
tlb.h.


So I think a better fix would be better, but I'm not able to suggest what,
as there is little detail about the failure here and I can find no mention
of page_cache_release and release_pages in asm-generic/tlb.h.  Presumably
they're getting pulled in via some macro and then instantiated in some
inline function or something?


