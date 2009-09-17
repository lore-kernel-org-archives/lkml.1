Return-Path: <linux-kernel-owner+w=401wt.eu-S1751572AbZIQKIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbZIQKIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 06:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbZIQKIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 06:08:37 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37860 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbZIQKIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 06:08:36 -0400
Date: Thu, 17 Sep 2009 11:08:42 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, heiko.carstens@de.ibm.com, mingo@elte.hu,
       npiggin@suse.de, sachinp@in.ibm.com
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
Message-ID: <20090917100841.GF13002@csn.ul.ie>
References: <1253083059.5478.1.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1253083059.5478.1.camel@penberg-laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 09:37:39AM +0300, Pekka Enberg wrote:
> The SLQB allocator is known to be broken on certain PowerPC and S390
> configurations. Disable the allocator in Kconfig for those architectures
> until the issues are resolved.
> 

Can the issues be summarised?

The danger is if SLQB is being silently disabled, it'll never be noticed
or debugged :/

> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: Sachin Sant <sachinp@in.ibm.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  init/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index c0d8a47..aaeddeb 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1033,6 +1033,7 @@ config SLUB
>  
>  config SLQB
>  	bool "SLQB (Queued allocator)"
> +	depends on !PPC && !S390
>  	help
>  	  SLQB is a proposed new slab allocator.
>  
> -- 
> 1.5.6.3
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
