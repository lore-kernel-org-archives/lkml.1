Return-Path: <linux-kernel-owner+w=401wt.eu-S1755708AbZDOUtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbZDOUtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 16:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbZDOUtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 16:49:23 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13060 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbZDOUtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 16:49:23 -0400
Date: Wed, 15 Apr 2009 22:49:21 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: H Hartley Sweeten <hartleys@visionengravers.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/sunrpc/svc.c: fix sparse warning
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE1909015F8D20@mi8nycmail19.Mi8.com>
Message-ID: <alpine.LNX.2.00.0904152247580.25543@swampdragon.chaosbits.net>
References: <BD79186B4FD85F4B8E60E381CAEE1909015F8D20@mi8nycmail19.Mi8.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009, H Hartley Sweeten wrote:

> Fix sparse warning in net/sunrpc/svc.c.
> 
> 	warning: symbol 'node' shadows an earlier one
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> 
> ---
> 
> diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
> index 8847add..e781135 100644
> --- a/net/sunrpc/svc.c
> +++ b/net/sunrpc/svc.c
> @@ -122,7 +122,7 @@ module_param_call(pool_mode, param_set_pool_mode,
> param_get_pool_mode,
>  static int
>  svc_pool_map_choose_mode(void)
>  {
> -	unsigned int node;
> +	unsigned int nid;
>  
>  	if (num_online_nodes() > 1) {
>  		/*
> @@ -132,8 +132,8 @@ svc_pool_map_choose_mode(void)
>  		return SVC_POOL_PERNODE;
>  	}
>  
> -	node = any_online_node(node_online_map);
> -	if (nr_cpus_node(node) > 2) {
> +	nid = any_online_node(node_online_map);
> +	if (nr_cpus_node(nid) > 2) {
>  		/*
>  		 * Non-trivial SMP, or CONFIG_NUMA on
>  		 * non-NUMA hardware, e.g. with a generic 

Looks sane to me.

Probably doesn't matter much, but feel free to add

  Acked-by: Jesper Juhl <jj@chaosbits.net>

if you like...

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

