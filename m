Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbYIRTwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbYIRTwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 15:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbYIRTwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 15:52:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755047AbYIRTwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 15:52:04 -0400
Date: Thu, 18 Sep 2008 12:51:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: Print cpuid along with the timestamp with
 CONFIG_PRINTK_TIME
Message-Id: <20080918125123.1a76978f.akpm@linux-foundation.org>
In-Reply-To: <20080918193720.GA21915@localdomain>
References: <20080918193720.GA21915@localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008 12:37:20 -0700
Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> I found it useful to have the cpuid of the printing cpu along with the
> timestamp -- especially while debugging hangs during bootups.
> 
> I don't know why this hasn't been implemened in the kernel yet, and
> cannot think of a strong reason not to have it.  Yes, the cpuid prefix will
> take 5 more characters per line,  but having  the cpuid info is worth it,
> I think.
> 
> Thanks,
> Kiran
> 
> ---
> 
> 
> Add cpuid information to printk if CONFIG_PRINTK_TIME is enabled.
> This information is useful to debug hangs and bootup issues.
> 
> Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
> 
> Index: linux-git/kernel/printk.c
> ===================================================================
> --- linux-git.orig/kernel/printk.c	2008-09-16 15:37:48.000000000 -0700
> +++ linux-git/kernel/printk.c	2008-09-18 12:27:10.489662938 -0700
> @@ -739,9 +739,10 @@ asmlinkage int vprintk(const char *fmt, 
>  
>  				t = cpu_clock(printk_cpu);
>  				nanosec_rem = do_div(t, 1000000000);
> -				tlen = sprintf(tbuf, "[%5lu.%06lu] ",
> +				tlen = sprintf(tbuf, "[%5lu.%06lu:%d] ",
>  						(unsigned long) t,
> -						nanosec_rem / 1000);
> +						nanosec_rem / 1000,
> +						printk_cpu);
>  
>  				for (tp = tbuf; tp < tbuf + tlen; tp++)
>  					emit_log_char(*tp);

Yes, I guess it could be useful sometimes.  otoh anyone who is down at
that level of detail and is using printk to debug something can add
their own %d/smp_processor_id().

Your patch illogically ties the cpu-id-printing feature to the
printk.time feature.  I guess that's liveable with, but
Documentation/kernel-parameters.txt should be updated.

Anyone who was parsing that output might get a shock, but that's
liveable with too.  Probably their parser will continue to work anwyay.


I don't know whether the usefulness of this feature outweighs its
various costs.  Input is sought.
