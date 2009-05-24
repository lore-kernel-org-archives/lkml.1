Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbZEXWoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbZEXWoY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757764AbZEXWoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:44:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57690 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962AbZEXWoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:44:16 -0400
Date: Sun, 24 May 2009 17:49:08 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, torvalds@linux-foundation.org
Subject: Re: [PATCH 06/38] ipcns 4/2: move free_ipcs() proto
Message-ID: <20090524224908.GE12734@hallyn.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com> <1242968132-1044-6-git-send-email-adobriyan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242968132-1044-6-git-send-email-adobriyan@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> Function is really private to ipc/ and avoid struct kern_ipc_perm
> forward declaration.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Reviewed-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  include/linux/ipc_namespace.h |    4 ----
>  ipc/util.h                    |    3 ++-
>  2 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
> index 804e4e4..e408722 100644
> --- a/include/linux/ipc_namespace.h
> +++ b/include/linux/ipc_namespace.h
> @@ -96,10 +96,6 @@ static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
>  #if defined(CONFIG_IPC_NS)
>  extern struct ipc_namespace *copy_ipcs(unsigned long flags,
>  				       struct ipc_namespace *ns);
> -extern void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
> -		      void (*free)(struct ipc_namespace *,
> -				   struct kern_ipc_perm *));
> -
>  static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
>  {
>  	if (ns)
> diff --git a/ipc/util.h b/ipc/util.h
> index 1187332..7a2861b 100644
> --- a/ipc/util.h
> +++ b/ipc/util.h
> @@ -171,5 +171,6 @@ static inline void ipc_unlock(struct kern_ipc_perm *perm)
>  struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id);
>  int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
>  			struct ipc_ops *ops, struct ipc_params *params);
> -
> +void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
> +		void (*free)(struct ipc_namespace *, struct kern_ipc_perm *));
>  #endif
> -- 
> 1.5.6.5
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
