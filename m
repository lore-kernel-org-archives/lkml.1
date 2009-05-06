Return-Path: <linux-kernel-owner+w=401wt.eu-S1759502AbZEFMNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbZEFMNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758432AbZEFMNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:13:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65133 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbZEFMNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:13:41 -0400
Date: Wed, 6 May 2009 14:13:05 +0200
From: Matthias =?iso-8859-1?Q?K=F6nig?= <mk@phasorlab.de>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: [PATCH] fix blkid.h include
Message-ID: <20090506121305.GA7278@zebra.localsite>
References: <20090505214214.GC4460@nb.net.home> <20090506113550.GQ15802@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506113550.GQ15802@pengutronix.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Provags-ID: V01U2FsdGVkX18Vb+oUycBUuC36HhjH389WI0CBkKOwNk4gEhc
 bWDgX0iwO3YD3lYYs6jJ0eBXLKCkJoiFy4MetRGGDcnmrW4DqJ
 cOUSADEgbdHsx8TbhtXFgDxfv14Eewd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Schwebel <r.schwebel@pengutronix.de> wrote:
> When building util-linux-ng-2.15, I get this:
> 
> make[3]: Entering directory `/ptx/work/octopus/WORK_2_B/rsc/svn/oselas/bsp/OSELAS.BSP-Pengutronix-AllYes-trunk/platform-phyCORE-PXA270.PCM990/build-target/util-linux-ng-2.15/mount'
> arm-iwmmx-linux-gnueabi-gcc -std=gnu99 -DHAVE_CONFIG_H -I. -I..  -include ../config.h -I../include -DLOCALEDIR=\"/usr/share/locale\" -isystem /home/rsc/svn/oselas/bsp/OSELAS.BSP-Pengutronix-AllYes-trunk/platform-phyCORE-PXA270.PCM990/sysroot-target/include -isystem /home/rsc/svn/oselas/bsp/OSELAS.BSP-Pengutronix-AllYes-trunk/platform-phyCORE-PXA270.PCM990/sysroot-target/usr/include  -fsigned-char  -I/home/rsc/svn/oselas/bsp/OSELAS.BSP-Pengutronix-AllYes-trunk/platform-phyCORE-PXA270.PCM990/sysroot-target/usr/include    -g -O2 -MT mount-fsprobe.o -MD -MP -MF .deps/mount-fsprobe.Tpo -c -o mount-fsprobe.o `test -f '../lib/fsprobe.c' || echo './'`../lib/fsprobe.c
> ../lib/fsprobe.c:10:19: error: blkid.h: No such file or directory
> 
> The reason is that blkid.h comes from e2fsutils, which install the header file
> into /usr/include/blkid/blkid.h; /usr/include is also what the .pc file
> specifies for the include path for the CFLAGS. So IMHO the patch below must be
> applied to make it work.
> 
> If this is not acceptable, a little bit more configure magic would be necessary.

This breaks then the build with the internal blkid library which
can be selected by --with-fsprobe=builtin
So, I guess some other method is needed, we might just want to set the
correct include path?

Regards,
Matthias

> 
> Signed-off-by: Robert Schwebel <r.schwebel@pengutronix.de>
> 
> ---
>  lib/fsprobe.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: util-linux-ng-2.15/lib/fsprobe.c
> ===================================================================
> --- util-linux-ng-2.15.orig/lib/fsprobe.c
> +++ util-linux-ng-2.15/lib/fsprobe.c
> @@ -7,7 +7,7 @@
>  #include <sys/types.h>
>  #include <stdlib.h>
>  
> -#include <blkid.h>
> +#include <blkid/blkid.h>
>  
>  #include "blkdev.h"
>  #include "canonicalize.h"
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> --
> To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
