Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbZJENM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbZJENM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 09:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758291AbZJENM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 09:12:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56772 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757AbZJENM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 09:12:56 -0400
Subject: Re: [PATCH 02/21] ftrace.c: Add #define pr_fmt(fmt) KBUILD_MODNAME
 ": " fmt
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
In-Reply-To: <9b377eefae9e28c599dd4a17bdc81172965e9931.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
	 <9b377eefae9e28c599dd4a17bdc81172965e9931.1254701151.git.joe@perches.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 05 Oct 2009 09:10:56 -0400
Message-Id: <1254748256.13160.0.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-04 at 17:53 -0700, Joe Perches wrote:
> Remove prefixes from pr_<level>, use pr_fmt(fmt)
> No change in output.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/x86/kernel/ftrace.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 9dbb527..25e6f5f 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -9,6 +9,8 @@
>   * the dangers of modifying code on the run.
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

What does KBUILD_MODNAME give us in the core code? This file does not
belong to any module and is only compiled into the core kernel.

-- Steve

> +
>  #include <linux/spinlock.h>
>  #include <linux/hardirq.h>
>  #include <linux/uaccess.h>
> @@ -336,15 +338,15 @@ int __init ftrace_dyn_arch_init(void *data)
>  
>  	switch (faulted) {
>  	case 0:
> -		pr_info("ftrace: converting mcount calls to 0f 1f 44 00 00\n");
> +		pr_info("converting mcount calls to 0f 1f 44 00 00\n");
>  		memcpy(ftrace_nop, ftrace_test_p6nop, MCOUNT_INSN_SIZE);
>  		break;
>  	case 1:
> -		pr_info("ftrace: converting mcount calls to 66 66 66 66 90\n");
> +		pr_info("converting mcount calls to 66 66 66 66 90\n");
>  		memcpy(ftrace_nop, ftrace_test_nop5, MCOUNT_INSN_SIZE);
>  		break;
>  	case 2:
> -		pr_info("ftrace: converting mcount calls to jmp . + 5\n");
> +		pr_info("converting mcount calls to jmp . + 5\n");
>  		memcpy(ftrace_nop, ftrace_test_jmp, MCOUNT_INSN_SIZE);
>  		break;
>  	}

