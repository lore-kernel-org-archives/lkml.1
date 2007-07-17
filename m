Return-Path: <linux-kernel-owner+w=401wt.eu-S1763601AbXGQIco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763601AbXGQIco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbXGQIcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:32:36 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35290 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754981AbXGQIcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:32:35 -0400
Date: Tue, 17 Jul 2007 10:31:56 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Domen Puncer <domen.puncer@telargo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] introduce __init_exit function annotation
Message-ID: <20070717083156.GB3801@stusta.de>
References: <20070717080248.GK4375@moe.telargo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070717080248.GK4375@moe.telargo.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 10:02:48AM +0200, Domen Puncer wrote:
> Introduce __init_exit, which is useful ie. for drivers that call
> cleanup functions when they fail in __init functions.
> 
> 
> Signed-off-by: Domen Puncer <domen.puncer@telargo.com>
> ---
>  include/linux/init.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: work-powerpc.git/include/linux/init.h
> ===================================================================
> --- work-powerpc.git.orig/include/linux/init.h
> +++ work-powerpc.git/include/linux/init.h
> @@ -60,8 +60,10 @@
>  
>  #ifdef MODULE
>  #define __exit		__attribute__ ((__section__(".exit.text")))
> +#define __init_exit
>  #else
>  #define __exit		__attribute_used__ __attribute__ ((__section__(".exit.text")))
> +#define __init_exit	__init
>  #endif
>  
>  /* For assembly routines */

This doesn't work on architectures like i386 where __exit code is
discarded at runtime.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

