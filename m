Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbXIZNbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbXIZNbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 09:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbXIZNbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 09:31:24 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49526 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbXIZNbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 09:31:23 -0400
Message-ID: <46FA5F26.2030100@fr.ibm.com>
Date: Wed, 26 Sep 2007 15:31:18 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove unused member from nsproxy
References: <46FA5B39.1010204@openvz.org>
In-Reply-To: <46FA5B39.1010204@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
> The nslock spinlock is not used in the kernel at all. 

it's also useless now that you have put some RCU rules around it.
right ? 

C.

> Remove it.
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
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
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
> 

