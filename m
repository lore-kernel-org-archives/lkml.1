Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbZK1TyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbZK1TyX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 14:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbZK1TyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 14:54:22 -0500
Received: from www.sr71.net ([198.145.64.142]:39769 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbZK1TyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 14:54:22 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Nov 2009 14:54:22 EST
Subject: Re: [PATCH] leds: fix the return value of ich7_lpc_probe.
From: Dave Hansen <dave@sr71.net>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, martinez.javier@gmail.com
In-Reply-To: <1259423290-6864-1-git-send-email-tfransosi@gmail.com>
References: <1259423290-6864-1-git-send-email-tfransosi@gmail.com>
Content-Type: text/plain
Date: Sat, 28 Nov 2009 11:47:45 -0800
Message-Id: <1259437665.10954.775.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-11-28 at 10:48 -0500, Thiago Farina wrote:
> In the function ich7_lpc_probe there is a 'return' that is not returning any
> value, but it should because the return type is int not void.
> 
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> ---
>  drivers/leds/leds-ss4200.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/leds/leds-ss4200.c b/drivers/leds/leds-ss4200.c
> index c7f6347..a0c4092 100644
> --- a/drivers/leds/leds-ss4200.c
> +++ b/drivers/leds/leds-ss4200.c
> @@ -350,7 +350,7 @@ static int __devinit ich7_lpc_probe(struct pci_dev *dev,
>  	status = pci_enable_device(dev);
>  	if (status) {
>  		dev_err(&dev->dev, "pci_enable_device failed\n");
> -		return;
> +		return status;
>  	}

There's a patch in -mm to do something similar.  It should be pushed
upstream when the next set of -mm patches goes.

http://userweb.kernel.org/~akpm/mmotm/broken-out/drivers-leds-leds-ss4200c-fix-return-statement.patch

Thanks for posting this, though.  

-- Dave

