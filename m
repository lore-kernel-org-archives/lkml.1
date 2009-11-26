Return-Path: <linux-kernel-owner+w=401wt.eu-S1752071AbZKZBqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbZKZBqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 20:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbZKZBqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 20:46:35 -0500
Received: from xenotime.net ([72.52.64.118]:54130 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751477AbZKZBqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 20:46:34 -0500
Message-ID: <4B0DDDFE.5060600@xenotime.net>
Date: Wed, 25 Nov 2009 17:46:38 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: mmotm 2009-11-24-16-47 uploaded (gpio_max7301)
References: <200911250111.nAP1BFg5030254@imap1.linux-foundation.org>
In-Reply-To: <200911250111.nAP1BFg5030254@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-11-24-16-47 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git
> 
> It contains the following patches against 2.6.32-rc8:
>
> gpio-add-driver-for-max7300-i2c-gpio-extender.patch

This driver has build failures when CONFIG_I2C=m and
MAX7301=y, MAX7301_I2C=y, MAX7301_SPI=y:

drivers/built-in.o: In function `max7301_i2c_write':
max7301.c:(.text+0x2d9e): undefined reference to `i2c_smbus_write_byte_data'
drivers/built-in.o: In function `max7301_i2c_read':
max7301.c:(.text+0x2dc6): undefined reference to `i2c_smbus_read_byte_data'
drivers/built-in.o: In function `max7301_init':
max7301.c:(.init.text+0x42e): undefined reference to `i2c_register_driver'
max7301.c:(.init.text+0x496): undefined reference to `i2c_del_driver'
drivers/built-in.o: In function `max7301_exit':
max7301.c:(.exit.text+0x14): undefined reference to `i2c_del_driver'


This kconfig syntax:

config GPIO_MAX7301
        tristate "Maxim MAX730x GPIO expander"
        depends on I2C || SPI_MASTER

allows GPIO_MAX7301 to be y when SPI_MASTER=y and I2C=m.
If you want to do that, you'll need to handle CONFIG_I2C=m somehow.


-- 
~Randy
