Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbXGGBuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbXGGBuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 21:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXGGBtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 21:49:52 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53177 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752953AbXGGBtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 21:49:52 -0400
Date: Sat, 7 Jul 2007 03:50:21 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc6-mm1: SLUB_DEBUG=n compile error
Message-ID: <20070707015021.GZ3492@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 03:43:21AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc4-mm2:
>...
> +slub-add-some-more-inlines-and-ifdef-config_slub_debug.patch
>...
>  slub/slab/slob updates
>...

Tip of the day:
Also test the compilation of the configuration you are changing.

With CONFIG_SLUB_DEBUG=n:

<--  snip  -->

...
  CC      mm/slub.o
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/mm/slub.c: In function ‘init_kmem_cache_node’:
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/mm/slub.c:1873: error: ‘struct kmem_cache_node’ has no member named ‘full’
...
make[2]: *** [mm/slub.o] Error 1

<--  snip  -->


Another problem with this patch are the added inline's:

gcc already automatically inlines static functions with only one caller, 
and decides for other static functions based on the size of the function.


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

