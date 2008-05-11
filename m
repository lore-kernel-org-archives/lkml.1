Return-Path: <linux-kernel-owner+w=401wt.eu-S1756594AbYEKAkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbYEKAkj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 20:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750744AbYEKAkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 20:40:33 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:53852 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbYEKAkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 20:40:32 -0400
Date: Sun, 11 May 2008 02:41:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, gerg@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68knommu: missing sections for linker script
Message-ID: <20080511004107.GA2675@uranus.ravnborg.org>
References: <200805070052.m470qdod017612@goober>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805070052.m470qdod017612@goober>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 10:52:39AM +1000, Greg Ungerer wrote:
> Inlucde the missing kcrctab and kcrctab_unused sections into the
> m68knommu linker script.
> 
> Signed-off-by: Greg Ungerer <gerg@uclinux.org>
> ---
> 
> diff -Naurp linux-2.6.25-rc1/arch/m68knommu/kernel/vmlinux.lds.S linux-2.6.25-rc1-uc0/arch/m68knommu/kernel/vmlinux.lds.S
> --- linux-2.6.25-rc1/arch/m68knommu/kernel/vmlinux.lds.S	2008-05-06 14:52:00.000000000 +1000
> +++ linux-2.6.25-rc1-uc0/arch/m68knommu/kernel/vmlinux.lds.S	2008-05-06 16:56:47.000000000 +1000
> @@ -114,6 +114,16 @@ SECTIONS {
>  		*(__kcrctab_gpl)
>  		__stop___kcrctab_gpl = .;
>  
> +		/* Kernel symbol table: Normal unused symbols */
> +		__start___kcrctab_unused = .;
> +		*(__kcrctab_unused)
> +		__stop___kcrctab_unused = .;
> +
> +		/* Kernel symbol table: GPL-only unused symbols */
> +		__start___kcrctab_unused_gpl = .;
> +		*(__kcrctab_unused_gpl)
> +		__stop___kcrctab_unused_gpl = .;
> +
>  		/* Kernel symbol table: GPL-future symbols */
>  		__start___kcrctab_gpl_future = .;
>  		*(__kcrctab_gpl_future)

Hi Greg.

Any specific reasons why m68knommu does
not use include/asm-generic/vmlinux-lds.h?

There are defined there as well as many other common things.

	Sam
