Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbZBJNie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbZBJNie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 08:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbZBJNiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 08:38:24 -0500
Received: from relay2.sgi.com ([192.48.179.30]:35143 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753422AbZBJNiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 08:38:23 -0500
Date: Tue, 10 Feb 2009 07:38:21 -0600
From: Dean Nelson <dcn@sgi.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Tony Luck <tony.luck@intel.com>
Cc: Jack Steiner <steiner@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] don't compile SGI XP/GRU on ia64_generic
Message-ID: <20090210133821.GA23973@sgi.com>
References: <20090210162821.6FC1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210162821.6FC1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 04:35:46PM +0900, KOSAKI Motohiro wrote:
> Impact: fix build error
> 
> Currently sgi-xp driver depend on "uv.h" header file.
> but only x86 have "uv.h" header.

Yesterday I submitted a patch that introduces a 'uv.h' header file for
ia64 and eliminates the ia64 build error. Link to any one of the following
to see the patch.

	http://marc.info/?l=linux-ia64&m=123419673126499&w=2
	http://marc.info/?l=linux-next&m=123419673226503&w=2
	http://marc.info/?l=linux-kernel&m=123419682026636&w=2

That is the preferred solution to this problem.


> Then, ia64 hit following build error.
> 
>   In file included from drivers/misc/sgi-gru/grufile.c:39:
>   drivers/misc/sgi-gru/gru.h:22:23: error: asm/uv/uv.h: No such file or directory
> 
> Cc: Jack Steiner <steiner@sgi.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> ---
>  drivers/misc/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: b/drivers/misc/Kconfig
> ===================================================================
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -165,7 +165,7 @@ config SGI_XP
>  	depends on (IA64_GENERIC || IA64_SGI_SN2 || IA64_SGI_UV || X86_UV) && SMP
>  	select IA64_UNCACHED_ALLOCATOR if IA64_GENERIC || IA64_SGI_SN2
>  	select GENERIC_ALLOCATOR if IA64_GENERIC || IA64_SGI_SN2
> -	select SGI_GRU if (IA64_GENERIC || IA64_SGI_UV || X86_64) && SMP
> +	select SGI_GRU if (IA64_SGI_UV || X86_UV) && SMP
>  	---help---
>  	  An SGI machine can be divided into multiple Single System
>  	  Images which act independently of each other and have
> @@ -189,7 +189,7 @@ config HP_ILO
>  
>  config SGI_GRU
>  	tristate "SGI GRU driver"
> -	depends on (X86_UV || IA64_SGI_UV || IA64_GENERIC) && SMP
> +	depends on (X86_UV || IA64_SGI_UV) && SMP
>  	default n
>  	select MMU_NOTIFIER
>  	---help---
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ia64" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
