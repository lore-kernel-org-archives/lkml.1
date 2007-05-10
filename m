Return-Path: <linux-kernel-owner+w=401wt.eu-S1762686AbXEJXse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762686AbXEJXse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 19:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbXEJXs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 19:48:28 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755076AbXEJXs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 19:48:27 -0400
Date: Thu, 10 May 2007 16:48:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use defines in sys_getpriority/sys_setpriority
Message-Id: <20070510164819.9248c4ab.akpm@linux-foundation.org>
In-Reply-To: <20070510172223.898755987@mvista.com>
References: <20070510172223.898755987@mvista.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 10:22:23 -0700
Daniel Walker <dwalker@mvista.com> wrote:

> Switch to the defines for these two checks, instead of hard
> coding the values.
> 
> Signed-Off-By: Daniel Walker <dwalker@mvista.com>
> 
> ---
>  kernel/sys.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.21/kernel/sys.c
> ===================================================================
> --- linux-2.6.21.orig/kernel/sys.c
> +++ linux-2.6.21/kernel/sys.c
> @@ -598,7 +598,7 @@ asmlinkage long sys_setpriority(int whic
>  	int error = -EINVAL;
>  	struct pid *pgrp;
>  
> -	if (which > 2 || which < 0)
> +	if (which > PRIO_USER || which < PRIO_PROCESS)
>  		goto out;
>  
>  	/* normalize: avoid signed division (rounding problems) */
> @@ -662,7 +662,7 @@ asmlinkage long sys_getpriority(int whic
>  	long niceval, retval = -ESRCH;
>  	struct pid *pgrp;
>  
> -	if (which > 2 || which < 0)
> +	if (which > PRIO_USER || which < PRIO_PROCESS)
>  		return -EINVAL;
>  
>  	read_lock(&tasklist_lock);

I added this:

--- a/kernel/sys.c~use-defines-in-sys_getpriority-sys_setpriority-fix
+++ a/kernel/sys.c
@@ -14,6 +14,7 @@
 #include <linux/prctl.h>
 #include <linux/highuid.h>
 #include <linux/fs.h>
+#include <linux/resource.h>
 #include <linux/kernel.h>
 #include <linux/kexec.h>
 #include <linux/workqueue.h>
_

