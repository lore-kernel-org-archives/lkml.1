Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbYJBVv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbYJBVv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 17:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbYJBVvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 17:51:49 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:45112 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbYJBVvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 17:51:48 -0400
Message-ID: <48E5428E.8080402@linux.vnet.ibm.com>
Date: Thu, 02 Oct 2008 16:52:14 -0500
From: Jon Tollefson <kniht@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Adam Litke <agl@us.ibm.com>
CC: linuxppc-dev <linuxppc-dev@ozlabs.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adam Litke <agl@linux.vnet.ibm.com>
Subject: Re: [PATCH] properly reserve in bootmem the lmb reserved regions
 that cross numa nodes
References: <48E23D6C.4030406@linux.vnet.ibm.com> <1222789675.13978.14.camel@localhost.localdomain>
In-Reply-To: <1222789675.13978.14.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adam Litke wrote:
> This seems like the right approach to me.  I have pointed out a few
> stylistic issues below.
>   
Thanks.  I'll make those changes.  I assume by __mminit you meant __meminit

Jon

> On Tue, 2008-09-30 at 09:53 -0500, Jon Tollefson wrote:
> <snip>
>   
>> +	/* Mark reserved regions */
>> +	for (i = 0; i < lmb.reserved.cnt; i++) {
>> +		unsigned long physbase = lmb.reserved.region[i].base;
>> +		unsigned long size = lmb.reserved.region[i].size;
>> +		unsigned long start_pfn = physbase >> PAGE_SHIFT;
>> +		unsigned long end_pfn = ((physbase+size-1) >> PAGE_SHIFT);
>>     
>
> CodingStyle dictates that this should be:
> unsigned long end_pfn = ((physbase + size - 1) >> PAGE_SHIFT);
>
> <snip>
>
>   
>> +/**
>> + * get_node_active_region - Return active region containing start_pfn
>> + * @start_pfn The page to return the region for.
>> + *
>> + * It will return NULL if active region is not found.
>> + */
>> +struct node_active_region *get_node_active_region(
>> +							unsigned long start_pfn)
>>     
>
> Bad style.  I think the convention would be to write it like this:
>
> struct node_active_region *
> get_node_active_region(unsigned long start_pfn)
>
>   
>> +{
>> +	int i;
>> +	for (i = 0; i < nr_nodemap_entries; i++) {
>> +		unsigned long node_start_pfn = early_node_map[i].start_pfn;
>> +		unsigned long node_end_pfn = early_node_map[i].end_pfn;
>> +
>> +		if (node_start_pfn <= start_pfn && node_end_pfn > start_pfn)
>> +			return &early_node_map[i];
>> +	}
>> +	return NULL;
>> +}
>>     
>
> Since this is using the early_node_map[], should we mark the function
> __mminit?  
>
>   

