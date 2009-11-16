Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbZKPWQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbZKPWQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbZKPWQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:16:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754240AbZKPWQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:16:46 -0500
Date: Mon, 16 Nov 2009 14:14:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: steve@digidescorp.com
Cc: microblaze-uclinux@itee.uq.edu.au, monstr@monstr.eu,
       linux-kernel@vger.kernel.org, Chen Liqin <liqin.chen@sunplusct.com>,
       Lennox Wu <lennox.wu@gmail.com>, David Howells <dhowells@redhat.com>,
       Greg Ungerer <gerg@snapgear.com>
Subject: Re: [PATCH] microblaze: Fix pfn_valid() for noMMU
Message-Id: <20091116141426.9fc63622.akpm@linux-foundation.org>
In-Reply-To: <1258150109-6884-1-git-send-email-steve@digidescorp.com>
References: <1258150109-6884-1-git-send-email-steve@digidescorp.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Nov 2009 16:08:29 -0600
steve@digidescorp.com wrote:

> Configuring DEBUG_SLAB causes a noMMU kernel to die during initialization
> with an invalid virtual address panic in kfree_debugcheck().
> The panic is due to an improper definition of pfn_valid().
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN a/arch/microblaze/include/asm/page.h b/arch/microblaze/include/asm/page.h
> --- a/arch/microblaze/include/asm/page.h	2009-09-09 17:13:59.000000000 -0500
> +++ b/arch/microblaze/include/asm/page.h	2009-11-13 15:20:26.000000000 -0600
> @@ -161,7 +161,8 @@ extern int page_is_ram(unsigned long pfn
>  #  endif /* CONFIG_MMU */
>  
>  #  ifndef CONFIG_MMU
> -#  define pfn_valid(pfn)	((pfn) >= min_low_pfn && (pfn) <= max_mapnr)
> +#  define pfn_valid(pfn)	(((pfn) >= min_low_pfn) && \
> +				((pfn) <= (min_low_pfn + max_mapnr)))
>  #  define ARCH_PFN_OFFSET	(PAGE_OFFSET >> PAGE_SHIFT)
>  #  else /* CONFIG_MMU */
>  #  define ARCH_PFN_OFFSET	(memory_start >> PAGE_SHIFT)

Is arch/score/include/asm/page.h buggy also?


