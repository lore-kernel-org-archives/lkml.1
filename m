Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbZDVXFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbZDVXFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 19:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbZDVXE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 19:04:57 -0400
Received: from smtp-out.google.com ([216.239.33.17]:50679 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZDVXE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 19:04:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=M09qhDqOulMQCdE9anMkkap8RfLXoG+vrtgMc7azpIU1qKhhPfPQXSYiAoR9clwCO
	dccy7PgHfZI+GuzaaTi+g==
Date: Wed, 22 Apr 2009 16:04:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 21/22] Use a pre-calculated value instead of num_online_nodes()
 in fast paths
In-Reply-To: <1240408407-21848-22-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0904221602560.27097@chino.kir.corp.google.com>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie> <1240408407-21848-22-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009, Mel Gorman wrote:

> diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
> index 848025c..474e73e 100644
> --- a/include/linux/nodemask.h
> +++ b/include/linux/nodemask.h
> @@ -408,6 +408,19 @@ static inline int num_node_state(enum node_states state)
>  #define next_online_node(nid)	next_node((nid), node_states[N_ONLINE])
>  
>  extern int nr_node_ids;
> +extern int nr_online_nodes;
> +
> +static inline void node_set_online(int nid)
> +{
> +	node_set_state(nid, N_ONLINE);
> +	nr_online_nodes = num_node_state(N_ONLINE);
> +}
> +
> +static inline void node_set_offline(int nid)
> +{
> +	node_clear_state(nid, N_ONLINE);
> +	nr_online_nodes = num_node_state(N_ONLINE);
> +}
>  #else
>  
>  static inline int node_state(int node, enum node_states state)

The later #define's of node_set_online() and node_set_offline() in 
include/linux/nodemask.h should probably be removed now.
