Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbYEVFIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbYEVFIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 01:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYEVFIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 01:08:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752139AbYEVFIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 01:08:13 -0400
Date: Wed, 21 May 2008 22:06:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH -mm] remove node_ prefix_from ns subsystem
Message-Id: <20080521220657.12e8e8c9.akpm@linux-foundation.org>
In-Reply-To: <48344409.9090903@fr.ibm.com>
References: <48344409.9090903@fr.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 17:47:21 +0200 Cedric Le Goater <clg@fr.ibm.com> wrote:

> From: Cedric Le Goater <clg@fr.ibm.com>
> 
> This is a slight change in the namespace cgroup subsystem api.
> 

What are the reasons for making this change?

> ---
>  kernel/cgroup.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: 2.6.26-rc2-mm1/kernel/cgroup.c
> ===================================================================
> --- 2.6.26-rc2-mm1.orig/kernel/cgroup.c
> +++ 2.6.26-rc2-mm1/kernel/cgroup.c
> @@ -2903,7 +2903,7 @@ int cgroup_clone(struct task_struct *tsk
>  	cg = tsk->cgroups;
>  	parent = task_cgroup(tsk, subsys->subsys_id);
>  
> -	snprintf(nodename, MAX_CGROUP_TYPE_NAMELEN, "node_%d", tsk->pid);
> +	snprintf(nodename, MAX_CGROUP_TYPE_NAMELEN, "%d", tsk->pid);
>  
>  	/* Pin the hierarchy */
>  	atomic_inc(&parent->root->sb->s_active);

This is user-visible, isn't it?  Been there since October.  How can we
safely change it now?

