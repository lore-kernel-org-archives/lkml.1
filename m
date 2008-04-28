Return-Path: <linux-kernel-owner+w=401wt.eu-S965679AbYD1SQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965679AbYD1SQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933231AbYD1SQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:16:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932086AbYD1SQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:16:12 -0400
Date: Mon, 28 Apr 2008 11:15:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [2.6 patch] mm/memory_hotplug.c must #include "internal.h"
Message-Id: <20080428111534.c873c81d.akpm@linux-foundation.org>
In-Reply-To: <20080428174008.GX2813@cs181133002.pp.htv.fi>
References: <20080428174008.GX2813@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 20:40:08 +0300 Adrian Bunk <bunk@kernel.org> wrote:

> This patch fixes the following compile error caused by
> commit 04753278769f3b6c3b79a080edb52f21d83bf6e2
> (memory hotplug: register section/node id to free):
> 
> <--  snip  -->
> 
> ...
>   CC      mm/memory_hotplug.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/memory_hotplug.c: In function ___put_page_bootmem___:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/memory_hotplug.c:82: error: implicit declaration of function _____free_pages_bootmem___
> /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/memory_hotplug.c: At top level:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/memory_hotplug.c:87: warning: no previous prototype for ___register_page_bootmem_info_section___
> make[2]: *** [mm/memory_hotplug.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 17f56d2d66ee41f504fcf0394687953c41afb8a4 diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index c4ba85c..b17dca7 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -29,6 +29,8 @@
>  
>  #include <asm/tlbflush.h>
>  
> +#include "internal.h"
> +
>  /* add this memory to iomem resource */
>  static struct resource *register_memory_resource(u64 start, u64 size)
>  {

Argh.  The -mm-only
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
debugging patch adds that include so nobody hit this before.

I think I'll do an exploratory drop of that patch.
