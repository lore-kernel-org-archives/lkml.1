Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298Ab0AESyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab0AESyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 13:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617Ab0AESyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 13:54:15 -0500
Received: from smtp-out.google.com ([216.239.33.17]:46325 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab0AESyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 13:54:14 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=sNARWH71zgSROFBRsWAVGffn6j6gBnDPXb2dZe/TtPxW9ToClXtSr9kHlQI1INZUI
	yluHf6Q468jzTiyeVoWFw==
Date: Tue, 5 Jan 2010 10:53:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: H Hartley Sweeten <hartleys@visionengravers.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       bfields@fieldses.org
Subject: Re: [PATCH] nodemask.h: change any_online_node() to a static
 inline
In-Reply-To: <201001051117.39423.hartleys@visionengravers.com>
Message-ID: <alpine.DEB.2.00.1001051052100.26131@chino.kir.corp.google.com>
References: <201001051117.39423.hartleys@visionengravers.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010, H Hartley Sweeten wrote:

> diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
> index 454997c..1f66e02 100644
> --- a/include/linux/nodemask.h
> +++ b/include/linux/nodemask.h
> @@ -467,15 +467,6 @@ static inline int num_node_state(enum node_states state)
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
> @@ -484,6 +475,17 @@ static inline int num_node_state(enum node_states state)
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
>  /*
>   * For nodemask scrach area.
>   * NODEMASK_ALLOC(type, name) allocates an object with a specified type and

Could you simply remove any_online_node() and replace its callers with 
first_node(node_online_map) instead?
