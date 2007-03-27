Return-Path: <linux-kernel-owner+w=401wt.eu-S933898AbXC0RLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898AbXC0RLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 13:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933908AbXC0RLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 13:11:54 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:33185 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933898AbXC0RLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 13:11:52 -0400
Date: Tue, 27 Mar 2007 13:11:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] fix arch/i386/kernel/marker.c compilation
Message-ID: <20070327171150.GA24349@Krystal>
References: <20070326205706.a750bb35.akpm@linux-foundation.org> <20070327165240.GD16477@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070327165240.GD16477@stusta.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 13:08:15 up 53 days,  7:15,  3 users,  load average: 1.14, 1.30, 1.34
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

Since kdebug.h seems to have moved from asm/ to linux/ in Andrew's tree, I
guess the #include <asm/kdebug.h> should be removed ? linux/kdebug.h
already includes asm/kdebug.h.

Mathieu

* Adrian Bunk (bunk@stusta.de) wrote:
> On Mon, Mar 26, 2007 at 08:57:06PM -0800, Andrew Morton wrote:
> >...
> > Changes since 2.6.21-rc4-mm1:
> >...
> > +move-die-notifier-handling-to-common-code.patch
> >...
> >  Misc
> >...
> 
> 
> This patch fixes the following compile error:
> 
> <--  snip  -->
> 
> ...
>   CC      arch/i386/kernel/marker.o
> /home/bunk/linux/kernel-2.6/linux-2.6.21-rc5-mm2/arch/i386/kernel/marker.c: In function 'mark_notifier':
> /home/bunk/linux/kernel-2.6/linux-2.6.21-rc5-mm2/arch/i386/kernel/marker.c:44: error: dereferencing pointer to incomplete type
> /home/bunk/linux/kernel-2.6/linux-2.6.21-rc5-mm2/arch/i386/kernel/marker.c:44: error: dereferencing pointer to incomplete type
> /home/bunk/linux/kernel-2.6/linux-2.6.21-rc5-mm2/arch/i386/kernel/marker.c:47: error: dereferencing pointer to incomplete type
> /home/bunk/linux/kernel-2.6/linux-2.6.21-rc5-mm2/arch/i386/kernel/marker.c:48: error: dereferencing pointer to incomplete type
> /home/bunk/linux/kernel-2.6/linux-2.6.21-rc5-mm2/arch/i386/kernel/marker.c: In function 'marker_optimized_set_enable':
> /home/bunk/linux/kernel-2.6/linux-2.6.21-rc5-mm2/arch/i386/kernel/marker.c:69: error: implicit declaration of function 'register_die_notifier'
> /home/bunk/linux/kernel-2.6/linux-2.6.21-rc5-mm2/arch/i386/kernel/marker.c:87: error: implicit declaration of function 'unregister_die_notifier'
> make[2]: *** [arch/i386/kernel/marker.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> --- linux-2.6.21-rc5-mm2/arch/i386/kernel/marker.c.old	2007-03-27 18:46:49.000000000 +0200
> +++ linux-2.6.21-rc5-mm2/arch/i386/kernel/marker.c	2007-03-27 18:47:14.000000000 +0200
> @@ -16,6 +16,7 @@
>  #include <linux/notifier.h>
>  #include <linux/module.h>
>  #include <linux/marker.h>
> +#include <linux/kdebug.h>
>  #include <asm/cacheflush.h>
>  #include <asm/kdebug.h>
>  
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
