Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbXIQSf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbXIQSf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637AbXIQSaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:30:20 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2815 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756531AbXIQSaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:30:18 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] drivers/video/pmagb-b-fb.c: Improve diagnostics
Date: Mon, 17 Sep 2007 20:30:08 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Antonino Daplas <adaplas@pol.net>,
       linux-fbdev-devel@lists.sourceforge.net, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64N.0709171746030.17606@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0709171746030.17606@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709172030.08568.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

>  Add error messages to the probe call.

You added them but probably forgot to return them ;)

>  While they may rarely trigger, they may be useful when something weird is 
> going on.  Also this is good style.

[snip]
 
> patch-mips-2.6.18-20060920-pmagb-b-err-1
> diff -up --recursive --new-file linux-mips-2.6.18-20060920.macro/drivers/video/pmagb-b-fb.c linux-mips-2.6.18-20060920/drivers/video/pmagb-b-fb.c
> --- linux-mips-2.6.18-20060920.macro/drivers/video/pmagb-b-fb.c	2006-12-16 16:44:41.000000000 +0000
> +++ linux-mips-2.6.18-20060920/drivers/video/pmagb-b-fb.c	2006-12-16 16:44:52.000000000 +0000
> @@ -254,16 +254,23 @@ static int __init pmagbbfb_probe(struct 
>  	struct pmagbbfb_par *par;
>  	char freq0[12], freq1[12];
>  	u32 vid_base;
> +	int err = 0;  

[snip]

> -	if (register_framebuffer(info) < 0)
> +	err = register_framebuffer(info);
> +	if (err < 0) {
> +		printk(KERN_ERR "%s: Cannot register framebuffer\n",
> +		       dev->bus_id);
>  		goto err_smem_map;
> +	}
>  
>  	get_device(dev);

Sth like this is missing?

@@ -330,7 +350,7 @@ err_cmap:

 err_alloc:
 	framebuffer_release(info);
-	return -ENXIO;
+	return err;
 }

No?

Regards,

	Mariusz
