Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbZAUQuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbZAUQuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 11:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbZAUQuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 11:50:07 -0500
Received: from relay3.sgi.com ([192.48.171.31]:52335 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750880AbZAUQuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 11:50:06 -0500
Message-ID: <4977523B.6000507@sgi.com>
Date: Wed, 21 Jan 2009 08:50:03 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] sysrq: include interrupt.h instead of irq.h
References: <20090121150249.a87aca09.sfr@canb.auug.org.au> <1232545758.31303.2.camel@osiris.boeblingen.de.ibm.com>
In-Reply-To: <1232545758.31303.2.camel@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for catching this Heiko!
Mike

Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> With "cpumask: update irq_desc to use cpumask_var_t" in linux-next
> we get this compile bug on s390:
> 
>   CC      drivers/char/sysrq.o
> In file included from drivers/char/sysrq.c:38:
> include/linux/irq.h: In function 'init_alloc_desc_masks':
> include/linux/irq.h:442: error: dereferencing pointer to incomplete type
> 
> drivers/char/sysrq.c should include interrupt.h instead of irq.h.
> 
> Cc: Mike Travis <travis@sgi.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  drivers/char/sysrq.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-next/drivers/char/sysrq.c
> ===================================================================
> --- linux-next.orig/drivers/char/sysrq.c
> +++ linux-next/drivers/char/sysrq.c
> @@ -35,7 +35,7 @@
>  #include <linux/vt_kern.h>
>  #include <linux/workqueue.h>
>  #include <linux/kexec.h>
> -#include <linux/irq.h>
> +#include <linux/interrupt.h>
>  #include <linux/hrtimer.h>
>  #include <linux/oom.h>
>  
> 

