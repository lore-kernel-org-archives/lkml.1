Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbYIKLFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbYIKLFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 07:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbYIKLEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 07:04:54 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:7219 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYIKLEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 07:04:53 -0400
Date: Thu, 11 Sep 2008 13:04:42 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Sven Wegener <sven.wegener@stealer.net>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-dev: Return correct error code on class_create() 
 failure
Message-ID: <20080911130442.6ebd10c6@hyperion.delvare>
In-Reply-To: <alpine.LNX.2.00.0809102128110.19109@titan.stealer.net>
References: <alpine.LNX.2.00.0809102128110.19109@titan.stealer.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sven,

On Wed, 10 Sep 2008 21:30:27 +0200 (CEST), Sven Wegener wrote:
> We need to convert the error pointer from class_create(), else we'll return the
> successful return code from register_chrdev() on failure.
> 
> Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
> ---
>  drivers/i2c/i2c-dev.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
> index af4491f..307d976 100644
> --- a/drivers/i2c/i2c-dev.c
> +++ b/drivers/i2c/i2c-dev.c
> @@ -583,8 +583,10 @@ static int __init i2c_dev_init(void)
>  		goto out;
>  
>  	i2c_dev_class = class_create(THIS_MODULE, "i2c-dev");
> -	if (IS_ERR(i2c_dev_class))
> +	if (IS_ERR(i2c_dev_class)) {
> +		res = PTR_ERR(i2c_dev_class);
>  		goto out_unreg_chrdev;
> +	}
>  
>  	res = i2c_add_driver(&i2cdev_driver);
>  	if (res)

Good catch. Patch applied, thanks.

-- 
Jean Delvare
