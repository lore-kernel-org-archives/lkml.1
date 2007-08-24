Return-Path: <linux-kernel-owner+w=401wt.eu-S1760713AbXHXQyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713AbXHXQyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbXHXQyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:54:12 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48580 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751219AbXHXQyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:54:10 -0400
Date: Fri, 24 Aug 2007 09:54:08 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@skynet.ie>,
       linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-mm@kvack.org
Subject: Re: [BUG] 2.6.23-rc3-mm1 kernel BUG at mm/page_alloc.c:2876!
In-Reply-To: <46CE776D.2010408@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0708240950340.20501@schroedinger.engr.sgi.com>
References: <46CC9A7A.2030404@linux.vnet.ibm.com>
 <20070822134800.ce5a5a69.akpm@linux-foundation.org>
 <20070822135024.dde8ef5a.akpm@linux-foundation.org> <20070823130732.GC18456@skynet.ie>
 <46CDC11E.2010008@linux.vnet.ibm.com> <Pine.LNX.4.64.0708231303050.14720@schroedinger.engr.sgi.com>
 <46CE776D.2010408@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007, Kamalesh Babulal wrote:

> Starting Linux PPC64 #1 SMP Thu Aug 23 11:54:44 EDT 2007

Argh. PPC64. The typical thing that we break on all major NUMA
changes.

> EEH: PCI Enhanced I/O Error Handling Enabled
> PPC64 nvram contains 7168 bytes
> Zone PFN ranges:
> DMA 0 -> 1048576
> Normal 1048576 -> 1048576
> Movable zone start PFN for each node
> early_node_map[1] active PFN ranges
> 2: 0 -> 1048576
> Could not find start_pfn for node 0
> [boot]0015 Setup Done
> Built 2 zonelists in Node order, mobility grouping off. Total pages: 0
> Policy zone: DMA

Uhhh huh. So we have node 0 and 2 that got zonelists. What happened to 
node 1?

> Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> freeing bootmem node 2

Hmmm... The boot occurs on node 2??

There could be something wrong with zonelist generation since various 
people worked on it. Could you add some printks to show how the zonelists 
are generated?

