Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbZCJC3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbZCJC3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 22:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbZCJC3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 22:29:09 -0400
Received: from smtp-out.google.com ([216.239.45.13]:26002 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbZCJC3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 22:29:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=GvjD1Hon1hOPnG0ykoi9BnSnEG831aOQ//a2MLlVzt/w9uq5nMVWsxVgKeM5t6nrs
	c4nm5pUaW2ex5bOlxRIWA==
Date: Mon, 9 Mar 2009 19:28:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm v2] cpusets: add memory_slab_hardwall flag
In-Reply-To: <alpine.DEB.2.00.0903091920100.7539@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0903091927410.10097@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903091920100.7539@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Mar 2009, David Rientjes wrote:

> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -86,6 +86,12 @@ static inline int cpuset_do_slab_mem_spread(void)
>  	return current->flags & PF_SPREAD_SLAB;
>  }
>  
> +static inline int current_cpuset_object_allowed(int node, gfp_t flags)
> +{
> +	return !(current->flags & PF_SPREAD_SLAB) ||
> +	       cpuset_node_allowed_hardwall(node, flags);
> +}
> +
>  extern int current_cpuset_is_being_rebound(void);
>  
>  extern void rebuild_sched_domains(void);

That should be PF_SLAB_HARDWALL.
---
 include/linux/cpuset.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index d255e68..4db22d1 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -88,7 +88,7 @@ static inline int cpuset_do_slab_mem_spread(void)
 
 static inline int current_cpuset_object_allowed(int node, gfp_t flags)
 {
-	return !(current->flags & PF_SPREAD_SLAB) ||
+	return !(current->flags & PF_SLAB_HARDWALL) ||
 	       cpuset_node_allowed_hardwall(node, flags);
 }
 
