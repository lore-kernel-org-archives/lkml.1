Return-Path: <linux-kernel-owner+w=401wt.eu-S1760928AbZJMSkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760928AbZJMSkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757347AbZJMSkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:40:03 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:44273 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbZJMSkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:40:02 -0400
Date: Tue, 13 Oct 2009 20:39:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ben Dooks <ben@fluff.org.uk>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: changing module from single to multi-file build
Message-ID: <20091013183924.GA5249@merkur.ravnborg.org>
References: <20091013082427.GC7793@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013082427.GC7793@fluff.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 09:24:27AM +0100, Ben Dooks wrote:
> I have a driver, drivers/spi/spi_s3c24xx.c in this case that I have
> written an FIQ handler for which requires some assembly code. My attempts
> at trying to change it so that I can build a single module with both the
> C and ASM code linked together have not yet been a success.
> 
> The original makefile bit from drivers/spi/Makefile was:
> 
>  obj-$(CONFIG_SPI_S3C24XX)              += spi_s3c24xx.o
> 
> This allows it to work as a kernel builtin:
> 
>  obj-$(CONFIG_SPI_S3C24XX)              += spi_s3c24xx.o
>  obj-$(CONFIG_SPI_S3C24XX_FIQ)          += spi_s3c24xx_fiq.o
> 
> I tried adding the following to the file, but this does not make
> the FIQ code, I assume as there is still drivers/spi/spi_s3c24xx.c.
> 
>  obj-spi_s3c24xx-y                      := spi_s3c24xx.o
>  obj-spi_s3c24xx-$(CONFIG_SPI_S3C24XX_FIQ) += spi_s3c24xx_fiq.o

A multi-file module cannot have a .c file with a name
equal to the modulename.
So going from a single-file module to a multi-file
module rwquire you to rename the .c file if you want
to keep the old module name.

	Sam
