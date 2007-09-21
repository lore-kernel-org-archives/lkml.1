Return-Path: <linux-kernel-owner+w=401wt.eu-S1760551AbXIURGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760551AbXIURGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 13:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbXIURGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 13:06:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:42851 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbXIURGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 13:06:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=PIu8ZHNtW3/HwYdvCfpFVQUMo3vd9LS1wwJt4lQK5AyBENmzyOjAHaA2fI+bPA3f7q6d/dJvuzNnrE+xHf1gcXR0C9xgd9hlx6jSPJd5LOGn6D85wqHLaVCdPK0EY/3rRMoZKSmc+nhxM0Klii95vWKMY2L9wBL4sfZkzVwDbnI=
Date: Fri, 21 Sep 2007 21:05:48 +0400
To: linux-kernel@vger.kernel.org
Cc: rientjes@google.com, andrea@suse.de, clameter@sgi.com
Subject: Re: + oom-move-prototypes-to-appropriate-header-file.patch added to -mm tree
Message-ID: <20070921170548.GA1857@martell.zuzino.mipt.ru>
References: <200709210910.l8L9AttS028186@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709210910.l8L9AttS028186@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 02:10:55AM -0700, akpm@linux-foundation.org wrote:
> Move the OOM killer's extern function prototypes to include/linux/oom.h and
> include it where necessary.
> 
> Cc: Andrea Arcangeli <andrea@suse.de>
> Acked-by: Christoph Lameter <clameter@sgi.com>

NAK. Target in corresponding Kbuild is wrong. sched.h is overkill.
Could we please also drop extern's while in protos?

> --- a/drivers/char/sysrq.c~oom-move-prototypes-to-appropriate-header-file
> +++ a/drivers/char/sysrq.c
> @@ -36,6 +36,7 @@
>  #include <linux/kexec.h>
>  #include <linux/irq.h>
>  #include <linux/hrtimer.h>
> +#include <linux/oom.h>
>  
>  #include <asm/ptrace.h>
>  #include <asm/irq_regs.h>
> diff -puN include/linux/oom.h~oom-move-prototypes-to-appropriate-header-file include/linux/oom.h
> --- a/include/linux/oom.h~oom-move-prototypes-to-appropriate-header-file
> +++ a/include/linux/oom.h
> @@ -1,10 +1,19 @@
>  #ifndef __INCLUDE_LINUX_OOM_H
>  #define __INCLUDE_LINUX_OOM_H
>  
> +#include <linux/sched.h>
> +
>  /* /proc/<pid>/oom_adj set to -17 protects from the oom-killer */
>  #define OOM_DISABLE (-17)
>  /* inclusive */
>  #define OOM_ADJUST_MIN (-16)
>  #define OOM_ADJUST_MAX 15
>  
> -#endif
> +#ifdef __KERNEL__
> +
> +extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order);
> +extern int register_oom_notifier(struct notifier_block *nb);
> +extern int unregister_oom_notifier(struct notifier_block *nb);
