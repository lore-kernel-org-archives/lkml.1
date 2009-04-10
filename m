Return-Path: <linux-kernel-owner+w=401wt.eu-S938375AbZDJPTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938375AbZDJPTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 11:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932587AbZDJPTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 11:19:38 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42796 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764996AbZDJPTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 11:19:37 -0400
Date: Fri, 10 Apr 2009 10:19:34 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, dave@linux.vnet.ibm.com, mingo@elte.hu,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/30] ipcns: remove useless get/put while CLONE_NEWIPC
Message-ID: <20090410151934.GA16027@us.ibm.com>
References: <20090410023335.GD27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410023335.GD27788@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> copy_ipcs() doesn't actually copy anything. If new ipcns is created,
> it's created from scratch, in this case get/put on old ipcns isn't needed.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Yeah, I like this change just for the diffstat.

Acked-by: Serge Hallyn <serue@us.ibm.com>

How about breaking these out from the c/r set?

thanks,
-serge

> ---
> 
>  ipc/namespace.c |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> --- a/ipc/namespace.c
> +++ b/ipc/namespace.c
> @@ -50,15 +50,11 @@ struct ipc_namespace *copy_ipcs(unsigned long flags, struct ipc_namespace *ns)
>  {
>  	struct ipc_namespace *new_ns;
> 
> -	BUG_ON(!ns);
> -	get_ipc_ns(ns);
> -
>  	if (!(flags & CLONE_NEWIPC))
> -		return ns;
> +		return get_ipc_ns(ns);
> 
>  	new_ns = clone_ipc_ns(ns);
> 
> -	put_ipc_ns(ns);
>  	return new_ns;
>  }
