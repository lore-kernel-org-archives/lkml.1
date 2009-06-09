Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbZFIRH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbZFIRH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 13:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbZFIRHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 13:07:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51823 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbZFIRHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 13:07:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH 05/27] score: create head files cache.h cacheflush.h checksum.h cputime.h current.h
Date: Tue, 9 Jun 2009 19:07:16 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
References: <OF45377EDE.71658F7D-ON482575D0.0023440F-482575D0.0023B614@sunplusct.com>
In-Reply-To: <OF45377EDE.71658F7D-ON482575D0.0023440F-482575D0.0023B614@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906091907.17042.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+pLRSDBnt1v4gvhqUY0gvrCFMYuwmgO3b3HxU
 n7pbrn0jGhhZV+kefTWf57evcSnNwvFw6z+WeeTI9kT1a5jB2z
 3V9zG13hffHtqXeVdgU7g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009, liqin.chen@sunplusct.com wrote:
> diff --git a/arch/score/include/asm/cacheflush.h 
> b/arch/score/include/asm/cacheflush.h
> +extern void (*flush_cache_all)(void);
> +extern void (*flush_cache_mm)(struct mm_struct *mm);
> +extern void (*flush_cache_range)(struct vm_area_struct *vma,
> +                               unsigned long start, unsigned long end);
> +extern void (*flush_cache_page)(struct vm_area_struct *vma,
> +                               unsigned long page, unsigned long pfn);
> +extern void (*flush_cache_sigtramp)(unsigned long addr);
> +extern void (*flush_icache_all)(void);
> +extern void (*flush_icache_range)(unsigned long start, unsigned long 
> end);
> +extern void (*flush_data_cache_page)(unsigned long addr);

This is a somewhat unusual way to express these functions. It seems
that you only have one implementation for each of them, so I wonder
why you keep them as function pointers. Do you plan to add more CPUs
in the future that do these differently?

> --- /dev/null
> +++ b/arch/score/include/asm/current.h
> @@ -0,0 +1,15 @@
> +#ifndef _ASM_SCORE_CURRENT_H
> +#define _ASM_SCORE_CURRENT_H
> +
> +#include <linux/thread_info.h>
> +
> +struct task_struct;
> +
> +static inline struct task_struct *get_current(void)
> +{
> +       return current_thread_info()->task;
> +}
> +
> +#define current        get_current()
> +
> +#endif /* _ASM_SCORE_CURRENT_H */

This is basically the asm-generic version, so you could just use that
instead.

	Arnd <><
