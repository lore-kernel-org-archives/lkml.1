Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab0BSP0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:26:08 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46195 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754469Ab0BSP0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:26:04 -0500
Date: Fri, 19 Feb 2010 15:29:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "masa-korg" <masa-korg@dsn.okisemi.com>
Cc: <linux-kernel@vger.kernel.org>, <andrew.chih.howe.khor@intel.com>,
       <joel.clark@intel.com>
Subject: Re: [PATCH]Add new device drivers for Topcliff
Message-ID: <20100219152907.75065c83@lxorguk.ukuu.org.uk>
In-Reply-To: <000a01cab118$8bbc8600$66f8800a@maildom.okisemi.com>
References: <000a01cab118$8bbc8600$66f8800a@maildom.okisemi.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Following drivers are available now.
> 
> [Device name} [File name]
> Common patch common_patch.tar.bz2
> CAN  can.tar.bz2
> DMA  dma.tar.bz2
> GbE  gbe.tar.bz2
> GPIO  gpio.tar.bz2
> I2C  i2c.tar.bz2
> IEEE1588 ieee1588.tar.bz2
> Packet HUB pcieqos.tar.bz2
> SPI  spi.tar.bz2
> UART  uart.tar.bz2
> USB Device usbdev.tar.bz2

I downloaded a few of these to look at.

You need to generate them with "diff -u" - that will make them
more readable and mean they can be applied reliably to file versions that
may have changed. They also contain unrelated/debugging changes you have
made and which you probably want to remove from the submission

eg:


! 			kunmap(miter->page);
  
  		miter->page = NULL;
  		miter->addr = NULL;
--- 402,409 ----
  			WARN_ON(!irqs_disabled());
  			kunmap_atomic(miter->addr, KM_BIO_SRC_IRQ);
  		} else
! //			kunmap(miter->page);
!  			kunmap(miter->page);


The code looks quite reasonable although not in the kernel style. We have
the staging directory so we can take submissions that still need clean up
so that is not an immediate concern.

I am unsure about the serial driver. The 8250 driver is already very
complicated. It might be better to make a copy of 8250, remove all the
other special cases and create a new driver for the IOH DMA serial port.
We can discuss that.

If you can create a set in diff -u format, I will go through them in more
detail and send further suggestions.

Alan
