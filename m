Return-Path: <linux-kernel-owner+w=401wt.eu-S965915AbXCPU7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965915AbXCPU7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965925AbXCPU7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:59:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51091 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965915AbXCPU7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:59:23 -0400
Date: Fri, 16 Mar 2007 13:59:21 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: andi@firstfloor.org, rostedt@goodmis.org, torvalds@linux-foundation.org,
       mbligh@mbligh.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, chrisw@sous-sol.org, rusty@rustcorp.com.au,
       glommer@gmail.com
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
In-Reply-To: <20070316.135545.119242282.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0703161356190.6204@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0703161313240.6204@schroedinger.engr.sgi.com>
 <20070316.134718.95058720.davem@davemloft.net>
 <Pine.LNX.4.64.0703161350260.6204@schroedinger.engr.sgi.com>
 <20070316.135545.119242282.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007, David Miller wrote:

> From: Christoph Lameter <clameter@sgi.com>
> Date: Fri, 16 Mar 2007 13:52:18 -0700 (PDT)
> 
> > Virtual mmap allows holes in the same way as page tables do.
> 
> I don't want to take expensive TLB misses to lookup a page.

Ummm. You are missing key details please look at linux-mm. We will use 
huge tlb entries for the mmap and its optional.

> TLB misses are extremely expensive on some platforms, that's why
> I try to make all the critical structures go through the 4MB
> locked TLB entry for the kernel image, or failing that the
> 4MB linear mappings at PAGE_OFFSET on sparc64.

Exactly. That is why 16M TLB entries speed up the kernel by 
4-5% using vmmemmap on ia64. Basically we end up with one TLB per node 
for the vmemmap which always stays in the cache. No additional lookups.
Without vmemmap we still need a 16M TLB for the 1-1 kernel mapping. This 
jsut cuts out the crud from sparsemem.


