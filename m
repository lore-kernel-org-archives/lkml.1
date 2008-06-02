Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbYFBHWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbYFBHWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 03:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYFBHWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 03:22:13 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:37675 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbYFBHWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 03:22:12 -0400
Date: Mon, 2 Jun 2008 09:22:10 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: akinobu.mita@gmail.com
cc: linux-kernel@vger.kernel.org
Subject: Re: [patch -v2 19/23] zorro: use memory_read_from_buffer
In-Reply-To: <20080601231633.611599860@gmail.com>
Message-ID: <Pine.LNX.4.64.0806020921590.7351@anakin>
References: <20080601231329.223608711@gmail.com> <20080601231633.611599860@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008, akinobu.mita@gmail.com wrote:
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>  drivers/zorro/zorro-sysfs.c |   10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> Index: 2.6-git/drivers/zorro/zorro-sysfs.c
> ===================================================================
> --- 2.6-git.orig/drivers/zorro/zorro-sysfs.c
> +++ 2.6-git/drivers/zorro/zorro-sysfs.c
> @@ -15,6 +15,7 @@
>  #include <linux/zorro.h>
>  #include <linux/stat.h>
>  #include <linux/string.h>
> +#include <linux/fs.h>
>  
>  #include "zorro.h"
>  
> @@ -56,12 +57,6 @@ static ssize_t zorro_read_config(struct 
>  	struct zorro_dev *z = to_zorro_dev(container_of(kobj, struct device,
>  					   kobj));
>  	struct ConfigDev cd;
> -	unsigned int size = sizeof(cd);
> -
> -	if (off > size)
> -		return 0;
> -	if (off+count > size)
> -		count = size-off;
>  
>  	/* Construct a ConfigDev */
>  	memset(&cd, 0, sizeof(cd));
> @@ -71,8 +66,7 @@ static ssize_t zorro_read_config(struct 
>  	cd.cd_BoardAddr = (void *)zorro_resource_start(z);
>  	cd.cd_BoardSize = zorro_resource_len(z);
>  
> -	memcpy(buf, (void *)&cd+off, count);
> -	return count;
> +	return memory_read_from_buffer(buf, count, &off, &cd, sizeof(cd));
>  }
>  
>  static struct bin_attribute zorro_config_attr = {

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
