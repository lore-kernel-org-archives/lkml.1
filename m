Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbXFDIQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbXFDIQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 04:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbXFDIQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 04:16:40 -0400
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:56182 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752300AbXFDIQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 04:16:39 -0400
Date: Mon, 4 Jun 2007 10:15:35 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org
Subject: Re: [-mm patch] drivers/i2c/chips/ds1682.c: make code static
Message-ID: <20070604101535.3913bf3b@hyperion.delvare>
In-Reply-To: <20070603205417.GP5500@stusta.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
	<20070603205417.GP5500@stusta.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Sun, 3 Jun 2007 22:54:17 +0200, Adrian Bunk wrote:
> This patch makes some needlessly global code static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> 
>  drivers/i2c/chips/ds1682.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> --- linux-2.6.22-rc3-mm1/drivers/i2c/chips/ds1682.c.old	2007-06-03 22:18:53.000000000 +0200
> +++ linux-2.6.22-rc3-mm1/drivers/i2c/chips/ds1682.c	2007-06-03 22:21:07.000000000 +0200
> @@ -121,12 +121,12 @@
>  /*
>   * Simple register attributes
>   */
> -SENSOR_DEVICE_ATTR_2(elapsed_time, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store,
> -		     4, DS1682_REG_ELAPSED);
> -SENSOR_DEVICE_ATTR_2(alarm_time, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store,
> -		     4, DS1682_REG_ALARM);
> -SENSOR_DEVICE_ATTR_2(event_count, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store,
> -		     2, DS1682_REG_EVT_CNTR);
> +static SENSOR_DEVICE_ATTR_2(elapsed_time, S_IRUGO | S_IWUSR, ds1682_show,
> +			    ds1682_store, 4, DS1682_REG_ELAPSED);
> +static SENSOR_DEVICE_ATTR_2(alarm_time, S_IRUGO | S_IWUSR, ds1682_show,
> +			    ds1682_store, 4, DS1682_REG_ALARM);
> +static SENSOR_DEVICE_ATTR_2(event_count, S_IRUGO | S_IWUSR, ds1682_show,
> +			    ds1682_store, 2, DS1682_REG_EVT_CNTR);
>  
>  static const struct attribute_group ds1682_group = {
>  	.attrs = (struct attribute *[]) {

Good catch. I've folded this fix into i2c-ds1628-new-driver.patch,
thanks for reporting.

-- 
Jean Delvare
