Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbXHBK3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbXHBK3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 06:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbXHBK3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 06:29:13 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41917 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbXHBK3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 06:29:12 -0400
X-Greylist: delayed 8308 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Aug 2007 06:29:12 EDT
Date: Thu, 02 Aug 2007 19:27:13 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] mm/migrate.c: cleanups
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070729150320.GF16817@stusta.de>
References: <20070729150320.GF16817@stusta.de>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070802191502.B7A6.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for late response.

But, this patch is the cause of compile error of memory unplug code of
2.6.23-rc1-mm2. It uses putback_lru_pages(). 
Don't make it static please... :-(

Bye.

----
 CC      mm/memory_hotplug.o
mm/memory_hotplug.c: In function ‘do_migrate_range’:
mm/memory_hotplug.c:402: error: implicit declaration of function ‘putback_lru_pages’
make[1]: *** [mm/memory_hotplug.o] Error 1

----


> This patch contains the following cleanups:
> - every file should include the headers containing the prototypes for
>   its global functions
> - make the needlessly global putback_lru_pages() static
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> Acked-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
> 
> This patch has been sent on:
> - 6 Jul 2007
> 
>  include/linux/migrate.h |    2 --
>  mm/migrate.c            |    3 ++-
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> --- linux-2.6.22-rc6-mm1/include/linux/migrate.h.old	2007-07-05 17:10:01.000000000 +0200
> +++ linux-2.6.22-rc6-mm1/include/linux/migrate.h	2007-07-05 17:10:10.000000000 +0200
> @@ -26,7 +26,6 @@
>  }
>  
>  extern int isolate_lru_page(struct page *p, struct list_head *pagelist);
> -extern int putback_lru_pages(struct list_head *l);
>  extern int migrate_page(struct address_space *,
>  			struct page *, struct page *);
>  extern int migrate_pages(struct list_head *l, new_page_t x, unsigned long);
> @@ -44,7 +43,6 @@
>  
>  static inline int isolate_lru_page(struct page *p, struct list_head *list)
>  					{ return -ENOSYS; }
> -static inline int putback_lru_pages(struct list_head *l) { return 0; }
>  static inline int migrate_pages(struct list_head *l, new_page_t x,
>  		unsigned long private) { return -ENOSYS; }
>  
> --- linux-2.6.22-rc6-mm1/mm/migrate.c.old	2007-07-05 17:10:16.000000000 +0200
> +++ linux-2.6.22-rc6-mm1/mm/migrate.c	2007-07-05 17:11:43.000000000 +0200
> @@ -28,6 +28,7 @@
>  #include <linux/mempolicy.h>
>  #include <linux/vmalloc.h>
>  #include <linux/security.h>
> +#include <linux/syscalls.h>
>  
>  #include "internal.h"
>  
> @@ -101,7 +102,7 @@
>   *
>   * returns the number of pages put back.
>   */
> -int putback_lru_pages(struct list_head *l)
> +static int putback_lru_pages(struct list_head *l)
>  {
>  	struct page *page;
>  	struct page *page2;
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Yasunori Goto 


