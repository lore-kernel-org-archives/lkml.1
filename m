Return-Path: <linux-kernel-owner+w=401wt.eu-S1761481AbYENNIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761481AbYENNIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 09:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbYENNIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 09:08:24 -0400
Received: from mx0.towertech.it ([213.215.222.73]:51197 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753682AbYENNIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 09:08:23 -0400
Date: Wed, 14 May 2008 15:08:20 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: Kim.Heino@bluegiga.com, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [PATCH] add support for ST M41T94 SPI RTC
Message-ID: <20080514150820.7eb523c6@i1501.lan.towertech.it>
In-Reply-To: <482AD8D9.4090805@bluegiga.com>
References: <482AD8D9.4090805@bluegiga.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 15:19:37 +0300
"Kim B. Heino" <Kim.Heino@bluegiga.com> wrote:

> 
> This patch adds kernel driver for M41T94 RTC chip connected via SPI.
> I've tested it on two different AT91-based hardwares.

 Hi Kim,

   just a few comments:
 
> +
> +#include <linux/module.h>
> +#include <linux/version.h>
> +
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/init.h>
> +#include <linux/rtc.h>
> +#include <linux/spi/spi.h>
> +#include <linux/bcd.h>

 can you check that you really require
 all of those #includes ?


> +struct m41t94 {
> +	struct rtc_device *rtc;
> +	u8 buf[8]; /* Burst read cmd + 7 registers */
> +};

 why are you keeping the buffer here?
 

> +
> +	tm->tm_sec  = BCD2BIN(spi_w8r8(spi, M41T94_REG_SECONDS));
> +	tm->tm_min  = BCD2BIN(spi_w8r8(spi, M41T94_REG_MINUTES));
> +	tm->tm_hour = BCD2BIN(spi_w8r8(spi, M41T94_REG_HOURS));
> +	tm->tm_wday = BCD2BIN(spi_w8r8(spi, M41T94_REG_WDAY)) - 1;
> +	tm->tm_mday = BCD2BIN(spi_w8r8(spi, M41T94_REG_DAY));
> +	tm->tm_mon  = BCD2BIN(spi_w8r8(spi, M41T94_REG_MONTH)) - 1;
> +	/* assume 20YY not 19YY, and ignore century bit */
> +	tm->tm_year = BCD2BIN(spi_w8r8(spi, M41T94_REG_YEAR)) + 100;

 the choice is up to you, but I'd use the century bit if there
 is one.

> +
> +MODULE_AUTHOR ("Kim B. Heino <Kim.Heino@bluegiga.com>");
> +MODULE_DESCRIPTION ("Driver for ST M41T94 SPI RTC");
> +MODULE_LICENSE ("GPL");

 no spaces between MODULE_XXX and the ( please.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

