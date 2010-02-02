Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab0BBBYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 20:24:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689Ab0BBBYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 20:24:48 -0500
Date: Mon, 1 Feb 2010 17:24:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       akpm@linux-foundation.org, tglx@linutronix.de, fengguang.wu@intel.com
Cc: linux-tip-commits@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, fengguang.wu@intel.com
Subject: Re: [tip:x86/mm] Generic page_is_ram: use __weak
Message-Id: <20100201172423.6803e898.akpm@linux-foundation.org>
In-Reply-To: <tip-e52730071567ec5b6f57e21d6693b112e01e1d0e@git.kernel.org>
References: <tip-e52730071567ec5b6f57e21d6693b112e01e1d0e@git.kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Feb 2010 01:00:51 GMT tip-bot for Andrew Morton <akpm@linux-foundation.org> wrote:

> Commit-ID:  e52730071567ec5b6f57e21d6693b112e01e1d0e
> Gitweb:     http://git.kernel.org/tip/e52730071567ec5b6f57e21d6693b112e01e1d0e
> Author:     Andrew Morton <akpm@linux-foundation.org>
> AuthorDate: Tue, 26 Jan 2010 16:31:19 -0800
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Mon, 1 Feb 2010 16:58:17 -0800
> 
> Generic page_is_ram: use __weak
> 
> Use __weak instead of __attribute__((weak)).
> 
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> ---
>  kernel/resource.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/resource.c b/kernel/resource.c
> index b4d637a..e68cd74 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -305,7 +305,7 @@ static int __is_ram(unsigned long pfn, unsigned long nr_pages, void *arg)
>   * This generic page_is_ram() returns true if specified address is
>   * registered as "System RAM" in iomem_resource list.
>   */
> -int __attribute__((weak)) page_is_ram(unsigned long pfn)
> +int __weak page_is_ram(unsigned long pfn)
>  {
>  	return walk_system_ram_range(pfn, 1, NULL, __is_ram) == 1;
>  }

hm, it's strange to do this as two separate commits?

There was another fixlet:



From: Wu Fengguang <fengguang.wu@intel.com>

ioport.h didn't seem like the right place to declare page_is_ram().

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    2 --
 include/linux/mm.h     |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/ioport.h~resources-introduce-generic-page_is_ram-fix-2 include/linux/ioport.h
--- a/include/linux/ioport.h~resources-introduce-generic-page_is_ram-fix-2
+++ a/include/linux/ioport.h
@@ -191,7 +191,5 @@ extern int
 walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 		void *arg, int (*func)(unsigned long, unsigned long, void *));
 
-extern int page_is_ram(unsigned long pfn);
-
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
diff -puN include/linux/mm.h~resources-introduce-generic-page_is_ram-fix-2 include/linux/mm.h
--- a/include/linux/mm.h~resources-introduce-generic-page_is_ram-fix-2
+++ a/include/linux/mm.h
@@ -265,6 +265,8 @@ static inline int get_page_unless_zero(s
 	return atomic_inc_not_zero(&page->_count);
 }
 
+extern int page_is_ram(unsigned long pfn);
+
 /* Support for virtually mapped pages */
 struct page *vmalloc_to_page(const void *addr);
 unsigned long vmalloc_to_pfn(const void *addr);
_

