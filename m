Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbYIJWVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbYIJWVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbYIJWVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:21:11 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34375 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbYIJWVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:21:10 -0400
Subject: Re: [Approach #2] [RFC][PATCH] Remove cgroup member from struct
	page
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: balbir@linux.vnet.ibm.com
Cc: kamezawa.hiroyu@jp.fujitsu.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20080910012048.GA32752@balbir.in.ibm.com>
References: <48C66AF8.5070505@linux.vnet.ibm.com>
	 <20080901161927.a1fe5afc.kamezawa.hiroyu@jp.fujitsu.com>
	 <200809091358.28350.nickpiggin@yahoo.com.au>
	 <20080909135317.cbff4871.kamezawa.hiroyu@jp.fujitsu.com>
	 <200809091500.10619.nickpiggin@yahoo.com.au>
	 <20080909141244.721dfd39.kamezawa.hiroyu@jp.fujitsu.com>
	 <30229398.1220963412858.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080910012048.GA32752@balbir.in.ibm.com>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 15:21:00 -0700
Message-Id: <1221085260.6781.69.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-09 at 18:20 -0700, Balbir Singh wrote:
> +       start = pgdat->node_start_pfn;
> +       end = pgdat->node_start_pfn + pgdat->node_spanned_pages;
> +       size = (end - start) * sizeof(struct page_cgroup);
> +       printk("Allocating %lu bytes for node %d\n", size, n);
> +       pcg_map[n] = alloc_bootmem_node(pgdat, size);
> +       /*
> +        * We can do smoother recovery
> +        */
> +       BUG_ON(!pcg_map[n]);
> +       return 0;
>  }

This will really suck for sparse memory machines.  Imagine a machine
with 1GB of memory at 0x0 and another 1GB of memory at 1TB up in the
address space.

You also need to consider how it works with memory hotplug and how
you're going to grow it at runtime.

Oh, and doesn't alloc_bootmem() panic() if it fails internally anyway?

I need to look at your other approach. :)

-- Dave

