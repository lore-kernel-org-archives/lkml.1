Return-Path: <linux-kernel-owner+w=401wt.eu-S933181Ab0AFXzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181Ab0AFXzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933132Ab0AFXzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:55:50 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59405 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933074Ab0AFXzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:55:48 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 7 Jan 2010 08:51:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       devicetree-discuss@lists.ozlabs.org, linux-nfs@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org, rientjes@google.com,
       mel@csn.ul.ie, lee.schermerhorn@hp.com, benh@kernel.crashing.org,
       paulus@samba.org, dave@linux.vnet.ibm.com, miltonm@bga.com,
       nfont@austin.ibm.com, geoffrey.levand@am.sony.com,
       grant.likely@secretlab.ca, bfields@fieldses.org, neilb@suse.de,
       Trond.Myklebust@netapp.com, davem@davemloft.net, bhalevy@panasas.com,
       chuck.lever@oracle.com, Ricardo.Labiaga@netapp.com
Subject: Re: [PATCH] nodmask.h: remove macro any_online_node
Message-Id: <20100107085146.59cc9888.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <201001061624.59118.hartleys@visionengravers.com>
References: <201001061624.59118.hartleys@visionengravers.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jan 2010 16:24:58 -0700
H Hartley Sweeten <hartleys@visionengravers.com> wrote:

> nodmask.h: remove macro any_online_node
> 
> The macro any_online_node is prone to producing sparse warnings
> due to the local symbol 'node'. Since all the in-tree users are really
> requesting the first online node (the mask argument is either
> NODE_MASK_ALL or node_online_map) just use the first_online_node
> macro and remove the any_online_node macro since there are no users.
> 

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Thank you.
BTW, it's better to add diffstat to this kind of changes.

Regards,
-Kame

> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> Cc: Milton Miller <miltonm@bga.com>
> Cc: Nathan Fontenot <nfont@austin.ibm.com>
> Cc: Geoff Levand <geoffrey.levand@am.sony.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: J. Bruce Fields <bfields@fieldses.org>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Benny Halevy <bhalevy@panasas.com>
> Cc: Chuck Lever <chuck.lever@oracle.com>
> Cc: Ricardo Labiaga <Ricardo.Labiaga@netapp.com>
> 
> ---
> 
> diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
> index b037d95..64c0022 100644
> --- a/arch/powerpc/mm/numa.c
> +++ b/arch/powerpc/mm/numa.c
> @@ -451,7 +451,7 @@ static int __cpuinit numa_setup_cpu(unsigned long lcpu)
>  	nid = of_node_to_nid_single(cpu);
>  
>  	if (nid < 0 || !node_online(nid))
> -		nid = any_online_node(NODE_MASK_ALL);
> +		nid = first_online_node;
>  out:
>  	map_cpu_to_node(lcpu, nid);
>  
> @@ -1114,7 +1114,7 @@ int hot_add_scn_to_nid(unsigned long scn_addr)
>  	int nid, found = 0;
>  
>  	if (!numa_enabled || (min_common_depth < 0))
> -		return any_online_node(NODE_MASK_ALL);
> +		return first_online_node;
>  
>  	memory = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
>  	if (memory) {
> @@ -1125,7 +1125,7 @@ int hot_add_scn_to_nid(unsigned long scn_addr)
>  	}
>  
>  	if (nid < 0 || !node_online(nid))
> -		nid = any_online_node(NODE_MASK_ALL);
> +		nid = first_online_node;
>  
>  	if (NODE_DATA(nid)->node_spanned_pages)
>  		return nid;
> diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
> index 454997c..c4fa64b 100644
> --- a/include/linux/nodemask.h
> +++ b/include/linux/nodemask.h
> @@ -69,8 +69,6 @@
>   * int node_online(node)		Is some node online?
>   * int node_possible(node)		Is some node possible?
>   *
> - * int any_online_node(mask)		First online node in mask
> - *
>   * node_set_online(node)		set bit 'node' in node_online_map
>   * node_set_offline(node)		clear bit 'node' in node_online_map
>   *
> @@ -467,15 +465,6 @@ static inline int num_node_state(enum node_states state)
>  #define node_online_map 	node_states[N_ONLINE]
>  #define node_possible_map 	node_states[N_POSSIBLE]
>  
> -#define any_online_node(mask)			\
> -({						\
> -	int node;				\
> -	for_each_node_mask(node, (mask))	\
> -		if (node_online(node))		\
> -			break;			\
> -	node;					\
> -})
> -
>  #define num_online_nodes()	num_node_state(N_ONLINE)
>  #define num_possible_nodes()	num_node_state(N_POSSIBLE)
>  #define node_online(node)	node_state((node), N_ONLINE)
> diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
> index 538ca43..832c1fe 100644
> --- a/net/sunrpc/svc.c
> +++ b/net/sunrpc/svc.c
> @@ -133,7 +133,7 @@ svc_pool_map_choose_mode(void)
>  		return SVC_POOL_PERNODE;
>  	}
>  
> -	node = any_online_node(node_online_map);
> +	node = first_online_node;
>  	if (nr_cpus_node(node) > 2) {
>  		/*
>  		 * Non-trivial SMP, or CONFIG_NUMA on
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
