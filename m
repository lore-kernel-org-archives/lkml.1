Return-Path: <linux-kernel-owner+w=401wt.eu-S1761013AbXHWUFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761013AbXHWUFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 16:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbXHWUFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 16:05:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41483 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750922AbXHWUFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 16:05:23 -0400
Date: Thu, 23 Aug 2007 13:05:22 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@skynet.ie>,
       linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-mm@kvack.org
Subject: Re: [BUG] 2.6.23-rc3-mm1 kernel BUG at mm/page_alloc.c:2876!
In-Reply-To: <46CDC11E.2010008@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0708231303050.14720@schroedinger.engr.sgi.com>
References: <46CC9A7A.2030404@linux.vnet.ibm.com>
 <20070822134800.ce5a5a69.akpm@linux-foundation.org>
 <20070822135024.dde8ef5a.akpm@linux-foundation.org> <20070823130732.GC18456@skynet.ie>
 <46CDC11E.2010008@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007, Kamalesh Babulal wrote:

> After applying the patch, the call trace is gone but the kernel bug
> is still hit

Yes that is what we expected. We need more information to figure out why 
the kmalloc_node fails there. It should walk through all nodes to find 
memory.

I see that you have 4 cpus and 16 nodes. How are the cpus assigned to 
nodes? If a cpu would be assigned to a nonexisting node then this could be 
the result.

Could you post the full boot log?

