Return-Path: <linux-kernel-owner+w=401wt.eu-S1752103AbXCEKOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbXCEKOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbXCEKOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:14:55 -0500
Received: from smtp.osdl.org ([65.172.181.24]:39679 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbXCEKOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:14:54 -0500
Date: Mon, 5 Mar 2007 02:14:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org, Antonino Daplas <adaplas@gmail.com>
Subject: Re: 2.6.21-rc2-mm1
Message-Id: <20070305021451.830a5fcd.akpm@linux-foundation.org>
In-Reply-To: <45E8493A.8020507@googlemail.com>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	<45E8493A.8020507@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Mar 2007 16:56:42 +0100 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Hi,
> 
> Andrew Morton napisał(a):
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> > 
> 
> Possible fix for
> 
> nvidiafb-bring-back-generic-ddc-reading.patch
> 
> drivers/built-in.o: In function `nvidia_probe_i2c_connector':
> /mnt/md0/devel/linux-mm/drivers/video/nvidia/nv_i2c.c:166: undefined reference to `fb_ddc_read'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make: *** [_all] Error 2
> 
> Regards,
> Michal
> 
> -- 
> Michal K. K. Piotrowski
> LTG - Linux Testers Group (PL)
> (http://www.stardust.webpages.pl/ltg/)
> LTG - Linux Testers Group (EN)
> (http://www.stardust.webpages.pl/linux_testers_group_en/)
> 
> Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> 
> --- linux-work/drivers/video/Makefile	2007-03-02 16:38:17.000000000 +0100
> +++ linux-mm/drivers/video/Makefile	2007-03-02 16:49:23.000000000 +0100
> @@ -33,6 +33,7 @@ obj-$(CONFIG_FB_PM3)		  += pm3fb.o
>  obj-$(CONFIG_FB_MATROX)		  += matrox/
>  obj-$(CONFIG_FB_RIVA)		  += riva/ vgastate.o
>  obj-$(CONFIG_FB_NVIDIA)		  += nvidia/
> +obj-$(CONFIG_FB_NVIDIA_I2C)	  += fb_ddc.o
>  obj-$(CONFIG_FB_ATY)		  += aty/ macmodes.o
>  obj-$(CONFIG_FB_ATY128)		  += aty/ macmodes.o
>  obj-$(CONFIG_FB_RADEON)		  += aty/

Alas, with this applied, i386 allmodconfig breaks:

drivers/built-in.o: In function `fb_ddc_read':
: undefined reference to `i2c_transfer'
make: *** [.tmp_vmlinux1] Error 1

because allmodconfig gave me:

CONFIG_FB_NVIDIA_I2C=y

