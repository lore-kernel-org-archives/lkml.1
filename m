Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbXJ3FHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbXJ3FHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 01:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbXJ3FHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 01:07:41 -0400
Received: from koto.vergenet.net ([210.128.90.7]:60790 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbXJ3FHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 01:07:41 -0400
Date: Tue, 30 Oct 2007 14:07:36 +0900
From: Simon Horman <horms@verge.net.au>
To: Adrian Bunk <bunk@kernel.org>
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] ia64/mm/init.c: fix section mismatches
Message-ID: <20071030050734.GD5361@verge.net.au>
References: <20071029124947.GM7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029124947.GM7227@stusta.de>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 01:49:47PM +0100, Adrian Bunk wrote:
> This patch fixes the following section mismatches:
> 
> <--  snip  -->
> 
> ...
> WARNING: vmlinux.o(.text+0x5b5c2): Section mismatch: reference to .init.text:memmap_init_zone (between 'memmap_init' and 'virtual_memmap_init')
> WARNING: vmlinux.o(.text+0x5b842): Section mismatch: reference to .init.text:memmap_init_zone (between 'virtual_memmap_init' and 'ia64_mmu_init')
> ...
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

That seems correct me and makes the warnings go away in my build.

Acked-by: Simon Horman <horms@verge.net.au>

> 
> ---
> 
>  arch/ia64/mm/init.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 45c99ede63b0f76fe3dcc906ae550193a4d41626 
> diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
> index c6c19bf..25aef62 100644
> --- a/arch/ia64/mm/init.c
> +++ b/arch/ia64/mm/init.c
> @@ -472,7 +472,7 @@ struct memmap_init_callback_data {
>  	unsigned long zone;
>  };
>  
> -static int
> +static int __meminit
>  virtual_memmap_init (u64 start, u64 end, void *arg)
>  {
>  	struct memmap_init_callback_data *args;
> @@ -503,7 +503,7 @@ virtual_memmap_init (u64 start, u64 end, void *arg)
>  	return 0;
>  }
>  
> -void
> +void __meminit
>  memmap_init (unsigned long size, int nid, unsigned long zone,
>  	     unsigned long start_pfn)
>  {
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ia64" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

