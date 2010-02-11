Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab0BKVmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 16:42:06 -0500
Received: from smtp-out.google.com ([216.239.33.17]:45750 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756977Ab0BKVmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 16:42:01 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Zu8Y2NofxhIxPO1JlC/3FvXqhMrT7OWjsRhhUzIpyZ9Lygqek+Zl5fg2KOQ/cMeba
	ZG6zH0bcLQzLedlAYw+yQ==
Date: Thu, 11 Feb 2010 13:41:53 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       haicheng.li@intel.com
Subject: Re: [PATCH] [1/4] SLAB: Handle node-not-up case in fallback_alloc()
 v2
In-Reply-To: <20100211205401.002CFB1978@basil.firstfloor.org>
Message-ID: <alpine.DEB.2.00.1002111338090.8809@chino.kir.corp.google.com>
References: <20100211953.850854588@firstfloor.org> <20100211205401.002CFB1978@basil.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Andi Kleen wrote:

> When fallback_alloc() runs the node of the CPU might not be initialized yet.
> Handle this case by allocating in another node.
> 
> v2: Try to allocate from all nodes (David Rientjes)
> 

You don't need to specifically address the cpuset restriction in 
fallback_alloc() since kmem_getpages() will return NULL whenever a zone is 
tried from an unallowed node, I just thought it was a faster optimization 
considering you (i) would operate over a nodemask and not the entire 
zonelist, (ii) it would avoid the zone_to_nid() for all zones since you 
already did a zonelist iteration in this function, and (iii) it wouldn't 
needlessly call kmem_getpages() for unallowed nodes.

> Signed-off-by: Andi Kleen <ak@linux.intel.com>

That said, I don't want to see this fix go unmerged since you already 
declined to make that optimization once:

Acked-by: David Rientjes <rientjes@google.com>
