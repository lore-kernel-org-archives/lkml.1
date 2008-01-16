Return-Path: <linux-kernel-owner+w=401wt.eu-S1758204AbYAPCTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbYAPCTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 21:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756353AbYAPCT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 21:19:27 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:57435 "EHLO
	mail79-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756386AbYAPCT0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 21:19:26 -0500
X-BigFish: V
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 3/4] RT: remove finish_arch_switch
Date: Tue, 15 Jan 2008 18:17:44 -0800
Message-ID: <884020C16A0AFF4D8A8B7800EA0C98870FD5F7@ussdixms03.am.sony.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/4] RT: remove finish_arch_switch
Thread-Index: AchX5X2zqfboJfUqT6a1tyisQpPSlwAAHy3E
References: <1200435646.4092.18.camel@bx740> <20080116021409.GG30532@goodmis.org>
From: "Rowand, Frank" <frank.rowand@us.sony.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, <mingo@redhat.com>, <tglx@linutronix.de>
X-OriginalArrivalTime: 16 Jan 2008 02:19:19.0631 (UTC) FILETIME=[336375F0:01C857E6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve,

Thanks, I'll bring this up over on the linux-mips list to see how they
really want to handle it.

-Frank


-----Original Message-----
From: Steven Rostedt [mailto:rostedt@goodmis.org]
Sent: Tue 1/15/2008 6:14 PM
To: Rowand, Frank
Cc: linux-kernel@vger.kernel.org; mingo@redhat.com; tglx@linutronix.de
Subject: Re: [PATCH 3/4] RT: remove finish_arch_switch
 
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



