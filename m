Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab0BKSeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 13:34:24 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:34501 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab0BKSeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 13:34:22 -0500
Date: Thu, 11 Feb 2010 19:34:17 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Jean Delvare <khali@linux-fr.org>,
       Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>
Subject: Re: [PATCH] isl29003: Move from misc to als now it available with
 minimal changes
Message-ID: <20100211183417.GS9007@buzzloop.caiaq.de>
References: <4B23DA53.9090008@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B23DA53.9090008@cam.ac.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On Sat, Dec 12, 2009 at 06:00:51PM +0000, Jonathan Cameron wrote:
>  I originally offered to move this to IIO, but ALS is more appropriate.
>  There are a couple of attibutes in here that don't correspond directly
>  to any currently in ALS. Feel free to offer suggestions for renames etc
>  on these, but I'd prefer to see them in a second patch allowing us to
>  keep things in this movement patch nice and clean. Will do api help
>  once these are pinned down.

Thanks again for doing this. I gave that ported driver a quick test and
it seems to work fine. Just one thing below ...

> diff --git a/drivers/misc/isl29003.c b/drivers/als/isl29003.c
> similarity index 90%
> rename from drivers/misc/isl29003.c
> rename to drivers/als/isl29003.c
> index a71e245..2ab188e 100644
> --- a/drivers/misc/isl29003.c
> +++ b/drivers/als/isl29003.c
> @@ -31,9 +31,10 @@
>  #include <linux/i2c.h>
>  #include <linux/mutex.h>
>  #include <linux/delay.h>
> +#include <linux/als_sys.h>

You need linux/err.h here. Without that, it breaks at compile time on a
PXA board as 'PTR_ERR' and 'IS_ERR' are undefined.

Apart from that:

Acked-by: Daniel Mack <daniel@caiaq.de>

