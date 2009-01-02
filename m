Return-Path: <linux-kernel-owner+w=401wt.eu-S1756961AbZABDqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbZABDqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 22:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbZABDqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 22:46:43 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:29756 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbZABDqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 22:46:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iuoDXXdGWrdGIFD5EakUqWo9KGRlxoggGLc0BUrDHvxlZFu+DBXHzHfShnHpGTwPCw
         tqaPlUVhByFK3g9Wi5FoALD+2PEBd1tO/MUu4d8r9O2R40lybkGpc9OGrR3sk/n6wKg0
         V3Bgq2Trb4WXnb0xyhzUFQEYFo8EOSr8RQ2o4=
Message-ID: <f17812d70901011946p369bcd3bp8977405053cb6354@mail.gmail.com>
Date: Fri, 2 Jan 2009 11:46:41 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Mark Brown" <broonie@sirena.org.uk>
Subject: Re: [PATCH] mfd: Fix section mismatch in da903x
Cc: "Samuel Ortiz" <sameo@openedhand.com>, "Eric Miao" <eric.miao@marvell.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1230814351-29527-1-git-send-email-broonie@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1230814351-29527-1-git-send-email-broonie@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Eric Miao <eric.miao@marvell.com>

Samuel, please help to merge.

On Thu, Jan 1, 2009 at 8:52 PM, Mark Brown <broonie@sirena.org.uk> wrote:
> The subdevice removal functions are marked __devexit but are referenced
> from the error handling path when probing so are needed even when
> __devexit functions are removed.
>
> Signed-off-by: Mark Brown <broonie@sirena.org.uk>
> ---
>  drivers/mfd/da903x.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
> index 0b5bd85..248756f 100644
> --- a/drivers/mfd/da903x.c
> +++ b/drivers/mfd/da903x.c
> @@ -435,13 +435,13 @@ static const struct i2c_device_id da903x_id_table[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, da903x_id_table);
>
> -static int __devexit __remove_subdev(struct device *dev, void *unused)
> +static int __remove_subdev(struct device *dev, void *unused)
>  {
>        platform_device_unregister(to_platform_device(dev));
>        return 0;
>  }
>
> -static int __devexit da903x_remove_subdevs(struct da903x_chip *chip)
> +static int da903x_remove_subdevs(struct da903x_chip *chip)
>  {
>        return device_for_each_child(chip->dev, NULL, __remove_subdev);
>  }
> --
> 1.5.6.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Cheers
- eric
