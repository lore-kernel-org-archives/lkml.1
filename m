Return-Path: <linux-kernel-owner+w=401wt.eu-S1761471AbXFTCQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761471AbXFTCQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 22:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758935AbXFTCQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 22:16:23 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:25623 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758920AbXFTCQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 22:16:22 -0400
Date: Wed, 20 Jun 2007 11:16:16 +0900 (JST)
Message-Id: <20070620.111616.15246884.nemoto@toshiba-tops.co.jp>
To: alessandro.zummo@towertech.it
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org, ab@mycable.de,
       mgreer@mvista.com, khali@linux-fr.org, david-b@pacbell.net
Subject: Re: [rtc-linux] [PATCH 1/2] rtc: add rtc-m41txx driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20070620002828.483ea029@inspiron>
References: <20070620.005926.52130307.anemo@mba.ocn.ne.jp>
	<20070620002828.483ea029@inspiron>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007 00:28:28 +0200, Alessandro Zummo <alessandro.zummo@towertech.it> wrote:
>   I'd prefer if you change the name in rtc-m41t80 and add
>  the names of the supported chips in the Kconfig entry.

OK, I will do.  I thought M41ST94 also can be supported but that was
wrong.  From datasheets, the driver can be used for M41T8[0123],
M41ST8[457] chips.

> > +	unsigned char wbuf[1 + M41TXX_REG_YEAR + 1];
> 
>  would be easier to understand if you have some #defines 
>  with the sizes you require for the various buffers.

I will do.

>  the proc interface will go away sooner or later, would be better to expose
>  the battery status with a sysfs attribute.

I will do.

> > +++ b/include/linux/m41txx.h
> > @@ -0,0 +1,40 @@
> > +/*
> > + * Definitions for the ST M41TXX family of i2c rtc chips.
> > + *
> > + * Based on m41t00.h by Mark A. Greer <mgreer@mvista.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> 
>  Unless this include is required by other files, please place
>  it in drivers/rtc calling it rtc-drivername.h

It is required by platform code to provide SQW setting.  Also
M41TXX_DRV_NAME and M41TXX_I2C_ADDR might be useful to declare
i2c_board_info, which would be something like:

	static struct m41txx_platform_data pdata = {
		.sqw_freq = M41TXX_SQW_32KHZ,
	};
	static struct i2c_board_info binfo __initdata = {
		I2C_BOARD_INFO(M41TXX_DRV_NAME, M41TXX_I2C_ADDR),
		.type = "m41t80",
		.platform_data = &pdata,
	};
	return i2c_register_board_info(0, &binfo, 1);

>  Other than the comments above, the driver
>  seems fine to me.

Thank you for review.
---
Atsushi Nemoto
