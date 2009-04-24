Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbZDXHFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbZDXHFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 03:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbZDXHFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 03:05:33 -0400
Received: from atlanta.zankel.net ([69.61.78.146]:1162 "EHLO
	atlanta.zankel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbZDXHFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 03:05:32 -0400
Message-ID: <49F164B8.9000504@zankel.net>
Date: Fri, 24 Apr 2009 00:05:28 -0700
From: Chris Zankel <chris@zankel.net>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, David Howells <dhowells@redhat.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Helge Deller <deller@gmx.de>, Hirokazu Takata <takata@linux-m32r.org>,
       Jeff Dike <jdike@addtoit.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ptrace: remove PT_DTRACE from avr32, mn10300, parisc,
 s390, sh, xtensa
References: <20090423193206.GA14885@redhat.com>
In-Reply-To: <20090423193206.GA14885@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Chris Zankel <chris@zankel.net>

Cheers!
-Chris

Oleg Nesterov wrote:
> avr32, mn10300, parisc, s390, sh, xtensa:
> 
> they never set PT_DTRACE, but clear it after do_execve().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
>  arch/xtensa/kernel/process.c      |    5 -----
> --- PTRACE/arch/xtensa/kernel/process.c~DT_2_CLEAR	2009-04-06 00:03:37.000000000 +0200
> +++ PTRACE/arch/xtensa/kernel/process.c	2009-04-22 21:48:13.000000000 +0200
> @@ -331,11 +331,6 @@ long xtensa_execve(char __user *name, ch
>  	if (IS_ERR(filename))
>  		goto out;
>  	error = do_execve(filename, argv, envp, regs);
> -	if (error == 0) {
> -		task_lock(current);
> -		current->ptrace &= ~PT_DTRACE;
> -		task_unlock(current);
> -	}
>  	putname(filename);
>  out:
>  	return error;

