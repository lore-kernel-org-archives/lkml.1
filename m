Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbXKFIkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbXKFIkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 03:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbXKFIks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 03:40:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41419 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435AbXKFIkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 03:40:47 -0500
Subject: Re: [PATCH 11/16] CRIS architecture: Correct compile errors
From: David Woodhouse <dwmw2@infradead.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071030093353.GN11960@axis.com>
References: <20071030093353.GN11960@axis.com>
Content-Type: text/plain
Date: Tue, 06 Nov 2007 08:40:43 +0000
Message-Id: <1194338443.24746.43.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-10-30 at 10:33 +0100, Jesper Nilsson wrote:
> Add include file with prototype for mtdram_init_device from
> drivers/mtd/devices/mtdram.c.
> Used by axisflashmap.c to boot from ram.
> 
> Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
> 
> ---
>  mtdram.h |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> --- /dev/null	2007-10-06 06:38:38.348072750 +0200
> +++ linux-2.6.23/include/linux/mtd/mtdram.h	2002-11-13 15:57:45.000000000 +0100
> @@ -0,0 +1,10 @@
> +#ifndef __MTD_MTDRAM_H__
> +#define __MTD_MTDRAM_H__
> +
> +#ifdef __KERNEL__
> +#include <linux/mtd/mtd.h>
> +int mtdram_init_device(struct mtd_info *mtd, void *mapped_address, 
> +                       unsigned long size, char *name);
> +
> +#endif /* __KERNEL__ */
> +#endif /* __MTD_MTDRAM_H__ */

You don't need #ifdef __KERNEL__ on a file which isn't exported to
userspace. Having removed that, I've applied it to my tree.

-- 
dwmw2

