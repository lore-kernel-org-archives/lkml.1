Return-Path: <linux-kernel-owner+w=401wt.eu-S934597AbYCEAEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934597AbYCEAEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbYCEAEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:04:32 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:51679 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbYCEAEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:04:31 -0500
Date: Tue, 4 Mar 2008 16:03:23 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: pierre.peiffer@bull.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24-mm1 8/8] (resend) IPC: consolidate all
 xxxctl_down() functions
Message-Id: <20080304160323.bb01246b.randy.dunlap@oracle.com>
In-Reply-To: <20080212163052.683140178@bull.net>
References: <20080212161340.200976067@bull.net>
	<20080212163052.683140178@bull.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
kernel-doc here causes a warning in 2.6.25-rc3-mm1:

Warning(linux-2.6.25-rc3-mm1//ipc/util.c:845): No description found for parameter 'extrat_perm'



On Tue, 12 Feb 2008 17:13:48 +0100 pierre.peiffer@bull.net wrote:

> Index: b/ipc/util.c
> ===================================================================
> --- a/ipc/util.c
> +++ b/ipc/util.c
> @@ -824,6 +824,57 @@ void ipc_update_perm(struct ipc64_perm *
>  		| (in->mode & S_IRWXUGO);
>  }
>  
> +/**
> + * ipcctl_pre_down - retrieve an ipc and check permissions for some IPC_XXX cmd
> + * @ids:  the table of ids where to look for the ipc
> + * @id:   the id of the ipc to retrieve
> + * @cmd:  the cmd to check
> + * @perm: the permission to set
> + * @extra_perm: one extra permission parameter used by msq

change this ^^^^^ or ... (preferably the next changes)

> + *
> + * This function does some common audit and permissions check for some IPC_XXX
> + * cmd and is called from semctl_down, shmctl_down and msgctl_down.
> + * It must be called without any lock held and
> + *  - retrieves the ipc with the given id in the given table.
> + *  - performs some audit and permission check, depending on the given cmd
> + *  - returns the ipc with both ipc and rw_mutex locks held in case of success
> + *    or an err-code without any lock held otherwise.
> + */
> +struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
> +				      struct ipc64_perm *perm, int extrat_perm)

that last parameter and ...

> +{
...
> +}
> +
>  #ifdef __ARCH_WANT_IPC_PARSE_VERSION
>  
>  
> Index: b/ipc/util.h
> ===================================================================
> --- a/ipc/util.h
> +++ b/ipc/util.h
> @@ -113,6 +113,8 @@ struct kern_ipc_perm *ipc_lock(struct ip
>  void kernel_to_ipc64_perm(struct kern_ipc_perm *in, struct ipc64_perm *out);
>  void ipc64_perm_to_ipc_perm(struct ipc64_perm *in, struct ipc_perm *out);
>  void ipc_update_perm(struct ipc64_perm *in, struct kern_ipc_perm *out);
> +struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
> +				      struct ipc64_perm *perm, int extrat_perm);

that last parameter.

>  
>  #if defined(__ia64__) || defined(__x86_64__) || defined(__hppa__) || defined(__XTENSA__)
>    /* On IA-64, we always use the "64-bit version" of the IPC structures.  */ 


---
~Randy
