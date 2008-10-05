Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbYJEO2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbYJEO2t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 10:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbYJEO2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 10:28:41 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:39034 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959AbYJEO2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 10:28:40 -0400
Date: Sun, 5 Oct 2008 17:28:19 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, drzeus@drzeus.cx
Subject: Re: [PATCH] sdhci: 'scratch' may be used uninitialized
Message-ID: <20081005142819.GB12047@cs181140183.pp.htv.fi>
References: <20081001083532.GE31009@elte.hu> <1222851025-30619-1-git-send-email-steven@uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1222851025-30619-1-git-send-email-steven@uplinklabs.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 01:50:25AM -0700, Steven Noonan wrote:
> The variable 'scratch' is always initialized before it's used. The
> conditional which is responsible for initialization of 'scratch' will
> always evaluate 'true' when the first loop iteration occurs, and thus,
> it's properly initialized. GCC doesn't see this, of course, so using
> the uninitialized_var() macro seems to work for silencing this case.
> 
> Signed-off-by: Steven Noonan <steven@uplinklabs.net>
> ---
>  drivers/mmc/host/sdhci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index e3a8133..6257677 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -177,7 +177,7 @@ static void sdhci_read_block_pio(struct sdhci_host *host)
>  {
>  	unsigned long flags;
>  	size_t blksize, len, chunk;
> -	u32 scratch;
> +	u32 uninitialized_var(scratch);
>...

With which gcc version?

I'm not getting this warning with gcc 4.3, and IMHO it doesn't make 
sense to clutter the source code with such workarounds for older gcc 
versions (we officially support 6 years old compilers, and warning-free 
compilations with all of them are not reasonably possible).

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

