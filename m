Return-Path: <linux-kernel-owner+w=401wt.eu-S1760371AbXHUOBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371AbXHUOBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 10:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbXHUOBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 10:01:36 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:49032 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758598AbXHUOBL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 10:01:11 -0400
Date: Tue, 21 Aug 2007 10:01:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Hirokazu Takata <takata@linux-m32r.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-m32r@ml.linux-m32r.org
Subject: Re: [patch 12/23] local_t m32r use architecture specific cmpxchg_local
Message-ID: <20070821140109.GA5743@Krystal>
References: <20070820201519.512791382@polymtl.ca> <20070820201827.341565823@polymtl.ca> <swfr6lxw7re.wl%takata.hirokazu@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <swfr6lxw7re.wl%takata.hirokazu@renesas.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:58:51 up 22 days, 14:17,  2 users,  load average: 1.94, 1.17, 0.64
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Hirokazu Takata (takata@linux-m32r.org) wrote:
> BTW, I need an additional patch to fix a build error, 
> caused by the above patch.
> 
> -- Takata
> 
> 
> [PATCH] m32r: build fix of arch/m32r/kernel/smpboot.c
> 
> This patch is for Mathieu Desnoyers's include/asm-m32r/local.h.
> Applying the new include/asm-m32r/local.h, inclusion of linux/sched.h
> is needed to fix a build error of arch/m32r/kernel/smpboot.c.
> 
> <--  snip  -->
>   ...
>   CC      arch/m32r/kernel/smpboot.o
> /project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c: In function 'do_boot_cpu':
> /project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:279: error: implicit declaration of function 'fork_idle'
> /project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:279: warning: assignment makes pointer from integer without a cast
> /project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:283: error: dereferencing pointer to incomplete type
> /project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:289: error: dereferencing pointer to incomplete type
> /project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:290: error: implicit declaration of function 'task_thread_info'
> /project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:290: error: invalid type argument of '->'
> /project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c: In function 'start_secondary':
> /project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:429: error: implicit declaration of function 'cpu_init'
> make[2]: *** [arch/m32r/kernel/smpboot.o] Error 1
> <--  snip  -->
> 
> Signed-off-by: Hirokazu Takata <takata@linux-m32r.org>
> ---
>  arch/m32r/kernel/smpboot.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/m32r/kernel/smpboot.c b/arch/m32r/kernel/smpboot.c
> index 9dae410..b41aa78 100644
> --- a/arch/m32r/kernel/smpboot.c
> +++ b/arch/m32r/kernel/smpboot.c
> @@ -43,6 +43,7 @@
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
> +#include <linux/sched.h>
>  #include <linux/err.h>
>  #include <linux/irq.h>
>  #include <linux/bootmem.h>
> -- 
> 1.5.2.4
> 

Yes, it seems like m32r smpboot.c depended upon the include hardirq.h
from asm-generic/local.h, which disappears in the architecture specific
implementation. You fix is therefore needed and appropriate (it's not a
circular dependency).

Thanks!

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
