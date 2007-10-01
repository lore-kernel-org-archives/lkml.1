Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbXJANWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbXJANWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 09:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757532AbXJANTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 09:19:47 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:42198 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520AbXJANTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 09:19:45 -0400
Date: Mon, 1 Oct 2007 08:19:21 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, Cedric Le Goater <clg@fr.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Make initializer for statically declared krefs
Message-ID: <20071001131921.GA30599@sergelap.austin.ibm.com>
References: <4700CB8C.7030007@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4700CB8C.7030007@openvz.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Emelyanov (xemul@openvz.org):
> Since the struct kref already has the _get, _put and _init 
> routines, this seems useful to have an initializer for those
> statically declared (like for atomic_t or spinlock_t).
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

Sure.

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
> 
> diff --git a/include/linux/kref.h b/include/linux/kref.h
> index 6fee353..a84c582 100644
> --- a/include/linux/kref.h
> +++ b/include/linux/kref.h
> @@ -24,6 +24,8 @@ struct kref {
>  	atomic_t refcount;
>  };
> 
> +#define INIT_KREF(count)	{ .refcount = ATOMIC_INIT(count), }
> +
>  void kref_init(struct kref *kref);
>  void kref_get(struct kref *kref);
>  int kref_put(struct kref *kref, void (*release) (struct kref *kref));
> diff --git a/init/version.c b/init/version.c
> index 9d17d70..53d2ca7 100644
> --- a/init/version.c
> +++ b/init/version.c
> @@ -19,9 +19,7 @@
>  int version_string(LINUX_VERSION_CODE);
> 
>  struct uts_namespace init_uts_ns = {
> -	.kref = {
> -		.refcount	= ATOMIC_INIT(2),
> -	},
> +	.kref = INIT_KREF(2),
>  	.name = {
>  		.sysname	= UTS_SYSNAME,
>  		.nodename	= UTS_NODENAME,
> diff --git a/ipc/util.c b/ipc/util.c
> index fd29246..526aa14 100644
> --- a/ipc/util.c
> +++ b/ipc/util.c
> @@ -45,9 +45,7 @@ struct ipc_proc_iface {
>  };
> 
>  struct ipc_namespace init_ipc_ns = {
> -	.kref = {
> -		.refcount	= ATOMIC_INIT(2),
> -	},
> +	.kref = INIT_KREF(2),
>  };
> 
>  static struct ipc_namespace *clone_ipc_ns(struct ipc_namespace *old_ns)
> diff --git a/kernel/pid.c b/kernel/pid.c
> index d7388d7..e9d3ff1 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -69,9 +69,7 @@ static inline int mk_pid(struct pid_name
>   * the scheme scales to up to 4 million PIDs, runtime.
>   */
>  struct pid_namespace init_pid_ns = {
> -	.kref = {
> -		.refcount       = ATOMIC_INIT(2),
> -	},
> +	.kref = INIT_KREF(2),
>  	.pidmap = {
>  		[ 0 ... PIDMAP_ENTRIES-1] = { ATOMIC_INIT(BITS_PER_PAGE), NULL }
>  	},
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 7af90fc..33d21e0 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -11,9 +11,7 @@
>  #include <linux/user_namespace.h>
> 
>  struct user_namespace init_user_ns = {
> -	.kref = {
> -		.refcount	= ATOMIC_INIT(2),
> -	},
> +	.kref = INIT_KREF(2),
>  	.root_user = &root_user,
>  };
