Return-Path: <linux-kernel-owner+w=401wt.eu-S1761935AbYARNym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761935AbYARNym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761695AbYARNy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:54:27 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:52839 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761684AbYARNy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:54:26 -0500
Date: Fri, 18 Jan 2008 13:52:33 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 4 of 4] x86: mask NX from pte_pfn
In-Reply-To: <b27ec2092a01dc15e139.1200435429@localhost>
Message-ID: <Pine.LNX.4.64.0801181350090.27929@blonde.site>
References: <b27ec2092a01dc15e139.1200435429@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008, Jeremy Fitzhardinge wrote:
> In 32-bit PAE, mask NX from pte_pfn, since it isn't part of the PFN.
> This code is due for unification anyway, but this fixes a latent bug.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> 
> ---
>  include/asm-x86/pgtable-3level.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/asm-x86/pgtable-3level.h b/include/asm-x86/pgtable-3level.h
> --- a/include/asm-x86/pgtable-3level.h
> +++ b/include/asm-x86/pgtable-3level.h
> @@ -139,7 +139,7 @@ static inline int pte_none(pte_t pte)
>  
>  static inline unsigned long pte_pfn(pte_t pte)
>  {
> -	return pte_val(pte) >> PAGE_SHIFT;
> +	return (pte_val(pte) >> PAGE_SHIFT) & ~_PAGE_NX;
>  }
>  
>  /*

Shouldn't that be

	return (pte_val(pte) & ~_PAGE_NX) >> PAGE_SHIFT;

? Hugh
