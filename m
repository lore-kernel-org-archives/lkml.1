Return-Path: <linux-kernel-owner+w=401wt.eu-S1758658AbXIZN2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658AbXIZN2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 09:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbXIZN2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 09:28:15 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45463 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbXIZN2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 09:28:13 -0400
Date: Wed, 26 Sep 2007 08:28:10 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, Serge Hallyn <serue@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove unused member from nsproxy
Message-ID: <20070926132810.GA27366@sergelap.austin.ibm.com>
References: <46FA5B39.1010204@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FA5B39.1010204@openvz.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Emelyanov (xemul@openvz.org):
> The nslock spinlock is not used in the kernel at all. 
> Remove it.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
> 
> diff --git a/include/linux/init_task.h b/include/linux/init_task.h
> index a3f2541..cae35b6 100644
> --- a/include/linux/init_task.h
> +++ b/include/linux/init_task.h
> @@ -73,7 +73,6 @@ extern struct nsproxy init_nsproxy;
>  #define INIT_NSPROXY(nsproxy) {						\
>  	.pid_ns		= &init_pid_ns,					\
>  	.count		= ATOMIC_INIT(1),				\
> -	.nslock		= __SPIN_LOCK_UNLOCKED(nsproxy.nslock),		\
>  	.uts_ns		= &init_uts_ns,					\
>  	.mnt_ns		= NULL,						\
>  	INIT_NET_NS(net_ns)                                             \
> diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
> index 4d564d8..0e66b57 100644
> --- a/include/linux/nsproxy.h
> +++ b/include/linux/nsproxy.h
> @@ -23,7 +23,6 @@ struct pid_namespace;
>   */
>  struct nsproxy {
>  	atomic_t count;
> -	spinlock_t nslock;
>  	struct uts_namespace *uts_ns;
>  	struct ipc_namespace *ipc_ns;
>  	struct mnt_namespace *mnt_ns;
