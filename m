Return-Path: <linux-kernel-owner+w=401wt.eu-S1759928AbXI0Tkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928AbXI0Tkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 15:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758247AbXI0Tk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 15:40:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:41421 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736AbXI0Tk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 15:40:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=PkMFoP7OY2Zmqy9SecHudHANjCcMiBSrDMj4hKj+NnvLwbkFRVKrkaQgF52meaYz+hXE0EgAqWD9Nm+J7sS6RINkOK6YJ3FjRX9TD0YZq2/tHupA6JUC5cQfGQgyozas2UWgZduTe/R/CmK2ZRkeEPIpMfb5FlMQQ1+e+t7cioc=
Date: Thu, 27 Sep 2007 23:40:21 +0400
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rientjes@google.com, andrea@suse.de,
       clameter@sgi.com
Subject: Re: + oom-prevent-including-schedh-in-header-file.patch added to -mm tree
Message-ID: <20070927194021.GB1748@martell.zuzino.mipt.ru>
References: <200709262010.l8QKAxd0001730@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709262010.l8QKAxd0001730@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It's not necessary to include all of linux/sched.h in linux/oom.h.  Instead,
> simply include prototypes for the relevant structs and include linux/types.h
> for gfp_t.
> 
> Cc: Andrea Arcangeli <andrea@suse.de>
> Cc: Christoph Lameter <clameter@sgi.com>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

OK.

> --- a/include/linux/oom.h~oom-prevent-including-schedh-in-header-file
> +++ a/include/linux/oom.h
> @@ -1,8 +1,6 @@
>  #ifndef __INCLUDE_LINUX_OOM_H
>  #define __INCLUDE_LINUX_OOM_H
>  
> -#include <linux/sched.h>
> -
>  /* /proc/<pid>/oom_adj set to -17 protects from the oom-killer */
>  #define OOM_DISABLE (-17)
>  /* inclusive */
> @@ -11,6 +9,11 @@
>  
>  #ifdef __KERNEL__
>  
> +#include <linux/types.h>
> +
> +struct zonelist;
> +struct notifier_block;
