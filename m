Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbZDJWjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbZDJWjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 18:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbZDJWjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 18:39:12 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:39711 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbZDJWjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 18:39:11 -0400
Date: Fri, 10 Apr 2009 17:39:10 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, dave@linux.vnet.ibm.com, mingo@elte.hu,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/30] netns: don't get/put old netns on CLONE_NEWNET
Message-ID: <20090410223910.GC13873@us.ibm.com>
References: <20090410023431.GG27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410023431.GG27788@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> copy_net_ns() doesn't copy anything, it creates fresh netns,
> so get/put of old netns is unneeded.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
> 
>  net/core/net_namespace.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> --- a/net/core/net_namespace.c
> +++ b/net/core/net_namespace.c
> @@ -120,10 +120,8 @@ struct net *copy_net_ns(unsigned long flags, struct net *old_net)
>  	struct net *new_net = NULL;
>  	int err;
> 
> -	get_net(old_net);
> -
>  	if (!(flags & CLONE_NEWNET))
> -		return old_net;
> +		return get_net(old_net);
> 
>  	err = -ENOMEM;
>  	new_net = net_alloc();
> @@ -142,7 +140,6 @@ struct net *copy_net_ns(unsigned long flags, struct net *old_net)
>  	if (err)
>  		goto out_free;
>  out:
> -	put_net(old_net);
>  	return new_net;
> 
>  out_free:
