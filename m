Return-Path: <linux-kernel-owner+w=401wt.eu-S1752120AbZDJW3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbZDJW3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 18:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759131AbZDJW3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 18:29:22 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:46495 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbZDJW3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 18:29:21 -0400
Date: Fri, 10 Apr 2009 17:29:16 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, dave@linux.vnet.ibm.com, mingo@elte.hu,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/30] ipcns: add create_ipc_ns()
Message-ID: <20090410222916.GA13873@us.ibm.com>
References: <20090410023358.GE27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410023358.GE27788@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> clone_ipc_ns() is misnamed, it doesn't clone anything and doesn't uses passed
> parameter. Rename it.
> 
> create_ipc_ns() will be used by C/R to create ipcns on restart.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
> 
>  include/linux/ipc_namespace.h |    1 +
>  ipc/namespace.c               |    9 ++-------
>  2 files changed, 3 insertions(+), 7 deletions(-)
> 
> --- a/include/linux/ipc_namespace.h
> +++ b/include/linux/ipc_namespace.h
> @@ -97,6 +97,7 @@ static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
> 
>  #if defined(CONFIG_IPC_NS)
>  extern void free_ipc_ns(struct ipc_namespace *ns);
> +struct ipc_namespace *create_ipc_ns(void);
>  extern struct ipc_namespace *copy_ipcs(unsigned long flags,
>  				       struct ipc_namespace *ns);
>  extern void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
> --- a/ipc/namespace.c
> +++ b/ipc/namespace.c
> @@ -14,7 +14,7 @@
> 
>  #include "util.h"
> 
> -static struct ipc_namespace *clone_ipc_ns(struct ipc_namespace *old_ns)
> +struct ipc_namespace *create_ipc_ns(void)
>  {
>  	struct ipc_namespace *ns;
>  	int err;
> @@ -48,14 +48,9 @@ static struct ipc_namespace *clone_ipc_ns(struct ipc_namespace *old_ns)
> 
>  struct ipc_namespace *copy_ipcs(unsigned long flags, struct ipc_namespace *ns)
>  {
> -	struct ipc_namespace *new_ns;
> -
>  	if (!(flags & CLONE_NEWIPC))
>  		return get_ipc_ns(ns);
> -
> -	new_ns = clone_ipc_ns(ns);
> -
> -	return new_ns;
> +	return create_ipc_ns();
>  }
> 
>  /*
