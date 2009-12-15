Return-Path: <linux-kernel-owner+w=401wt.eu-S934112AbZLOWsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934112AbZLOWsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932845AbZLOWsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:48:40 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:31804 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774AbZLOWsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:48:39 -0500
Date: Tue, 15 Dec 2009 14:46:43 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: mmotm 2009-11-24-16-47 uploaded (gpio_max7301)
Message-Id: <20091215144643.30756c30.randy.dunlap@oracle.com>
In-Reply-To: <20091215144306.2d3aeeff.akpm@linux-foundation.org>
References: <200911250111.nAP1BFg5030254@imap1.linux-foundation.org>
	<4B0DDDFE.5060600@xenotime.net>
	<20091215144306.2d3aeeff.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090207.4B281232.0144:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 14:43:06 -0800 Andrew Morton wrote:

> On Wed, 25 Nov 2009 17:46:38 -0800
> Randy Dunlap <rdunlap@xenotime.net> wrote:
> 
> > akpm@linux-foundation.org wrote:
> > > The mm-of-the-moment snapshot 2009-11-24-16-47 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > > 
> > > and will soon be available at
> > > 
> > >    git://git.zen-sources.org/zen/mmotm.git
> > > 
> > > It contains the following patches against 2.6.32-rc8:
> > >
> > > gpio-add-driver-for-max7300-i2c-gpio-extender.patch
> > 
> > This driver has build failures when CONFIG_I2C=m and
> > MAX7301=y, MAX7301_I2C=y, MAX7301_SPI=y:
> > 
> > drivers/built-in.o: In function `max7301_i2c_write':
> > max7301.c:(.text+0x2d9e): undefined reference to `i2c_smbus_write_byte_data'
> > drivers/built-in.o: In function `max7301_i2c_read':
> > max7301.c:(.text+0x2dc6): undefined reference to `i2c_smbus_read_byte_data'
> > drivers/built-in.o: In function `max7301_init':
> > max7301.c:(.init.text+0x42e): undefined reference to `i2c_register_driver'
> > max7301.c:(.init.text+0x496): undefined reference to `i2c_del_driver'
> > drivers/built-in.o: In function `max7301_exit':
> > max7301.c:(.exit.text+0x14): undefined reference to `i2c_del_driver'
> > 
> > 
> > This kconfig syntax:
> > 
> > config GPIO_MAX7301
> >         tristate "Maxim MAX730x GPIO expander"
> >         depends on I2C || SPI_MASTER
> > 
> > allows GPIO_MAX7301 to be y when SPI_MASTER=y and I2C=m.
> > If you want to do that, you'll need to handle CONFIG_I2C=m somehow.
> > 
> 
> fyi, I have this patch "on hold" due to this issue.

Wolfram sent a large replacement patch on Sun Dec. 13:
Subject: [PATCH V4] gpio: add driver for MAX7300 I2C GPIO extender

---
~Randy
