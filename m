Return-Path: <linux-kernel-owner+w=401wt.eu-S934915AbYD1Rq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934915AbYD1Rq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933244AbYD1RqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:46:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:49677 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932607AbYD1RqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:46:20 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX183NWg30Xs3XR0eGazwYteSG8WnfkPQrEp/sBQNNW
	vwsNZOuaHUZYWG
Date: Mon, 28 Apr 2008 19:46:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] video: fix SOC_CAMERA_MT9M001 build bug
In-Reply-To: <20080428120032.GA23847@elte.hu>
Message-ID: <Pine.LNX.4.64.0804281944100.10718@axis700.grange>
References: <20080428120032.GA23847@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008, Ingo Molnar wrote:

> 
> on latest -git, with this config:
> 
>   http://redhat.com/~mingo/misc/config-Mon_Apr_28_13_25_34_CEST_2008.bad
> 
>   CONFIG_SOC_CAMERA_MT9M001=y
>   CONFIG_SOC_CAMERA_MT9V022=y
>   # CONFIG_I2C is not set
> 
> the build fails:
> 
> drivers/built-in.o: In function `reg_read':
> mt9m001.c:(.text+0x140a87): undefined reference to `i2c_smbus_read_word_data'
> drivers/built-in.o: In function `reg_write':
> mt9m001.c:(.text+0x140b6e): undefined reference to `i2c_smbus_write_word_data'
> drivers/built-in.o: In function `reg_read':
> mt9v022.c:(.text+0x1413a7): undefined reference to `i2c_smbus_read_word_data'
> drivers/built-in.o: In function `reg_write':
> mt9v022.c:(.text+0x1414ce): undefined reference to `i2c_smbus_write_word_data'
> drivers/built-in.o: In function `mt9m001_mod_init':
> mt9m001.c:(.init.text+0x158a8): undefined reference to `i2c_register_driver'
> drivers/built-in.o: In function `mt9v022_mod_init':
> mt9v022.c:(.init.text+0x158b8): undefined reference to `i2c_register_driver'
> drivers/built-in.o: In function `mt9m001_mod_exit':
> mt9m001.c:(.exit.text+0x1656): undefined reference to `i2c_del_driver'
> drivers/built-in.o: In function `mt9v022_mod_exit':
> mt9v022.c:(.exit.text+0x1666): undefined reference to `i2c_del_driver'
> 
> adding the missing I2C dependency fixes it.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

NAK. SOC-CAMERA doesn't depend on I2C. It is also suitable for cameras, 
not using i2c. mt9m001 and mt9v022 do both depend on i2c.

> ---
>  drivers/media/video/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux/drivers/media/video/Kconfig
> ===================================================================
> --- linux.orig/drivers/media/video/Kconfig
> +++ linux/drivers/media/video/Kconfig
> @@ -850,6 +850,7 @@ endif # V4L_USB_DRIVERS
>  config SOC_CAMERA
>  	tristate "SoC camera support"
>  	depends on VIDEO_V4L2
> +	depends on I2C
>  	select VIDEOBUF_DMA_SG
>  	help
>  	  SoC Camera is a common API to several cameras, not connecting
> 

Thanks
Guennadi
---
Guennadi Liakhovetski
