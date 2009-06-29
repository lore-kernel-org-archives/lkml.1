Return-Path: <linux-kernel-owner+w=401wt.eu-S1758900AbZF2Jsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900AbZF2Jsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757528AbZF2Js2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:48:28 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:50059 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbZF2Js1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:48:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DF/U/pLub2c/UY16vx9uV6bNF7EB1IVFxXX1a91V0CyIGAO6BVX2EEF5KSNU1xuw0Q
         6dfYsyS0eK/DiR8lc1ZTfwVtbcwzV7mn2Nhzy0he4CtTeJ7pvY6oAwJ9ay36VPxYF4ky
         bon8h5eIrt4TB8Lfu6Q+CNY+o6GG/1fsZKL6M=
MIME-Version: 1.0
In-Reply-To: <tnxy6rbv0oq.fsf@pc1117.cambridge.arm.com>
References: <20090626171933.GA23170@redhat.com>
	 <tnxy6rbv0oq.fsf@pc1117.cambridge.arm.com>
Date: Mon, 29 Jun 2009 12:48:29 +0300
X-Google-Sender-Auth: 0af4f195f00bf1af
Message-ID: <84144f020906290248w474ad2ffpe6a8b5bede3d2c20@mail.gmail.com>
Subject: Re: kmemleak reports firmware loader funnies in iwlwifi
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On Mon, Jun 29, 2009 at 12:39 PM, Catalin
Marinas<catalin.marinas@arm.com> wrote:
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index ddeb819..26fb808 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -179,6 +179,13 @@ static ssize_t firmware_loading_store(struct device *dev,
>                                dev_err(dev, "%s: vmap() failed\n", __func__);
>                                goto err;
>                        }
> +                       /*
> +                        * This block of memory is later freed using vfree.
> +                        * Since kmemleak does not track vmap calls, just
> +                        * inform it about this block but ignore it during
> +                        * scanning.
> +                        */
> +                       kmemleak_alloc(fw_priv->fw->data, 0, -1, GFP_KERNEL);
>                        /* Pages will be freed by vfree() */
>                        fw_priv->pages = NULL;
>                        fw_priv->page_array_size = 0;

Would it be possible to put this hook in vmap() somehow?
