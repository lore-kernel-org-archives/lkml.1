Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbZGNKSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbZGNKSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 06:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbZGNKSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 06:18:48 -0400
Received: from smtp-out.google.com ([216.239.45.13]:8935 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbZGNKSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 06:18:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=iheeiLsX44x3IDcjZkADSSMgiaKCFHlmUor2FJCPJ9ai0UpnKhEZNjIMv67Icavi8
	X5dOGSri9zUh3dmegSCzw==
Date: Tue, 14 Jul 2009 03:18:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Zhaolei <zhaolei@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove initialization of page_table in
 one_page_table_init()
In-Reply-To: <4A5C488A.90204@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907140317001.22788@chino.kir.corp.google.com>
References: <4A5C488A.90204@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jul 2009, Zhaolei wrote:

> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index 3cd7711..55da09b 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -108,13 +108,13 @@ static pmd_t * __init one_md_table_init(pgd_t *pgd)
> static pte_t * __init one_page_table_init(pmd_t *pmd)
> {
>     if (!(pmd_val(*pmd) & _PAGE_PRESENT)) {
> -        pte_t *page_table = NULL;
> +        pte_t *page_table;
> 
>         if (after_bootmem) {
> #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
>             page_table = (pte_t *) alloc_bootmem_pages(PAGE_SIZE);
> -#endif
>             if (!page_table)
> +#endif
>                 page_table =
>                 (pte_t *)alloc_bootmem_low_pages(PAGE_SIZE);
>         } else

Nack, gcc will already optimize the branch out for configs without 
CONFIG_DEBUG_PAGEALLOC and CONFIG_KMEMCHECK.  The only thing this change 
does is make the code less readable.
