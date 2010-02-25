Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230Ab0BYKhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:37:45 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:56994 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab0BYKhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:37:41 -0500
Subject: Re: [PATCH 08/14] Regulators: max1586 - annotate probe and remove
 methods
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100224073822.15964.51065.stgit@localhost.localdomain>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
	 <20100224073822.15964.51065.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Feb 2010 10:37:37 +0000
Message-ID: <1267094257.4037.128.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-23 at 23:38 -0800, Dmitry Torokhov wrote:
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
> 
>  drivers/regulator/max1586.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
> index 2c082d3..a49fc95 100644
> --- a/drivers/regulator/max1586.c
> +++ b/drivers/regulator/max1586.c
> @@ -179,8 +179,8 @@ static struct regulator_desc max1586_reg[] = {
>  	},
>  };
>  
> -static int max1586_pmic_probe(struct i2c_client *client,
> -			      const struct i2c_device_id *i2c_id)
> +static int __devinit max1586_pmic_probe(struct i2c_client *client,
> +					const struct i2c_device_id *i2c_id)
>  {
>  	struct regulator_dev **rdev;
>  	struct max1586_platform_data *pdata = client->dev.platform_data;
> @@ -235,7 +235,7 @@ out:
>  	return ret;
>  }
>  
> -static int max1586_pmic_remove(struct i2c_client *client)
> +static int __devexit max1586_pmic_remove(struct i2c_client *client)
>  {
>  	struct regulator_dev **rdev = i2c_get_clientdata(client);
>  	int i;
> @@ -257,9 +257,10 @@ MODULE_DEVICE_TABLE(i2c, max1586_id);
>  
>  static struct i2c_driver max1586_pmic_driver = {
>  	.probe = max1586_pmic_probe,
> -	.remove = max1586_pmic_remove,
> +	.remove = __devexit_p(max1586_pmic_remove),
>  	.driver		= {
>  		.name	= "max1586",
> +		.owner	= THIS_MODULE,
>  	},
>  	.id_table	= max1586_id,
>  };
> 

Applied.

Thanks

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

