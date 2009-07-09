Return-Path: <linux-kernel-owner+w=401wt.eu-S1758949AbZGIAU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949AbZGIAU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 20:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbZGIAUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 20:20:50 -0400
Received: from mail-px0-f193.google.com ([209.85.216.193]:60154 "EHLO
	mail-px0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbZGIAUu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 20:20:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RN5YMALQ08LitR8jRuJ4cFQfzaLXajDniqu9amm6s3YINqOI9U+RylUVAZycwwqpVx
         Z6IQ2GHqbA7ZWnsBMxdoJ94r8sW5pfarrxuuPdMv4w3UBx57hwOoJ+N1usCPadr6N39B
         aSX3FAtRDgJz9Dthn+GGeZxlahJPezgo0Izxo=
MIME-Version: 1.0
In-Reply-To: <1247098591-4887-1-git-send-email-tom.leiming@gmail.com>
References: <1247098591-4887-1-git-send-email-tom.leiming@gmail.com>
Date: Thu, 9 Jul 2009 08:20:48 +0800
Message-ID: <d82e647a0907081720v438344fcj1b37e0e226818632@mail.gmail.com>
Subject: Re: [PATCH] driver core:firmware_class:fix memory leak of page 
	pointers array
From: Ming Lei <tom.leiming@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, catalin.marinas@arm.com, dwmw2@infradead.org,
       kay.sievers@vrfy.org, Ming Lei <tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/9  <tom.leiming@gmail.com>:
> From: Ming Lei <tom.leiming@gmail.com>
>
> The page pointers array is allocated in fw_realloc_buffer() called by
> firmware_data_write(), and should be freed in release function of firmware
> device.
>
> Signed-off-by:Ming Lei <tom.leiming@gmail.com>
> Reported-by:Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: David Woodhouse <David.Woodhouse@intel.com>

---
This patch is against Catalin Marinas's patch:
	[PATCH] Free struct device in fw_dev_release()

> ---
>  drivers/base/firmware_class.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index fc46653..2643366 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -180,7 +180,6 @@ static ssize_t firmware_loading_store(struct device *dev,
>                                goto err;
>                        }
>                        /* Pages will be freed by vfree() */
> -                       fw_priv->pages = NULL;
>                        fw_priv->page_array_size = 0;
>                        fw_priv->nr_pages = 0;
>                        complete(&fw_priv->completion);
> --
> 1.6.0.GIT
>
>



-- 
Lei Ming
