Return-Path: <linux-kernel-owner+w=401wt.eu-S935308AbXHLSSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935308AbXHLSSG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 14:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760132AbXHLSRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 14:17:54 -0400
Received: from smtp-100-sunday.noc.nerim.net ([62.4.17.100]:2592 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757354AbXHLSRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 14:17:53 -0400
Date: Sun, 12 Aug 2007 20:18:12 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Joerg Sommrey <jo@sommrey.de>, LKML <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] bad temperature values from w83781d in 2.6.22
Message-ID: <20070812201812.34694d75@hyperion.delvare>
In-Reply-To: <20070809122619.GF3584@jupiter.solarsys.private>
References: <20070805183219.0d54802b.akpm@linux-foundation.org>
	<20070808010316.GB3584@jupiter.solarsys.private>
	<20070808151716.GA6053@sommrey.de>
	<20070809035642.GE3584@jupiter.solarsys.private>
	<20070809070915.GA24252@sommrey.de>
	<20070809122619.GF3584@jupiter.solarsys.private>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007 08:26:19 -0400, Mark M. Hoffman wrote:
> Author: Mark M. Hoffman <mhoffman@lightlink.com>
> Date:   Thu Aug 9 08:12:46 2007 -0400
> 
>     hwmon: fix w83781d temp sensor type setting
>     
>     Commit 348753379a7704087603dad403603e825422fd9a introduced a regression that
>     caused temp2 and temp3 sensor type settings to be written to temp1 instead.
>     The result is that temp sensor readings could be way off.
>     
>     Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>

Good catch, sorry for messing up. My test chip is a W83781D, it doesn't
have thermal sensor type selection, so I couldn't test that.

Acked-by: Jean Delvare <khali@linux-fr.org>

> diff --git a/drivers/hwmon/w83781d.c b/drivers/hwmon/w83781d.c
> index f85b48f..c95909c 100644
> --- a/drivers/hwmon/w83781d.c
> +++ b/drivers/hwmon/w83781d.c
> @@ -740,9 +740,9 @@ store_sensor(struct device *dev, struct device_attribute *da,
>  static SENSOR_DEVICE_ATTR(temp1_type, S_IRUGO | S_IWUSR,
>  	show_sensor, store_sensor, 0);
>  static SENSOR_DEVICE_ATTR(temp2_type, S_IRUGO | S_IWUSR,
> -	show_sensor, store_sensor, 0);
> +	show_sensor, store_sensor, 1);
>  static SENSOR_DEVICE_ATTR(temp3_type, S_IRUGO | S_IWUSR,
> -	show_sensor, store_sensor, 0);
> +	show_sensor, store_sensor, 2);
>  
>  /* I2C devices get this name attribute automatically, but for ISA devices
>     we must create it by ourselves. */


-- 
Jean Delvare
