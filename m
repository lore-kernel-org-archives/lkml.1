Return-Path: <linux-kernel-owner+w=401wt.eu-S935936AbXHOTt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935936AbXHOTt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 15:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbXHOTtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 15:49:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:50296 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbXHOTtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 15:49:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ustAGtiv+lHVs3XqvmFar3pZ9rB49CgAs5/AvN4zlJUHBeeEpZaDM1x1XCZiUzPMEnisT3Ws0/AMi/xT1/vgIbJETDLqgX6fSodVqC7EWS8LSom6FDwO6P9qzYcyifCeFwmTgq3yDD5d/ANnUs7sb4QDP7tgr3v5NglUY8hmKn0=
Message-ID: <d9def9db0708151249s6cbd7e51haf94c53efb539dc0@mail.gmail.com>
Date: Wed, 15 Aug 2007 21:49:13 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH] Fix a memory leak in em28xx_usb_probe()
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Luca Risolia" <luca.risolia@studio.unibo.it>,
       "Ludovico Cavedon" <cavedon@sssup.it>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Sascha Sommer" <saschasommer@freenet.de>,
       "Greg Kroah-Hartman" <greg@kroah.com>
In-Reply-To: <200708092302.36705.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708092302.36705.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,

On 8/9/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> EHLO,
>
> If, in em28xx_usb_probe() the memory allocation
> 	dev->alt_max_pkt_size = kmalloc(32*
> 						dev->num_alt,GFP_KERNEL);
> fails, then we'll bail out and return -ENOMEM.
> The problem is that in that case we don't free the storage allocated
> to 'dev', thus causing a memory leak.
>
> This patch fixes the leak by freeing 'dev' before we return -ENOMEM.
> This fixes Coverity bug #647.
>
>
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Acked-by: Markus Rechberger <mrechberger@gmail.com>

thanks,
Markus

> ---
>
>  drivers/media/video/em28xx/em28xx-video.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/em28xx/em28xx-video.c
> b/drivers/media/video/em28xx/em28xx-video.c
> index 2c7b158..40307f3 100644
> --- a/drivers/media/video/em28xx/em28xx-video.c
> +++ b/drivers/media/video/em28xx/em28xx-video.c
> @@ -1772,6 +1772,7 @@ static int em28xx_usb_probe(struct usb_interface
> *interface,
>  	if (dev->alt_max_pkt_size == NULL) {
>  		em28xx_errdev("out of memory!\n");
>  		em28xx_devused&=~(1<<nr);
> +		kfree(dev);
>  		return -ENOMEM;
>  	}
>
>
>
>
>


-- 
Markus Rechberger
