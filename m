Return-Path: <linux-kernel-owner+w=401wt.eu-S1423007AbXBBFGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423007AbXBBFGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 00:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423017AbXBBFGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 00:06:11 -0500
Received: from smtp.osdl.org ([65.172.181.24]:32855 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423007AbXBBFGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 00:06:10 -0500
Date: Thu, 1 Feb 2007 21:05:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: rth@twiddle.net, linux-kernel@vger.kernel.org, alpha@gentoo.org
Subject: Re: epoll handling in the alpha port
Message-Id: <20070201210555.ac637298.akpm@linux-foundation.org>
In-Reply-To: <200702011520.46723.vapier@gentoo.org>
References: <200702011520.46723.vapier@gentoo.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007 15:20:45 -0500 Mike Frysinger <vapier@gentoo.org> wrote:

> the alpha linux port differs from all others when it comes to the epoll 
> functions in that it uses '__NR_sys_epoll_XXX' instead of '__NR_epoll_XXX' in 
> the asm/unistd.h header ... the trouble with this is that glibc maps the 
> function name directly to an __NR_ define, so when it maps 
> like 'epoll_create', it expects '__NR_epoll_create' (which it gets with all 
> other architectures)
> 
> is there some obvious thing i'm missing here ?  or is the attached patch OK ?
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> --- a/include/asm-alpha/unistd.h
> +++ b/include/asm-alpha/unistd.h
> @@ -342,9 +342,9 @@
>  #define __NR_io_cancel			402
>  #define __NR_exit_group			405
>  #define __NR_lookup_dcookie		406
> -#define __NR_sys_epoll_create		407
> -#define __NR_sys_epoll_ctl		408
> -#define __NR_sys_epoll_wait		409
> +#define __NR_epoll_create		407
> +#define __NR_epoll_ctl		408
> +#define __NR_epoll_wait		409
>  #define __NR_remap_file_pages		410
>  #define __NR_set_tid_address		411
>  #define __NR_restart_syscall		412

It might be to late to fix this - we risk breaking userspace which worked
around it.

It would be safer to add the correct definitions while leaving the old ones
in place.

