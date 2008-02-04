Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbYBDVQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbYBDVQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbYBDVQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:16:42 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40145 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752970AbYBDVQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:16:41 -0500
Date: Mon, 4 Feb 2008 13:15:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Whine about suspicious return values from module's
 ->init() hook
Message-Id: <20080204131555.d7618a3a.akpm@linux-foundation.org>
In-Reply-To: <20080204154215.GA26618@localhost.sw.ru>
References: <20080204154215.GA26618@localhost.sw.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008 18:42:15 +0300
Alexey Dobriyan <adobriyan@sw.ru> wrote:

> One head-scratching session could be noticeably shorter with this patch...
> 

Sorry, this is not an adequate description of why you think this patch
should be merged.

> ---
> 
>  kernel/module.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2171,6 +2171,12 @@ sys_init_module(void __user *umod,
>  		wake_up(&module_wq);
>  		return ret;
>  	}
> +	if (ret > 0) {
> +		printk(KERN_WARNING "%s: '%s'->init suspiciously returned %d\n"
> +		       KERN_WARNING "%s: loading module anyway...\n",
> +		       __func__, mod->name, ret,
> +		       __func__);
> +	}
>  
>  	/* Now it's a first class citizen! */
>  	mutex_lock(&module_mutex);

So we add a debug statement to detect a module init function which returns
positive non-zero values, which module init functions are not supposed to
do.

Fair enough.  But a) the printk could state that more clearly and b) there
should be a comment in the code so that a developer (at whom this patch is
targetted) can go in and find out exactly what he did wrong.

