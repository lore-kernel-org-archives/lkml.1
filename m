Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0CHQys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 11:54:48 -0500
Received: from mail.perches.com ([173.55.12.10]:1514 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241Ab0CHQym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 11:54:42 -0500
Subject: Re: [PATCH] staging: wavelan: fix coding style of first 1000 lines
 in wavelan.c
From: Joe Perches <joe@perches.com>
To: Jason Dreisbach <jtdreisb@gmail.com>
Cc: jt@hp1.hp.com, gregkh@suse.de--to, jpirko@redhat.com,
       linville@tuxdriver.com, jtdreisb@gmail.com--cc,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <1268043630-5893-1-git-send-email-jtdreisb@gmail.com>
References: <1268043630-5893-1-git-send-email-jtdreisb@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Mar 2010 08:54:39 -0800
Message-ID: <1268067279.1925.41.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-08 at 02:20 -0800, Jason Dreisbach wrote:
> From: Jason <jtdreisb@gmail.com>
> diff --git a/drivers/staging/wavelan/wavelan.c b/drivers/staging/wavelan/wavelan.c
> index 54ca631..37ede43 100644
> --- a/drivers/staging/wavelan/wavelan.c
> +++ b/drivers/staging/wavelan/wavelan.c
[]
> @@ -279,7 +285,8 @@ static void update_psa_checksum(struct net_device * dev, unsigned long ioaddr, u
>  
>  	if (crc != 0)
>  		printk(KERN_WARNING
> -		       "%s: update_psa_checksum(): CRC does not agree with PSA data (even after recalculating)\n",
> +		       "%s: update_psa_checksum(): CRC does not \
> +		       agree with PSA data (even after recalculating)\n",
>  		       dev->name);
>  #endif				/* DEBUG_IOCTL_INFO */
>  #endif				/* SET_PSA_CRC */

Hi Jason.

What you've done here actually adds a defect.

Breaking up a string using line continuations adds the
initial spaces on the next line to the string.

Ignore the checkpatch error for long format lines.
They are not an error and are actually the preferred style.

One thing you could do is to change the logging form from:
	printk(KERN_<level> "%s: fmt...", dev->name, args);
to
	netdev_<level>(dev, "fmt...", args);

as this may now be a preferred style.
It gives a bit more information in the logs.

When dev is a struct device *, the conversion should be from:
	printk(KERN_<level> "%s: fmt...", dev->name, args);
to:
	dev_<level>(dev, "fmt...", args);

Another thing you could do would be to take the
embedded function name out of the format string
and use "%s() ...", __func__ as this can save
some text space when there's more than 1 use of
the function name and if the function is renamed
or refactored, the right function name is used.

So this gets converted from:
		printk(KERN_WARNING
		       "%s: update_psa_checksum(): CRC does not agree with PSA data (even after recalculating)\n",
		       dev->name);
to:
		netdev_warn(dev, "%s(): CRC does not agree with PSA data (even after recalculating)\n",
			    __func__);


