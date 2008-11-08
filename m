Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbYKHM61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbYKHM61 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 07:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbYKHM6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 07:58:19 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46801 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbYKHM6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 07:58:18 -0500
Date: Sat, 8 Nov 2008 13:59:52 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Fix __pfn_to_page(pfn) for CONFIG_DISCONTIGMEM=y
Message-ID: <20081108125952.GB21405@elf.ucw.cz>
References: <200811081353.34442.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811081353.34442.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This would be good to have in .28 IMO.

Actually, this makes sense even for .27-stable, AFAICT.

> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: Fix __pfn_to_page(pfn) for CONFIG_DISCONTIGMEM=y
> 
> Fix macro __pfn_to_page(pfn) so that it doesn't evaluate its
> argument twice in the CONFIG_DISCONTIGMEM=y case, because 'pfn' may
> be a result of a funtion call having side effects.

function call?

> For example, the hibernation code applies pfn_to_page(pfn) to the
> result of a function returning the pfn corresponding to the next set
> bit in a bitmap and the current bit position is modified on each
> call.  This leads to "interesting" failures for CONFIG_DISCONTIGMEM=y
> due to the current behavior of __pfn_to_page(pfn).
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Pavel Machek <pavel@suse.cz>

Acked-by: Pavel Machek <pavel@suse.cz>


>  include/asm-generic/memory_model.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/include/asm-generic/memory_model.h
> ===================================================================
> --- linux-2.6.orig/include/asm-generic/memory_model.h
> +++ linux-2.6/include/asm-generic/memory_model.h
> @@ -34,7 +34,7 @@
>  
>  #define __pfn_to_page(pfn)			\
>  ({	unsigned long __pfn = (pfn);		\
> -	unsigned long __nid = arch_pfn_to_nid(pfn);  \
> +	unsigned long __nid = arch_pfn_to_nid(__pfn);  \
>  	NODE_DATA(__nid)->node_mem_map + arch_local_page_offset(__pfn, __nid);\
>  })
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
