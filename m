Return-Path: <linux-kernel-owner+w=401wt.eu-S1161037AbXBUPYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161037AbXBUPYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161279AbXBUPYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:24:52 -0500
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:2805 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161037AbXBUPYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:24:52 -0500
Date: Wed, 21 Feb 2007 16:24:48 +0100
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Komuro <komurojun-mbn@nifty.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG]  PATA_PCMCIA does not work
Message-ID: <20070221152448.GA10679@roarinelk.homelinux.net>
References: <20061217212752.d93816b4.komurojun-mbn@nifty.com> <20061217040222.GD17561@ftp.linux.org.uk> <20070211101537.e40fa309.komurojun-mbn@nifty.com> <20070211114013.65b2be2c.komurojun-mbn@nifty.com> <20070218110914.888de729.komurojun-mbn@nifty.com> <20070221153729.5eab83b6@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221153729.5eab83b6@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 03:37:29PM +0000, Alan wrote:
> Does this fix the oops ?
> 
> Alan
> 
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ata/pata_pcmcia.c linux-2.6.20-mm2/drivers/ata/pata_pcmcia.c
> --- linux.vanilla-2.6.20-mm2/drivers/ata/pata_pcmcia.c	2007-02-20 13:37:58.000000000 +0000
> +++ linux-2.6.20-mm2/drivers/ata/pata_pcmcia.c	2007-02-21 14:06:58.792707976 +0000
> @@ -308,7 +342,6 @@
>  		if (info->ndev) {
>  			struct ata_host *host = dev_get_drvdata(dev);
>  			ata_host_detach(host);
> -			dev_set_drvdata(dev, NULL);
>  		}
>  		info->ndev = 0;
>  		pdev->priv = NULL;

This bug is also present in 2.6.21-rc1, and this patch
indeed fixes it.

Thanks,

-- 
 ml.
