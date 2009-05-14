Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbZENTCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbZENTCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 15:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbZENTCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 15:02:07 -0400
Received: from mail.fieldses.org ([141.211.133.115]:47622 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbZENTCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 15:02:06 -0400
Date: Thu, 14 May 2009 15:02:05 -0400
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] net/sunrpc/svc.c: fix sparse warning
Message-ID: <20090514190205.GA8367@fieldses.org>
References: <BD79186B4FD85F4B8E60E381CAEE1909015F8D20@mi8nycmail19.Mi8.com> <20090416190601.GA1145@fieldses.org> <BD79186B4FD85F4B8E60E381CAEE1909015F8F97@mi8nycmail19.Mi8.com> <20090511230541.GL793@fieldses.org> <BD79186B4FD85F4B8E60E381CAEE19090179A55B@mi8nycmail19.Mi8.com> <20090514160030.GA5675@fieldses.org> <BD79186B4FD85F4B8E60E381CAEE19090179A5BE@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090179A5BE@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 01:25:45PM -0400, H Hartley Sweeten wrote:
> Change any_online_node() from a macro to a static inline function.
> 
> any_online_node() uses the symbol 'node', this causes a sparse
> warning in net/sunrpc/svc.c.  Changing the macro to a static
> inline function removes the sparse warning and will prevent the
> same warning from possibly occurring in the future.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

I'm not sure where this goes--so maybe Andrew should take it?

--b.

> 
> ---
> 
> diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
> index 848025c..16df302 100644
> --- a/include/linux/nodemask.h
> +++ b/include/linux/nodemask.h
> @@ -440,15 +440,6 @@ static inline int num_node_state(enum node_states state)
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
> @@ -460,4 +451,15 @@ static inline int num_node_state(enum node_states state)
>  #define for_each_node(node)	   for_each_node_state(node, N_POSSIBLE)
>  #define for_each_online_node(node) for_each_node_state(node, N_ONLINE)
>  
> +static inline int any_online_node(nodemask_t mask)
> +{
> +	int node;
> +
> +	for_each_node_mask(node, mask) {
> +		if (node_online(node))
> +			break;
> +	}
> +	return node;
> +}
> +
>  #endif /* __LINUX_NODEMASK_H */ 
