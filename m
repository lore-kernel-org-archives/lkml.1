Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbZEMIwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbZEMIwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 04:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbZEMIwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 04:52:12 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:18925 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbZEMIwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 04:52:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=gkNyKXS32oX5/soZgxUQyksRiv/LFT5VAZLG0ABymYMGZtm7Nt+3eKMn/qCJooplCr
         q3sP6s7fHGekJMFdix8ChNNNvKfaXT71+/lbKN5XjOYGQj+OKILju9Wv7zuk/lJViE9r
         Lapc0Y2HNZ5pFuD0VV1dV1pNvX5fPHFE53BrY=
Date: Wed, 13 May 2009 17:51:52 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED
 submenu
Message-Id: <20090513175152.1590c117.minchan.kim@barrios-desktop>
In-Reply-To: <20090513172904.7234.A69D9226@jp.fujitsu.com>
References: <20090513172904.7234.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kosaki. 

On Wed, 13 May 2009 17:30:45 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Subject: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED submenu
> 
> Almost people always turn on CONFIG_UNEVICTABLE_LRU. this configuration is
> used only embedded people.

I think at least embedded guys don't need it. 
But I am not sure other guys. 

> Thus, moving it into embedded submenu is better.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> ---
>  init/Kconfig |   12 ++++++++++++
>  mm/Kconfig   |   12 ------------
>  2 files changed, 12 insertions(+), 12 deletions(-)
> 
> Index: b/mm/Kconfig
> ===================================================================
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -203,18 +203,6 @@ config VIRT_TO_BUS
>  	def_bool y
>  	depends on !ARCH_NO_VIRT_TO_BUS
>  
> -config UNEVICTABLE_LRU
> -	bool "Add LRU list to track non-evictable pages"
> -	default y
> -	help
> -	  Keeps unevictable pages off of the active and inactive pageout
> -	  lists, so kswapd will not waste CPU time or have its balancing
> -	  algorithms thrown off by scanning these pages.  Selecting this
> -	  will use one page flag and increase the code size a little,
> -	  say Y unless you know what you are doing.
> -
> -	  See Documentation/vm/unevictable-lru.txt for more information.
> -
>  config HAVE_MLOCK
>  	bool
>  	default y if MMU=y
> Index: b/init/Kconfig
> ===================================================================
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -954,6 +954,18 @@ config SLUB_DEBUG
>  	  SLUB sysfs support. /sys/slab will not exist and there will be
>  	  no support for cache validation etc.
>  
> +config UNEVICTABLE_LRU
> +	bool "Add LRU list to track non-evictable pages" if EMBEDDED
> +	default y

If you want to move, it would be better as following.

config UNEVICTABLE_LRU
       bool "Add LRU list to track non-evictable pages" if EMBEDDED
       default !EMBEDDED

For embedded, it is disabled by default. 

> +	help
> +	  Keeps unevictable pages off of the active and inactive pageout
> +	  lists, so kswapd will not waste CPU time or have its balancing
> +	  algorithms thrown off by scanning these pages.  Selecting this
> +	  will use one page flag and increase the code size a little,
> +	  say Y unless you know what you are doing.
> +
> +	  See Documentation/vm/unevictable-lru.txt for more information.
> +
>  config STRIP_ASM_SYMS
>  	bool "Strip assembler-generated symbols during link"
>  	default n
> 
> 


-- 
Kinds Regards
Minchan Kim
