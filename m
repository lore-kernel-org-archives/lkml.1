Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbYGOO6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbYGOO6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 10:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYGOO6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 10:58:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34533 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbYGOO6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:58:04 -0400
Subject: Re: [PATCH] x86: Introducing asm-x86/syscalls.h
From: David Woodhouse <dwmw2@infradead.org>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>
In-Reply-To: <1216127174.30096.3.camel@jaswinder.satnam>
References: <1216114072.21749.1.camel@jaswinder.satnam>
	 <1216127174.30096.3.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 07:58:03 -0700
Message-Id: <1216133883.27455.252.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 18:36 +0530, Jaswinder Singh wrote:
> Updated Patch:
> 
> declaring arch-dependent syscalls for x86 under one hood

Thanks Jaswinder, this looks quite sensible in general and should go
some way towards making sparse shut up about undeclared functions. You
should Cc Ingo though.

I don't like this bit though:

> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -65,6 +65,10 @@ struct getcpu_cache;
>  #include <linux/quota.h>
>  #include <linux/key.h>
>  
> +#ifdef CONFIG_X86
> +#include <asm/syscalls.h>
> +#endif
> +
>  asmlinkage long sys_time(time_t __user *tloc);
>  asmlinkage long sys_stime(time_t __user *tptr);
>  asmlinkage long sys_gettimeofday(struct timeval __user *tv,

We're going to want to do this for all architectures, aren't we? Perhaps
it's better to provide <asm/syscalls.h> for all architectures from the
beginning, and not bother with the ifdef? Or if you must have an ifdef,
perhaps make it on something like ARCH_HAS_ASM_SYSCALLS_H rather than
having to change it every time an architecture adds its own
<asm/syscalls.h> file?

-- 
dwmw2

