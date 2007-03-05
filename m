Return-Path: <linux-kernel-owner+w=401wt.eu-S932140AbXCEK2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbXCEK2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933038AbXCEK2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:28:20 -0500
Received: from nz-out-0506.google.com ([64.233.162.239]:8634 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140AbXCEK2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:28:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=B/nTVgnXFUe51ZR6REj6WA4D3lI0vaRdnTtGFuA9VdRY+s8kuHsRbaDzBlFfyUCqlAWqe0EawoppoBT9e3UH4ViUd6y4OT9Kv8S3ycFwxBjaouRHWMatK1S1D4XNVwEqEi+sSt0z2+lXHIPeBTUkVicYIcygNqVa07o/gwCpdKA=
Subject: Re: 2.6.21-rc2-mm1
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070305021451.830a5fcd.akpm@linux-foundation.org>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	 <45E8493A.8020507@googlemail.com>
	 <20070305021451.830a5fcd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 05 Mar 2007 18:30:13 +0800
Message-Id: <1173090613.6782.4.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-05 at 02:14 -0800, Andrew Morton wrote:
> On Fri, 02 Mar 2007 16:56:42 +0100 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> 
> > Hi,
> > 
> > Andrew Morton napisał(a):
> > > Temporarily at
> > > 
> > >   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> > > 
> > 
> > Possible fix for
> > 
> > nvidiafb-bring-back-generic-ddc-reading.patch
> > 
> > drivers/built-in.o: In function `nvidia_probe_i2c_connector':
> > /mnt/md0/devel/linux-mm/drivers/video/nvidia/nv_i2c.c:166: undefined reference to `fb_ddc_read'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > make: *** [_all] Error 2
> > 
> > Regards,
> > Michal
> > 
> > -- 
> > Michal K. K. Piotrowski
> > LTG - Linux Testers Group (PL)
> > (http://www.stardust.webpages.pl/ltg/)
> > LTG - Linux Testers Group (EN)
> > (http://www.stardust.webpages.pl/linux_testers_group_en/)
> > 
> > Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> > 
> > --- linux-work/drivers/video/Makefile	2007-03-02 16:38:17.000000000 +0100
> > +++ linux-mm/drivers/video/Makefile	2007-03-02 16:49:23.000000000 +0100
> > @@ -33,6 +33,7 @@ obj-$(CONFIG_FB_PM3)		  += pm3fb.o
> >  obj-$(CONFIG_FB_MATROX)		  += matrox/
> >  obj-$(CONFIG_FB_RIVA)		  += riva/ vgastate.o
> >  obj-$(CONFIG_FB_NVIDIA)		  += nvidia/
> > +obj-$(CONFIG_FB_NVIDIA_I2C)	  += fb_ddc.o
> >  obj-$(CONFIG_FB_ATY)		  += aty/ macmodes.o
> >  obj-$(CONFIG_FB_ATY128)		  += aty/ macmodes.o
> >  obj-$(CONFIG_FB_RADEON)		  += aty/
> 
> Alas, with this applied, i386 allmodconfig breaks:
> 
> drivers/built-in.o: In function `fb_ddc_read':
> : undefined reference to `i2c_transfer'
> make: *** [.tmp_vmlinux1] Error 1
> 
> because allmodconfig gave me:
> 
> CONFIG_FB_NVIDIA_I2C=y

James Simmons' patch is better, sent to you as "PATCH 4/4] fbdev: Fix
kconfig error if FB_DDC=n"

Tony


