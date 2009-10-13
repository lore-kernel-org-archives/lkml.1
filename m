Return-Path: <linux-kernel-owner+w=401wt.eu-S1759071AbZJMIZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071AbZJMIZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 04:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758895AbZJMIZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 04:25:11 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50301 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758227AbZJMIZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 04:25:10 -0400
Date: Tue, 13 Oct 2009 09:24:27 +0100
From: Ben Dooks <ben@fluff.org.uk>
To: sam@ravnborg.org, linux-kernel@vger.kernel.org
Cc: spi-devel-general@lists.sourceforge.net
Subject: changing module from single to multi-file build
Message-ID: <20091013082427.GC7793@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a driver, drivers/spi/spi_s3c24xx.c in this case that I have
written an FIQ handler for which requires some assembly code. My attempts
at trying to change it so that I can build a single module with both the
C and ASM code linked together have not yet been a success.

The original makefile bit from drivers/spi/Makefile was:

 obj-$(CONFIG_SPI_S3C24XX)              += spi_s3c24xx.o

This allows it to work as a kernel builtin:

 obj-$(CONFIG_SPI_S3C24XX)              += spi_s3c24xx.o
 obj-$(CONFIG_SPI_S3C24XX_FIQ)          += spi_s3c24xx_fiq.o

I tried adding the following to the file, but this does not make
the FIQ code, I assume as there is still drivers/spi/spi_s3c24xx.c.

 obj-spi_s3c24xx-y                      := spi_s3c24xx.o
 obj-spi_s3c24xx-$(CONFIG_SPI_S3C24XX_FIQ) += spi_s3c24xx_fiq.o

Should I rename drivers/spi/spi_s3c24xx.c to something else to avoid
changing the module name, change the module name to avoid renaming the .c
to say  spi_s3c24xx_hw (we have a gpio implementation, but that could easily
be removed in favour of gpiolib). Or is there something else that could
be done?

Note, I was initially against renaming the module, but with module autoload
working so well it seems easier to rename the module than try renaming the
.c file.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
