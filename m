Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab0BKVzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 16:55:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60123 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757145Ab0BKVzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 16:55:11 -0500
Date: Thu, 11 Feb 2010 22:55:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com
Subject: Re: [PATCH] [1/4] SLAB: Handle node-not-up case in
	fallback_alloc() v2
Message-ID: <20100211215508.GB18202@basil.fritz.box>
References: <20100211953.850854588@firstfloor.org> <20100211205401.002CFB1978@basil.firstfloor.org> <alpine.DEB.2.00.1002111338090.8809@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002111338090.8809@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 01:41:53PM -0800, David Rientjes wrote:
> On Thu, 11 Feb 2010, Andi Kleen wrote:
> 
> > When fallback_alloc() runs the node of the CPU might not be initialized yet.
> > Handle this case by allocating in another node.
> > 
> > v2: Try to allocate from all nodes (David Rientjes)
> > 
> 
> You don't need to specifically address the cpuset restriction in 
> fallback_alloc() since kmem_getpages() will return NULL whenever a zone is 
> tried from an unallowed node, I just thought it was a faster optimization 
> considering you (i) would operate over a nodemask and not the entire 
> zonelist, (ii) it would avoid the zone_to_nid() for all zones since you 
> already did a zonelist iteration in this function, and (iii) it wouldn't 
> needlessly call kmem_getpages() for unallowed nodes.

Thanks for the review again.

I don't really care about performance at all for this, this is just for
a few allocations during the memory hotadd path.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
