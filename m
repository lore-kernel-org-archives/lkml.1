Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbYHBXd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbYHBXd6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 19:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYHBXdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 19:33:50 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:33203 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbYHBXdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 19:33:49 -0400
Date: Sun, 3 Aug 2008 02:32:40 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: viro@zeniv.linux.org.uk, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/mtd/mtdsuper.c: fix build error
Message-ID: <20080802233240.GA4385@cs181140183.pp.htv.fi>
References: <20080802225304.GD4856@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080802225304.GD4856@orion>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 02:53:04AM +0400, Alexander Beregalov wrote:
> From: Alexander Beregalov <a.beregalov@gmail.com>
> 
> drivers/mtd/mtdsuper.c: fix build error
> 
> drivers/mtd/mtdsuper.c:184: error: implicit declaration of
> 	function 'lookup_bdev'
> drivers/mtd/mtdsuper.c:197: error: implicit declaration of
> 	function 'bdput'


It already gets fs.h indirectly through linux/mtd/super.h, so while 
your patch might be correct it cannot fix a compile error.

If that's with CONFIG_BLOCK=n then it's
  http://bugzilla.kernel.org/show_bug.cgi?id=11225

Otherwise please send your .config .


> Introduced by commit d5686b444ff3f72808d2b3fbd58672a86cdf38e7
> 
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> ---
> 
>  drivers/mtd/mtdsuper.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mtd/mtdsuper.c b/drivers/mtd/mtdsuper.c
> index 9b6af7e..ec950cd 100644
> --- a/drivers/mtd/mtdsuper.c
> +++ b/drivers/mtd/mtdsuper.c
> @@ -13,6 +13,7 @@
>  #include <linux/mtd/super.h>
>  #include <linux/namei.h>
>  #include <linux/ctype.h>
> +#include <linux/fs.h>
>  
>  /*
>   * compare superblocks to see if they're equivalent

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

