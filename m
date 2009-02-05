Return-Path: <linux-kernel-owner+w=401wt.eu-S1761848AbZBEU0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761848AbZBEU0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbZBEU0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:26:41 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:53761 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbZBEU0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:26:40 -0500
Date: Thu, 5 Feb 2009 20:25:48 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 36 of 36] x86: make the X_bad functions consistent
In-Reply-To: <d0b8ae3ef338132ad60d.1233862278@abulafia.goop.org>
Message-ID: <Pine.LNX.4.64.0902052024470.13998@blonde.anvils>
References: <patchbomb.1233862242@abulafia.goop.org>
 <d0b8ae3ef338132ad60d.1233862278@abulafia.goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009, Jeremy Fitzhardinge wrote:

> Impact: cleanup
> 
> Use the same logic to implement all 3 _bad() functions.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

A backward step in my opinion.

Hugh

> ---
>  arch/x86/include/asm/pgtable.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -554,7 +554,7 @@
>  
>  static inline int pmd_bad(pmd_t pmd)
>  {
> -	return (pmd_flags(pmd) & ~_PAGE_USER) != _KERNPG_TABLE;
> +	return (pmd_flags(pmd) & ~(_KERNPG_TABLE | _PAGE_USER)) != 0;
>  }
>  
>  static inline unsigned long pages_to_mb(unsigned long npg)
> @@ -638,7 +638,7 @@
>  
>  static inline int pgd_bad(pgd_t pgd)
>  {
> -	return (pgd_flags(pgd) & ~_PAGE_USER) != _KERNPG_TABLE;
> +	return (pgd_flags(pgd) & ~(_KERNPG_TABLE | _PAGE_USER)) != 0;
>  }
>  
>  static inline int pgd_none(pgd_t pgd)
