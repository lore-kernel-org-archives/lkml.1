Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbYJNMAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbYJNMAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 08:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbYJNMAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 08:00:00 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41861 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbYJNL77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 07:59:59 -0400
Date: Tue, 14 Oct 2008 20:59:59 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Subject: Re: [PATCH] release memory regions in PAGES_PER_SECTION chunks
Cc: linux-kernel@vger.kernel.org, Badari Pulavarty <pbadari@us.ibm.com>
In-Reply-To: <48F3ADEF.1080905@austin.ibm.com>
References: <48F3ADEF.1080905@austin.ibm.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20081014205507.AD7F.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Good catch.
Looks good to me.

Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>

> During hotplug memory remove, memory regions should be released
> on a PAGES_PER_SECTION size chunks.  This mirrors the code in
> add_memory where resources are requested on a PAGES_PER_SECTION size.
> 
> Attempting to release the entire memory region fails because there is
> not a single resource for the total number of pages being removed.
> Instead the resources for the pages are split in PAGES_PER_SECTION
> size chunks as requested during memory add.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
> Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
> 
> ---
> 
> Index: linux-2.6/mm/memory_hotplug.c
> ===================================================================
> --- linux-2.6.orig/mm/memory_hotplug.c	2008-10-13 12:00:46.000000000 -0500
> +++ linux-2.6/mm/memory_hotplug.c	2008-10-13 14:29:31.000000000 -0500
> @@ -323,11 +323,11 @@
>  	BUG_ON(phys_start_pfn & ~PAGE_SECTION_MASK);
>  	BUG_ON(nr_pages % PAGES_PER_SECTION);
>  
> -	release_mem_region(phys_start_pfn << PAGE_SHIFT, nr_pages * PAGE_SIZE);
> -
>  	sections_to_remove = nr_pages / PAGES_PER_SECTION;
>  	for (i = 0; i < sections_to_remove; i++) {
>  		unsigned long pfn = phys_start_pfn + i*PAGES_PER_SECTION;
> +		release_mem_region(pfn << PAGE_SHIFT,
> +				   PAGES_PER_SECTION << PAGE_SHIFT);
>  		ret = __remove_section(zone, __pfn_to_section(pfn));
>  		if (ret)
>  			break;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Yasunori Goto 


