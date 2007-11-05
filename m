Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbXKEOpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbXKEOpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 09:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbXKEOpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 09:45:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220AbXKEOo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 09:44:59 -0500
Date: Mon, 5 Nov 2007 08:42:16 -0600
From: David Teigland <teigland@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: pcaulfie@redhat.com, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fs/dlm/: proper prototypes
Message-ID: <20071105144216.GA5734@redhat.com>
References: <20071103000430.GG4594@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071103000430.GG4594@stusta.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2007 at 01:04:30AM +0100, Adrian Bunk wrote:
> This patch adds a proper prototype for some functions in 
> fs/dlm/dlm_internal.h

Acked-by: David Teigland <teigland@redhat.com>


> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  fs/dlm/dlm_internal.h |   16 ++++++++++++++++
>  fs/dlm/lock.c         |    1 -
>  fs/dlm/lockspace.c    |    8 --------
>  fs/dlm/main.c         |   10 ----------
>  4 files changed, 16 insertions(+), 19 deletions(-)
> 
> 11349b53af8d04ff007660d9142e2382033f5d8f 
> diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
> index d2fc238..ec61bba 100644
> --- a/fs/dlm/dlm_internal.h
> +++ b/fs/dlm/dlm_internal.h
> @@ -570,5 +570,21 @@ static inline int dlm_no_directory(struct dlm_ls *ls)
>  	return (ls->ls_exflags & DLM_LSFL_NODIR) ? 1 : 0;
>  }
>  
> +int dlm_netlink_init(void);
> +void dlm_netlink_exit(void);
> +void dlm_timeout_warn(struct dlm_lkb *lkb);
> +
> +#ifdef CONFIG_DLM_DEBUG
> +int dlm_register_debugfs(void);
> +void dlm_unregister_debugfs(void);
> +int dlm_create_debug_file(struct dlm_ls *ls);
> +void dlm_delete_debug_file(struct dlm_ls *ls);
> +#else
> +static inline int dlm_register_debugfs(void) { return 0; }
> +static inline void dlm_unregister_debugfs(void) { }
> +static inline int dlm_create_debug_file(struct dlm_ls *ls) { return 0; }
> +static inline void dlm_delete_debug_file(struct dlm_ls *ls) { }
> +#endif
> +
>  #endif				/* __DLM_INTERNAL_DOT_H__ */
>  
> diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
> index 3915b8e..7bc6ad9 100644
> --- a/fs/dlm/lock.c
> +++ b/fs/dlm/lock.c
> @@ -88,7 +88,6 @@ static void __receive_convert_reply(struct dlm_rsb *r, struct dlm_lkb *lkb,
>  static int receive_extralen(struct dlm_message *ms);
>  static void do_purge(struct dlm_ls *ls, int nodeid, int pid);
>  static void del_timeout(struct dlm_lkb *lkb);
> -void dlm_timeout_warn(struct dlm_lkb *lkb);
>  
>  /*
>   * Lock compatibilty matrix - thanks Steve
> diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
> index 6353a83..b99485b 100644
> --- a/fs/dlm/lockspace.c
> +++ b/fs/dlm/lockspace.c
> @@ -24,14 +24,6 @@
>  #include "recover.h"
>  #include "requestqueue.h"
>  
> -#ifdef CONFIG_DLM_DEBUG
> -int dlm_create_debug_file(struct dlm_ls *ls);
> -void dlm_delete_debug_file(struct dlm_ls *ls);
> -#else
> -static inline int dlm_create_debug_file(struct dlm_ls *ls) { return 0; }
> -static inline void dlm_delete_debug_file(struct dlm_ls *ls) { }
> -#endif
> -
>  static int			ls_count;
>  static struct mutex		ls_lock;
>  static struct list_head		lslist;
> diff --git a/fs/dlm/main.c b/fs/dlm/main.c
> index eca2907..58487fb 100644
> --- a/fs/dlm/main.c
> +++ b/fs/dlm/main.c
> @@ -18,16 +18,6 @@
>  #include "memory.h"
>  #include "config.h"
>  
> -#ifdef CONFIG_DLM_DEBUG
> -int dlm_register_debugfs(void);
> -void dlm_unregister_debugfs(void);
> -#else
> -static inline int dlm_register_debugfs(void) { return 0; }
> -static inline void dlm_unregister_debugfs(void) { }
> -#endif
> -int dlm_netlink_init(void);
> -void dlm_netlink_exit(void);
> -
>  static int __init init_dlm(void)
>  {
>  	int error;
