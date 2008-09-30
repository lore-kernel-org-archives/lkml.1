Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbYI3PsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbYI3PsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 11:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbYI3PsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 11:48:00 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57143 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbYI3Pr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 11:47:59 -0400
Subject: Re: [PATCH] properly reserve in bootmem the lmb reserved regions
	that cross numa nodes
From: Adam Litke <agl@us.ibm.com>
To: Jon Tollefson <kniht@linux.vnet.ibm.com>
Cc: linuxppc-dev <linuxppc-dev@ozlabs.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adam Litke <agl@linux.vnet.ibm.com>
In-Reply-To: <48E23D6C.4030406@linux.vnet.ibm.com>
References: <48E23D6C.4030406@linux.vnet.ibm.com>
Content-Type: text/plain
Organization: IBM
Date: Tue, 30 Sep 2008 10:47:55 -0500
Message-Id: <1222789675.13978.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This seems like the right approach to me.  I have pointed out a few
stylistic issues below.

On Tue, 2008-09-30 at 09:53 -0500, Jon Tollefson wrote:
<snip>
> +	/* Mark reserved regions */
> +	for (i = 0; i < lmb.reserved.cnt; i++) {
> +		unsigned long physbase = lmb.reserved.region[i].base;
> +		unsigned long size = lmb.reserved.region[i].size;
> +		unsigned long start_pfn = physbase >> PAGE_SHIFT;
> +		unsigned long end_pfn = ((physbase+size-1) >> PAGE_SHIFT);

CodingStyle dictates that this should be:
unsigned long end_pfn = ((physbase + size - 1) >> PAGE_SHIFT);

<snip>

> +/**
> + * get_node_active_region - Return active region containing start_pfn
> + * @start_pfn The page to return the region for.
> + *
> + * It will return NULL if active region is not found.
> + */
> +struct node_active_region *get_node_active_region(
> +							unsigned long start_pfn)

Bad style.  I think the convention would be to write it like this:

struct node_active_region *
get_node_active_region(unsigned long start_pfn)

> +{
> +	int i;
> +	for (i = 0; i < nr_nodemap_entries; i++) {
> +		unsigned long node_start_pfn = early_node_map[i].start_pfn;
> +		unsigned long node_end_pfn = early_node_map[i].end_pfn;
> +
> +		if (node_start_pfn <= start_pfn && node_end_pfn > start_pfn)
> +			return &early_node_map[i];
> +	}
> +	return NULL;
> +}

Since this is using the early_node_map[], should we mark the function
__mminit?  

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

