Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab0BAUce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 15:32:34 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:44461 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab0BAUcb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 15:32:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J5Ldq72YQMFpXM8Zt63pP89+vatxdlWTf8B6ThKtYJncpRBfFJR6Q7yrdoMLAUab/g
         UHY54KNdIBcITTpTUVmSzK3BbjoW459pZ0j1MuR4nlgJIDyGF3SX97nSu8QhxewZ5mbJ
         4ZzIW+MWh/bk6dGczX9x84O1AwiMqMQeVOKqw=
MIME-Version: 1.0
In-Reply-To: <1265048321-8097-1-git-send-email-cascardo@holoscopio.com>
References: <1265048321-8097-1-git-send-email-cascardo@holoscopio.com>
Date: Mon, 1 Feb 2010 21:32:30 +0100
Message-ID: <520f0cf11002011232u415146a9md3afe65af4d810a6@mail.gmail.com>
Subject: Re: [PATCH] irda: remove BKL from irnet open function
From: John Kacur <jkacur@gmail.com>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Samuel Ortiz <samuel@sortiz.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 1, 2010 at 7:18 PM, Thadeu Lima de Souza Cascardo
<cascardo@holoscopio.com> wrote:
> Commit cddf63d99d0d145f18b293c3d0de4af7dab2a922 has push down the BKL
> into irnet open function. However, there's nothing that needs locking in
> there.
>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  net/irda/irnet/irnet_ppp.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
>
> diff --git a/net/irda/irnet/irnet_ppp.c b/net/irda/irnet/irnet_ppp.c
> index 156020d..d6b502c 100644
> --- a/net/irda/irnet/irnet_ppp.c
> +++ b/net/irda/irnet/irnet_ppp.c
> @@ -479,7 +479,6 @@ dev_irnet_open(struct inode *       inode,
>   ap = kzalloc(sizeof(*ap), GFP_KERNEL);
>   DABORT(ap == NULL, -ENOMEM, FS_ERROR, "Can't allocate struct irnet...\n");
>
> -  lock_kernel();
>   /* initialize the irnet structure */
>   ap->file = file;
>
> @@ -501,7 +500,6 @@ dev_irnet_open(struct inode *       inode,
>     {
>       DERROR(FS_ERROR, "Can't setup IrDA link...\n");
>       kfree(ap);
> -      unlock_kernel();
>       return err;
>     }
>
> @@ -512,7 +510,6 @@ dev_irnet_open(struct inode *       inode,
>   file->private_data = ap;
>
>   DEXIT(FS_TRACE, " - ap=0x%p\n", ap);
> -  unlock_kernel();
>   return 0;
>  }
>
> --
> 1.6.6.1

This is probably NOT safe to do, because the BKL is synchronizing the
ioctl code.

Thanks
