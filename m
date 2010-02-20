Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab0BTOyz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:54:55 -0500
Received: from poutre.nerim.net ([62.4.16.124]:55215 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab0BTOyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:54:54 -0500
Date: Sat, 20 Feb 2010 15:54:50 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Luotao Fu <l.fu@pengutronix.de>
Cc: Vitaly Wool <vitalywool@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Luotao Fu <l.fu@pengutronix.de>
Subject: Re: [PATCH] USB: fix I2C API usage in ohci-pnx4008.
Message-ID: <20100220155450.32f6c97e@hyperion.delvare>
In-Reply-To: <1266590520-8607-1-git-send-email-l.fu@pengutronix.de>
References: <1266590520-8607-1-git-send-email-l.fu@pengutronix.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Feb 2010 15:42:00 +0100, Luotao Fu wrote:
> i2c_board_info doesn't contain a member called name. i2c_register_client call
> does not exist.
> 
> Signed-off-by: Luotao Fu <l.fu@pengutronix.de>

Indeed... my bad. That's what I get for touching code I can't build, I
guess.

Acked-by: Jean Delvare <khali@linux-fr.org>

Note: this patch should also be applied to 2.6.32-stable.

> ---
>  drivers/usb/host/ohci-pnx4008.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-pnx4008.c b/drivers/usb/host/ohci-pnx4008.c
> index 2769326..cd74bbd 100644
> --- a/drivers/usb/host/ohci-pnx4008.c
> +++ b/drivers/usb/host/ohci-pnx4008.c
> @@ -327,7 +327,7 @@ static int __devinit usb_hcd_pnx4008_probe(struct platform_device *pdev)
>  	}
>  	i2c_adap = i2c_get_adapter(2);
>  	memset(&i2c_info, 0, sizeof(struct i2c_board_info));
> -	strlcpy(i2c_info.name, "isp1301_pnx", I2C_NAME_SIZE);
> +	strlcpy(i2c_info.type, "isp1301_pnx", I2C_NAME_SIZE);
>  	isp1301_i2c_client = i2c_new_probed_device(i2c_adap, &i2c_info,
>  						   normal_i2c);
>  	i2c_put_adapter(i2c_adap);
> @@ -411,7 +411,7 @@ out3:
>  out2:
>  	clk_put(usb_clk);
>  out1:
> -	i2c_unregister_client(isp1301_i2c_client);
> +	i2c_unregister_device(isp1301_i2c_client);
>  	isp1301_i2c_client = NULL;
>  out_i2c_driver:
>  	i2c_del_driver(&isp1301_driver);
> @@ -430,7 +430,7 @@ static int usb_hcd_pnx4008_remove(struct platform_device *pdev)
>  	pnx4008_unset_usb_bits();
>  	clk_disable(usb_clk);
>  	clk_put(usb_clk);
> -	i2c_unregister_client(isp1301_i2c_client);
> +	i2c_unregister_device(isp1301_i2c_client);
>  	isp1301_i2c_client = NULL;
>  	i2c_del_driver(&isp1301_driver);
>  


-- 
Jean Delvare
