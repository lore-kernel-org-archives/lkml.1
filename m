Return-Path: <linux-kernel-owner+w=401wt.eu-S1765544AbYAaQCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765544AbYAaQCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbYAaQCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:02:41 -0500
Received: from www.tglx.de ([62.245.132.106]:34884 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbYAaQCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:02:40 -0500
Date: Thu, 31 Jan 2008 17:02:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [6/9] GBPAGES: Add gbpages support to lookup_address
In-Reply-To: <20080129050634.B1B811B416E@basil.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0801311659490.9204@apollo.tec.linutronix.de>
References: <20080129606.610336873@suse.de> <20080129050634.B1B811B416E@basil.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008, Andi Kleen wrote:

> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86/mm/pageattr.c    |    5 +++++
>  include/asm-x86/pgtable.h |    1 +
>  2 files changed, 6 insertions(+)
> 
> Index: linux/arch/x86/mm/pageattr.c
> ===================================================================
> --- linux.orig/arch/x86/mm/pageattr.c
> +++ linux/arch/x86/mm/pageattr.c
> @@ -152,9 +152,14 @@ pte_t *lookup_address(unsigned long addr
>  
>  	if (pgd_none(*pgd))
>  		return NULL;
> +
> +	*level = PG_LEVEL_1G;
>  	pud = pud_offset(pgd, address);
>  	if (pud_none(*pud))
>  		return NULL;

Please move the level update here, so it is consistent with PMD.

Thanks,

	tglx
