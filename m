Return-Path: <linux-kernel-owner+w=401wt.eu-S1760955AbXJDUoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760955AbXJDUoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 16:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757679AbXJDUoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 16:44:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49991 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757649AbXJDUoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 16:44:24 -0400
Date: Thu, 4 Oct 2007 13:43:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: w@1wt.eu, apw@shadowen.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] printk: add KERN_CONT annotation
Message-Id: <20071004134320.a9160974.akpm@linux-foundation.org>
In-Reply-To: <20071002051852.GC28345@elte.hu>
References: <20070928105345.GC18163@shadowen.org>
	<20071001064448.GA4239@elte.hu>
	<20071001003007.4e90143b.akpm@linux-foundation.org>
	<20071002043408.GM10199@1wt.eu>
	<20071002051852.GC28345@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007 07:18:52 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> printk: add the KERN_CONT annotation (which is empty string but via 
> which checkpatch.pl can notice that the lacking KERN_ level is fine). 
> This useful for multiple calls of hand-crafted printk output done by 
> early debug code or similar.
> 

I like it.  Sort of self-documenting notation.

> 
> Index: linux/include/linux/kernel.h
> ===================================================================
> --- linux.orig/include/linux/kernel.h
> +++ linux/include/linux/kernel.h
> @@ -61,6 +61,13 @@ extern const char linux_proc_banner[];
>  #define	KERN_INFO	"<6>"	/* informational			*/
>  #define	KERN_DEBUG	"<7>"	/* debug-level messages			*/
>  
> +/*
> + * Annotation for a "continued" line of log printout (only done after a
> + * line that had no enclosing \n). Only to be used by core/arch code
> + * during early bootup (a continued line is not SMP-safe otherwise).
> + */
> +#define	KERN_CONT	""
> +
>  extern int console_printk[];
>  
>  #define console_loglevel (console_printk[0])
> Index: linux/kernel/sched.c

I get rejects from the sched.c hunk and that's your stuff anwyay, so I
dropped that bit.

