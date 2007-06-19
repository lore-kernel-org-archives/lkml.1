Return-Path: <linux-kernel-owner+w=401wt.eu-S1758269AbXFSW2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbXFSW2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbXFSW2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:28:44 -0400
Received: from mx0.towertech.it ([213.215.222.73]:36230 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753803AbXFSW2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:28:43 -0400
Date: Wed, 20 Jun 2007 00:28:28 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: anemo@mba.ocn.ne.jp, linux-kernel@vger.kernel.org, ab@mycable.de,
       mgreer@mvista.com, khali@linux-fr.org, david-b@pacbell.net
Subject: Re: [rtc-linux] [PATCH 1/2] rtc: add rtc-m41txx driver
Message-ID: <20070620002828.483ea029@inspiron>
In-Reply-To: <20070620.005926.52130307.anemo@mba.ocn.ne.jp>
References: <20070620.005926.52130307.anemo@mba.ocn.ne.jp>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007 00:59:26 +0900 (JST)
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

>
> This driver supports M41T80, M41T81 and M41ST85.  The old m41t00
> driver supports M41T00, M41T81 and M41T85(M41ST85).  While the M41T00
> chip is now supported by rtc-ds1307 driver, this driver does not
> include support for the chip.

 Hi,

  I'd prefer if you change the name in rtc-m41t80 and add
 the names of the supported chips in the Kconfig entry.

> +/* Sets the given date and time to the real time clock. */
> +static int m41txx_set_datetime(struct i2c_client *client, struct rtc_time *tm)
> +{
> +	unsigned char wbuf[1 + M41TXX_REG_YEAR + 1];

 would be easier to understand if you have some #defines 
 with the sizes you require for the various buffers.


> +#if defined(CONFIG_RTC_INTF_PROC) || defined(CONFIG_RTC_INTF_PROC_MODULE)
> +static int m41txx_rtc_proc(struct device *dev, struct seq_file *seq)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct m41txx_data *clientdata = i2c_get_clientdata(client);
> +	unsigned char reg;
> +
> +	if (clientdata->chip->features & M41TXX_FEATURE_BL) {
> +		reg = i2c_smbus_read_byte_data(client, M41TXX_REG_FLAGS);
> +		seq_printf(seq, "battery\t\t: %s\n",
> +			   (reg & M41TXX_FLAGS_BATT_LOW) ? "exhausted" : "ok");
> +	}
> +	return 0;
> +}

 the proc interface will go away sooner or later, would be better to expose
 the battery status with a sysfs attribute.


> +++ b/include/linux/m41txx.h
> @@ -0,0 +1,40 @@
> +/*
> + * Definitions for the ST M41TXX family of i2c rtc chips.
> + *
> + * Based on m41t00.h by Mark A. Greer <mgreer@mvista.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.

 Unless this include is required by other files, please place
 it in drivers/rtc calling it rtc-drivername.h

 Other than the comments above, the driver
 seems fine to me.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

