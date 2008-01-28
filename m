Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbYA1Ij5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbYA1Ij5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 03:39:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbYA1Ijr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 03:39:47 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:43955 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383AbYA1Ijg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 03:39:36 -0500
Date: Mon, 28 Jan 2008 10:40:01 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Hans Verkuil <hverkuil@xs4all.nl>, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 regression: VIDEO_DEV=y/m, I2C=n compile error
Message-ID: <20080128084001.GB1001@does.not.exist>
References: <20080127185216.GB13300@does.not.exist> <20080127223334.696fce6e@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080127223334.696fce6e@gaivota>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2008 at 10:33:34PM -0200, Mauro Carvalho Chehab wrote:
> Hi Adrian and Marcin,
> 
> On Sun, 27 Jan 2008 20:52:16 +0200
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > Commit 8ffbc6559493c64d6194c92d856196fdaeb8a5fb causes the following 
> > compile error with CONFIG_VIDEO_DEV=y/m, CONFIG_I2C=n:
> > 
> > <--  snip  -->
> > 
> > ...
> >   MODPOST 26 modules
> > ERROR: "i2c_attach_client" [drivers/media/video/v4l2-common.ko] undefined!
> > make[2]: *** [__modpost] Error 1
> > 
> > <--  snip  -->
> 
> 
> Thanks for getting this regression. Please test the enclosed patch.

It doesn't enable the code if CONFIG_VIDEO_DEV=m, CONFIG_I2C=m.

And what should happen if CONFIG_VIDEO_DEV=y, CONFIG_I2C=m?

If the latter should offer this code to modules we'll have to put it 
into an own module.

> Cheers,
> Mauro
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
> 
> diff -r b0815101889d linux/drivers/media/video/v4l2-common.c
> --- a/linux/drivers/media/video/v4l2-common.c	Sun Jan 27 20:39:00 2008
> -0200 +++ b/linux/drivers/media/video/v4l2-common.c	Sun Jan 27 22:23:25
> 2008 -0200 @@ -1585,6 +1585,7 @@ u32 v4l2_ctrl_next(const u32 * const * c
>  	return **ctrl_classes;
>  }
>  
> +#ifdef CONFIG_I2C
>  int v4l2_chip_match_i2c_client(struct i2c_client *c, u32 match_type, u32
> match_chip) {
>  	switch (match_type) {
> @@ -1596,6 +1597,7 @@ int v4l2_chip_match_i2c_client(struct i2
>  		return 0;
>  	}
>  }
> +EXPORT_SYMBOL(v4l2_chip_match_i2c_client);
>  
>  int v4l2_chip_ident_i2c_client(struct i2c_client *c, struct v4l2_chip_ident
> *chip, u32 ident, u32 revision)
> @@ -1612,6 +1614,7 @@ int v4l2_chip_ident_i2c_client(struct i2
>  	}
>  	return 0;
>  }
> +EXPORT_SYMBOL(v4l2_chip_ident_i2c_client);
>  
>  int v4l2_chip_match_host(u32 match_type, u32 match_chip)
>  {
> @@ -1622,6 +1625,7 @@ int v4l2_chip_match_host(u32 match_type,
>  		return 0;
>  	}
>  }
> +EXPORT_SYMBOL(v4l2_chip_match_host);
>  
>  /* ----------------------------------------------------------------- */
>  
> @@ -1656,6 +1660,8 @@ int v4l2_i2c_attach(struct i2c_adapter *
>  	}
>  	return err != -ENOMEM ? 0 : err;
>  }
> +EXPORT_SYMBOL(v4l2_i2c_attach);
> +#endif
>  
>  /* ----------------------------------------------------------------- */
>  
> @@ -1679,15 +1685,3 @@ EXPORT_SYMBOL(v4l2_ctrl_query_menu);
>  EXPORT_SYMBOL(v4l2_ctrl_query_menu);
>  EXPORT_SYMBOL(v4l2_ctrl_query_fill);
>  EXPORT_SYMBOL(v4l2_ctrl_query_fill_std);
> -
> -EXPORT_SYMBOL(v4l2_chip_match_i2c_client);
> -EXPORT_SYMBOL(v4l2_chip_ident_i2c_client);
> -EXPORT_SYMBOL(v4l2_chip_match_host);
> -
> -EXPORT_SYMBOL(v4l2_i2c_attach);
> -
> -/*
> - * Local variables:
> - * c-basic-offset: 8
> - * End:
> - */

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

