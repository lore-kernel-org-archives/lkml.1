Return-Path: <linux-kernel-owner+w=401wt.eu-S1754211Ab0A0XqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab0A0XqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044Ab0A0XqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:46:20 -0500
Received: from smtp-out.google.com ([216.239.44.51]:52057 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab0A0XqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:46:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=va2IKgS+Lq/5r4J4MFg+Kv+HZ5TO++A99vEhenPVUtwkg5MfjGzo8/h21X/4JgKYU
	Ys5S+HkAvJIDHCGqXqGcg==
Date: Wed, 27 Jan 2010 15:46:15 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, minchan.kim@gmail.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
In-Reply-To: <20100127085355.f5306e78.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1001271541310.4663@chino.kir.corp.google.com>
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com> <20100122152332.750f50d9.kamezawa.hiroyu@jp.fujitsu.com> <20100125151503.49060e74.kamezawa.hiroyu@jp.fujitsu.com> <20100126151202.75bd9347.akpm@linux-foundation.org>
 <20100127085355.f5306e78.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010, KAMEZAWA Hiroyuki wrote:

> Yes, I think you're right. But "breaking current behaviro of our servers!"
> arguments kills all proposal to this area and this oom-killer or vmscan is
> a feature should be tested by real users.

Nobody has said we should discount lowmem rss when dealing with a GFP_DMA 
allocation, it simply wasn't possible until the lowmem rss counters were 
introduced in -mm.  It would prevent the needless killing of innocent 
tasks which would not allow the page allocation to succeed, so it's a good 
feature to have.  It doesn't need to be configurable at all, we just need 
to find a way to introduce it into the heuristic without mangling oom_adj.
