Return-Path: <linux-kernel-owner+w=401wt.eu-S1759678AbXFZTOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678AbXFZTOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760094AbXFZTOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:14:00 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:1219 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759982AbXFZTN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=F1LnlAdrXpz5ZLI9hsOp785lXT9OzDx6iSGPQdyeXb0oJszSwQ7WQ7TI4g6D5BG7qdcOsC6Ev5lh3/3U6d9COueWDn91BN0h5X1ossXwQj2qJLo9lU6bzrxx6E6ej3nGVYCX4qbcAo3tT4BkHyPMNDl4A5iNJjYAckXWijDy2jw=
Message-ID: <29495f1d0706261213w73b7cbe0weabdcb2b03a9b880@mail.gmail.com>
Date: Tue, 26 Jun 2007 12:13:57 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "clameter@sgi.com" <clameter@sgi.com>
Subject: Re: [patch 12/26] SLUB: Slab defragmentation core
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       suresh.b.siddha@intel.com
In-Reply-To: <20070618095916.297690463@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070618095838.238615343@sgi.com>
	 <20070618095916.297690463@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/07, clameter@sgi.com <clameter@sgi.com> wrote:
> Slab defragmentation occurs either
>
> 1. Unconditionally when kmem_cache_shrink is called on slab by the kernel
>    calling kmem_cache_shrink or slabinfo triggering slab shrinking. This
>    form performs defragmentation on all nodes of a NUMA system.
>
> 2. Conditionally when kmem_cache_defrag(<percentage>, <node>) is called.
>
>    The defragmentation is only performed if the fragmentation of the slab
>    is higher then the specified percentage. Fragmentation ratios are measured
>    by calculating the percentage of objects in use compared to the total
>    number of objects that the slab cache could hold.
>
>    kmem_cache_defrag takes a node parameter. This can either be -1 if
>    defragmentation should be performed on all nodes, or a node number.
>    If a node number was specified then defragmentation is only performed
>    on a specific node.

Hrm, isn't -1 usually 'this node' for NUMA systems? Maybe nr_node_ids
or MAX_NUMNODES should mean 'all nodes'?

Perhaps these would be served with some #defines?

#define NUMA_THISNODE_ID (-1)
#define NUMA_ALLNODES_ID (MAX_NUMNODES)

or something?

Thanks,
Nish
