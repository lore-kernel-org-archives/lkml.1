Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYIEOiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYIEOiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbYIEOie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:38:34 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:13459 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbYIEOie convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:38:34 -0400
Date: Fri, 5 Sep 2008 16:38:19 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Uwe =?ISO-8859-1?B?S2xlaW5lLUv2bmln?= 
	<ukleinek@informatik.uni-freiburg.de>
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Linux I2C <i2c@lm-sensors.org>
Subject: Re: [PATCH] Fix section for probe and remove function for Apple SMU
 Controller
Message-ID: <20080905163819.2f858b2c@hyperion.delvare>
In-Reply-To: <20080902211556.GA6872@informatik.uni-freiburg.de>
References: <20080902210501.GA4306@informatik.uni-freiburg.de>
	<20080902211556.GA6872@informatik.uni-freiburg.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

Note: patches to i2c bus drivers are better sent to the i2c mailing
list (Cc'd.)

On Tue, 2 Sep 2008 23:15:56 +0200, Uwe Kleine-König wrote:
> __devexit for i2c_powermac_probe is obviously wrong.  In the definition
> of struct platform_driver i2c_powermac_driver the remove function
> i2c_powermac_remove is wrapped in __devexit_p, so it should be defined
> using __devexit.
> 
> Signed-off-by: Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Jean Delvare <khali@linux-fr.org>
> ---
>  drivers/i2c/busses/i2c-powermac.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-powermac.c b/drivers/i2c/busses/i2c-powermac.c
> index 22f6d5c..0e7b1c6 100644
> --- a/drivers/i2c/busses/i2c-powermac.c
> +++ b/drivers/i2c/busses/i2c-powermac.c
> @@ -180,7 +180,7 @@ static const struct i2c_algorithm i2c_powermac_algorithm = {
>  };
>  
>  
> -static int i2c_powermac_remove(struct platform_device *dev)
> +static int __devexit i2c_powermac_remove(struct platform_device *dev)
>  {
>  	struct i2c_adapter	*adapter = platform_get_drvdata(dev);
>  	struct pmac_i2c_bus	*bus = i2c_get_adapdata(adapter);
> @@ -200,7 +200,7 @@ static int i2c_powermac_remove(struct platform_device *dev)
>  }
>  
>  
> -static int __devexit i2c_powermac_probe(struct platform_device *dev)
> +static int __devinit i2c_powermac_probe(struct platform_device *dev)
>  {
>  	struct pmac_i2c_bus *bus = dev->dev.platform_data;
>  	struct device_node *parent = NULL;

Looks good, patch applied. Thanks for your contribution.

-- 
Jean Delvare
