Return-Path: <linux-kernel-owner+w=401wt.eu-S1761788AbXHAI0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761788AbXHAI0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 04:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758631AbXHAIZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 04:25:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758490AbXHAIZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 04:25:56 -0400
Message-ID: <46B04348.1060907@kernel.sg>
Date: Wed, 01 Aug 2007 16:24:40 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] - Remove current defines and uses of pr_err, add pr_emerg,
 pr_alert, pr_crit, pr_err, pr_warn, pr_notice to include/linux/kernel.h
References: <1185941363.14777.34.camel@localhost>
In-Reply-To: <1185941363.14777.34.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Joe Perches wrote:
> Remove current #define and uses of pr_err
> Add pr_emerg, pr_alert, pr_crit, pr_err, pr_warn, pr_notice
> 	to include/linux/kernel.h
> 
> Signed-off-by:  Joe Perches <joe@perches.com>
> 
> diff --git a/drivers/i2c/chips/menelaus.c b/drivers/i2c/chips/menelaus.c
> index 48a7e2f..3ee323a 100644
> --- a/drivers/i2c/chips/menelaus.c
> +++ b/drivers/i2c/chips/menelaus.c
> @@ -49,8 +49,7 @@
>  #include <asm/arch/menelaus.h>
>  
>  #define DRIVER_NAME			"menelaus"
> -
> -#define pr_err(fmt, arg...)	printk(KERN_ERR DRIVER_NAME ": ", ## arg);

Makes sense to remove the duplicated pr_* functions, and have it declared in
include/linux/kernel.h.

> +#define PFX                             DRIVER_NAME ": "
>  
>  #define MENELAUS_I2C_ADDRESS		0x72
>  
> @@ -156,7 +155,7 @@ static int menelaus_write_reg(int reg, u8 value)
>  	int val = i2c_smbus_write_byte_data(the_menelaus->client, reg, value);
>  
>  	if (val < 0) {
> -		pr_err("write error");
> +		printk(KERN_ERR PFX "write error\n");
>  		return val;
>  	}
[...]

But why are you replacing the existing pr_*() with printk(KERN_*?

Eugene
