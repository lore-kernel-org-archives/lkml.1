Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab0BKWCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 17:02:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756744Ab0BKWCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 17:02:12 -0500
Date: Thu, 11 Feb 2010 14:01:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Mocean Laboratories <info@mocean-labs.com>,
       Juergen Beisert <j.beisert@pengutronix.de>,
       Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: mmotm 2010-02-10-16-17 uploaded (timberdale)
Message-Id: <20100211140117.455dbbff.akpm@linux-foundation.org>
In-Reply-To: <4B736ED5.5060205@oracle.com>
References: <201002110043.o1B0hKxW008835@imap1.linux-foundation.org>
	<4B736ED5.5060205@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Feb 2010 18:43:33 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On 02/10/10 16:17, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2010-02-10-16-17 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://zen-kernel.org/kernel/mmotm.git
> > 
> > It contains the following patches against 2.6.33-rc7:
> 
> 
> When CONFIG_GPIOLIB is not enabled:
> 
>   CC      drivers/mfd/timberdale.o
> In file included from mmotm-2010-0210-1617/drivers/mfd/timberdale.c:37:
> mmotm-2010-0210-1617/include/linux/spi/max7301.h:14: error: field 'chip' has incomplete type
> make[3]: *** [drivers/mfd/timberdale.o] Error 1
> 
> 
> Build error observed on i386 and on x86_64.
> 

Bug is in mainline too, I think.

Something like this?

--- a/drivers/gpio/Kconfig~drivers-gpio-max7301c-depends-on-gpiolib
+++ a/drivers/gpio/Kconfig
@@ -92,7 +92,7 @@ comment "I2C GPIO expanders:"
 
 config GPIO_MAX7300
 	tristate "Maxim MAX7300 GPIO expander"
-	depends on I2C
+	depends on I2C && GPIOLIB
 	select GPIO_MAX730X
 	help
 	  GPIO driver for Maxim MAX7301 I2C-based GPIO expander.
_

