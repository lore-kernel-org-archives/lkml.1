Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbYHAXAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbYHAXAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 19:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbYHAXAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 19:00:04 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:44127 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbYHAXAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 19:00:01 -0400
Date: Sat, 2 Aug 2008 01:58:58 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: mtdsuper.c BLOCK=n compile error
Message-ID: <20080801225858.GM19682@cs181140183.pp.htv.fi>
References: <20080801223056.GK19682@cs181140183.pp.htv.fi> <1217630912.3719.41.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1217630912.3719.41.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 11:48:31PM +0100, David Woodhouse wrote:
> On Sat, 2008-08-02 at 01:30 +0300, Adrian Bunk wrote:
> > Commit d5686b444ff3f72808d2b3fbd58672a86cdf38e7
> > (switch mtd and dm-table to lookup_bdev()) causes
> > the following compile error with CONFIG_BLOCK=n:
> > 
> > <--  snip  -->
> > 
> > ...
> >   CC      drivers/mtd/mtdsuper.o
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/mtd/mtdsuper.c: In function `get_sb_mtd':
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/mtd/mtdsuper.c:184: error: implicit declaration of function 'lookup_bdev'
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/mtd/mtdsuper.c:184: warning: assignment makes pointer from integer without a cast
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/mtd/mtdsuper.c:197: error: implicit declaration of function 'bdput'
> > make[3]: *** [drivers/mtd/mtdsuper.o] Error 1
> > 
> > <--  snip  -->
> 
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> 
> diff --git a/drivers/mtd/mtdsuper.c b/drivers/mtd/mtdsuper.c
> index 9b6af7e..e03250b 100644
> --- a/drivers/mtd/mtdsuper.c
> +++ b/drivers/mtd/mtdsuper.c
> @@ -178,6 +178,7 @@ int get_sb_mtd(struct file_system_type *fs_type, int
> flags,
>  		}
>  	}
>  
> +#ifdef CONFIG_BLOCK
>  	/* try the old way - the hack where we allowed users to mount
>  	 * /dev/mtdblock$(n) but didn't actually _use_ the blockdev
>  	 */
> @@ -200,6 +201,7 @@ int get_sb_mtd(struct file_system_type *fs_type, int
> flags,
>  			     mnt);
>  
>  not_an_MTD_device:
> +#endif /* CONFIG_BLOCK */
>  	if (!(flags & MS_SILENT))
>  		printk(KERN_NOTICE
>  		       "MTD: Attempt to mount non-MTD device \"%s\"\n",


Still gives a compile error for the second bdput().


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

