Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbZJUHNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbZJUHNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 03:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZJUHNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 03:13:01 -0400
Received: from smtp240.poczta.interia.pl ([217.74.64.240]:42848 "EHLO
	smtp240.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbZJUHNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 03:13:00 -0400
X-Greylist: delayed 1363 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Oct 2009 03:13:00 EDT
Date: 21 Oct 2009 08:50:18 +0200
From: krzysztof.h1@poczta.fm
Subject: =?UTF-8?q?Re:_[Linux-fbdev-devel]_[PATCH]_fbdev:_Wrong_test_on_unsigned_in_fb=5Fset=5Fuser=5Fcmap()=3F?=
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/plain; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
X-ORIGINATE-IP: 83.17.101.58
X-PRIORITY: 3
X-Mailer: PSE3
Message-Id: <20091021065018.7625046CCF3@f46.poczta.interia.pl>
X-EMID: 25540acc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



"Roel Kluin" <roel.kluin@gmail.com> pisze:
> struct fb_cmap_user member start is unsigned.

> 

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

> ---

> Is this required?

> 


Drop the whole if() as exactly the same condition is checked in the fb_set_cmap() again. Anyway, the check of the cmap->start < 0 does not make any sense as the start is u32 value (most userspace addresses will be lower then 2GB on 32 bit system so the error cannot be caught by the check). I vote for removing the (cmap->start < 0) in the fb_set_cmap as well as most drivers check the start value already in driver's fb_setcolreg() function.

Best regards,
Krzysztof


> diff --git a/drivers/video/fbcmap.c b/drivers/video/fbcmap.c

> index f53b9f1..f46f05f 100644

> --- a/drivers/video/fbcmap.c

> +++ b/drivers/video/fbcmap.c

> @@ -266,7 +266,7 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct
> fb_info *info)

>  		rc = -ENODEV;

>  		goto out;

>  	}

> -	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&

> +	if ((int)cmap->start < 0 || (!info->fbops->fb_setcolreg &&

>  				!info->fbops->fb_setcmap)) {

>  		rc = -EINVAL;

>  		goto out1;

> 

> ------------------------------------------------------------------------------

> Come build with us! The BlackBerry(R) Developer Conference in SF, CA

> is the only developer event you need to attend this year. Jumpstart your

> developing skills, take BlackBerry mobile applications to market and stay
> 

> ahead of the curve. Join us from November 9 - 12, 2009. Register now!

> http://p.sf.net/sfu/devconference

> _______________________________________________

> Linux-fbdev-devel mailing list

> Linux-fbdev-devel@lists.sourceforge.net

> https://lists.sourceforge.net/lists/listinfo/linux-fbdev-devel

> 
> 






----------------------------------------------------------------------
Zobacz najwiekszy samolot na swiecie!  
Kliknij >>> http://link.interia.pl/f238f

