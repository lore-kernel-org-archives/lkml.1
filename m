Return-Path: <linux-kernel-owner+w=401wt.eu-S1752720AbYI3IJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbYI3IJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbYI3IJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:09:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36155 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbYI3IJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:09:30 -0400
Date: Tue, 30 Sep 2008 17:06:08 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Gary Hade <garyhade@us.ibm.com>
Subject: Re: [PATCH] mm: show node to memory section relationship with symlinks in sysfs
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Nish Aravamudan <nish.aravamudan@gmail.com>
In-Reply-To: <20080929200509.GC21255@us.ibm.com>
References: <20080929200509.GC21255@us.ibm.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080930163324.44A7.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
> +int register_mem_sect_under_node(struct memory_block *mem_blk)
        :

I think this patch is convenience even when memory hotplug is disabled.
CONFIG_SPARSEMEM seems better than CONFIG_MEMORY_HOTPLUG_SPARSE.


> +int register_mem_sect_under_node(struct memory_block *mem_blk)
> +{
> +	unsigned int nid;
> +
> +	if (!mem_blk)
> +		return -EFAULT;
> +	nid = section_nr_to_nid(mem_blk->phys_index);

(snip)

> +#define section_nr_to_nid(section_nr) pfn_to_nid(section_nr_to_pfn(section_nr))
>  #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */

If the first page of the section is not valid, then this section_nr_to_nid()
doesn't return correct value.

I tested this patch. In my box, the start_pfn of node 1 is 1200400, but 
section_nr_to_pfn(mem_blk->phys_index) returns 1200000. As a result,
the section is linked to node 0.

Bye.
-- 
Yasunori Goto 


