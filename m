Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbYIJWhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbYIJWhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbYIJWhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:37:34 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:51431 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbYIJWhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:37:33 -0400
Message-ID: <48C84C0A.30902@linux.vnet.ibm.com>
Date: Wed, 10 Sep 2008 15:36:58 -0700
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: kamezawa.hiroyu@jp.fujitsu.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [Approach #2] [RFC][PATCH] Remove cgroup member from struct page
References: <48C66AF8.5070505@linux.vnet.ibm.com> <20080901161927.a1fe5afc.kamezawa.hiroyu@jp.fujitsu.com> <200809091358.28350.nickpiggin@yahoo.com.au> <20080909135317.cbff4871.kamezawa.hiroyu@jp.fujitsu.com> <200809091500.10619.nickpiggin@yahoo.com.au> <20080909141244.721dfd39.kamezawa.hiroyu@jp.fujitsu.com> <30229398.1220963412858.kamezawa.hiroyu@jp.fujitsu.com> <20080910012048.GA32752@balbir.in.ibm.com> <1221085260.6781.69.camel@nimitz>
In-Reply-To: <1221085260.6781.69.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Tue, 2008-09-09 at 18:20 -0700, Balbir Singh wrote:
>> +       start = pgdat->node_start_pfn;
>> +       end = pgdat->node_start_pfn + pgdat->node_spanned_pages;
>> +       size = (end - start) * sizeof(struct page_cgroup);
>> +       printk("Allocating %lu bytes for node %d\n", size, n);
>> +       pcg_map[n] = alloc_bootmem_node(pgdat, size);
>> +       /*
>> +        * We can do smoother recovery
>> +        */
>> +       BUG_ON(!pcg_map[n]);
>> +       return 0;
>>  }
> 
> This will really suck for sparse memory machines.  Imagine a machine
> with 1GB of memory at 0x0 and another 1GB of memory at 1TB up in the
> address space.
> 

I would hate to re-implement the entire sparsemem code :(
Kame did suggest making the memory controller depend on sparsemem (to hook in
from there for allocations)

> You also need to consider how it works with memory hotplug and how
> you're going to grow it at runtime.
> 

Yes, true. This is not the final version, a very very early version that I
posted for initial comments.

> Oh, and doesn't alloc_bootmem() panic() if it fails internally anyway?
> 
> I need to look at your other approach. :)

We'll need some slab_is_available() sort of checks that sparse.c uses and also
deal with memory hotplug add and remove.

-- 
	Balbir
