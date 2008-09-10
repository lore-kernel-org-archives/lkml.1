Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbYIJW5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbYIJW5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbYIJW5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:57:03 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53996 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbYIJW5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:57:01 -0400
Subject: Re: [Approach #2] [RFC][PATCH] Remove cgroup member from struct
	page
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: balbir@linux.vnet.ibm.com
Cc: kamezawa.hiroyu@jp.fujitsu.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <48C84C0A.30902@linux.vnet.ibm.com>
References: <48C66AF8.5070505@linux.vnet.ibm.com>
	 <20080901161927.a1fe5afc.kamezawa.hiroyu@jp.fujitsu.com>
	 <200809091358.28350.nickpiggin@yahoo.com.au>
	 <20080909135317.cbff4871.kamezawa.hiroyu@jp.fujitsu.com>
	 <200809091500.10619.nickpiggin@yahoo.com.au>
	 <20080909141244.721dfd39.kamezawa.hiroyu@jp.fujitsu.com>
	 <30229398.1220963412858.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080910012048.GA32752@balbir.in.ibm.com>
	 <1221085260.6781.69.camel@nimitz>  <48C84C0A.30902@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 15:56:48 -0700
Message-Id: <1221087408.6781.73.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-10 at 15:36 -0700, Balbir Singh wrote:
> Dave Hansen wrote:
> > On Tue, 2008-09-09 at 18:20 -0700, Balbir Singh wrote:
> >> +       start = pgdat->node_start_pfn;
> >> +       end = pgdat->node_start_pfn + pgdat->node_spanned_pages;
> >> +       size = (end - start) * sizeof(struct page_cgroup);
> >> +       printk("Allocating %lu bytes for node %d\n", size, n);
> >> +       pcg_map[n] = alloc_bootmem_node(pgdat, size);
> >> +       /*
> >> +        * We can do smoother recovery
> >> +        */
> >> +       BUG_ON(!pcg_map[n]);
> >> +       return 0;
> >>  }
> > 
> > This will really suck for sparse memory machines.  Imagine a machine
> > with 1GB of memory at 0x0 and another 1GB of memory at 1TB up in the
> > address space.
> > 
> 
> I would hate to re-implement the entire sparsemem code :(
> Kame did suggest making the memory controller depend on sparsemem (to hook in
> from there for allocations)

Yeah, you could just make another mem_section member.  Or, you could
work to abstract the sparsemem code so that other people can use it, or
maybe make it more dynamic so we can have multiple pfn->object lookups
in parallel.  Adding the struct member is obviously easier.

-- Dave

