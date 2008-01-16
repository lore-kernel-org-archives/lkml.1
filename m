Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbYAPCPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbYAPCPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 21:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYAPCO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 21:14:57 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:40270 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbYAPCO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 21:14:56 -0500
Date: Tue, 15 Jan 2008 21:14:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Frank Rowand <frank.rowand@am.sony.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH 3/4] RT: remove finish_arch_switch
Message-ID: <20080116021409.GG30532@goodmis.org>
References: <1200435646.4092.18.camel@bx740>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200435646.4092.18.camel@bx740>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 02:20:46PM -0800, Frank Rowand wrote:
> From: Frank Rowand <frank.rowand@am.sony.com>
> 
> 
> Index: linux-2.6.24-rc7/include/asm-mips/mach-tx49xx/cpu-feature-overrides.h
> ===================================================================
> --- linux-2.6.24-rc7.orig/include/asm-mips/mach-tx49xx/cpu-feature-overrides.h
> +++ linux-2.6.24-rc7/include/asm-mips/mach-tx49xx/cpu-feature-overrides.h
> @@ -1,6 +1,13 @@
>  #ifndef __ASM_MACH_TX49XX_CPU_FEATURE_OVERRIDES_H
>  #define __ASM_MACH_TX49XX_CPU_FEATURE_OVERRIDES_H
>  
> +/* finish_arch_switch_empty is defined if we know finish_arch_switch() will
> + * be empty, based on the lack of features defined in this file.  This is
> + * needed because config preempt will barf in kernel/sched.c ifdef
> + * finish_arch_switch
> + */
> +#define finish_arch_switch_empty
> +
>  #define cpu_has_llsc	1
>  #define cpu_has_64bits	1
>  #define cpu_has_inclusive_pcaches	0
> Index: linux-2.6.24-rc7/include/asm-mips/system.h
> ===================================================================
> --- linux-2.6.24-rc7.orig/include/asm-mips/system.h
> +++ linux-2.6.24-rc7/include/asm-mips/system.h
> @@ -70,6 +70,8 @@ do {									\
>  	(last) = resume(prev, next, task_thread_info(next));		\
>  } while (0)
>  
> +/* preempt kernel barfs in kernel/sched.c ifdef finish_arch_switch */
> +#ifndef finish_arch_switch_empty

I'll take this patch for now, but currently it looks like a hack. I know
you said that, but I'm hoping someone will come up with a better
solution.

Thanks,

-- Steve

>  #define finish_arch_switch(prev)					\
>  do {									\
>  	if (cpu_has_dsp)						\
> @@ -77,6 +79,7 @@ do {									\
>  	if (cpu_has_userlocal)						\
>  		write_c0_userlocal(current_thread_info()->tp_value);	\
>  } while (0)
> +#endif
>  
>  static inline unsigned long __xchg_u32(volatile int * m, unsigned int val)
>  {
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
