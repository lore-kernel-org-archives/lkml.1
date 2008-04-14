Return-Path: <linux-kernel-owner+w=401wt.eu-S934972AbYDNSt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934972AbYDNSt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934378AbYDNSnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:43:33 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51157 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934360AbYDNSn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:43:27 -0400
Date: Mon, 14 Apr 2008 21:42:20 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: hskinnemoen@atmel.com, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] avr32: add include/asm-avr32/serial.h
Message-ID: <20080414184220.GC6695@cs181133002.pp.htv.fi>
References: <20080414141721.GI6695@cs181133002.pp.htv.fi> <20080414153625.6150e999@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080414153625.6150e999@core>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 03:36:24PM +0100, Alan Cox wrote:
> On Mon, 14 Apr 2008 17:17:21 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > This patch fixes the following build error:
> > 
> > <--  snip  -->
> > 
> > ...
> >   CC [M]  drivers/serial/8250.o
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/8250.c:95:24: error: asm/serial.h: No such file or directory
> > make[3]: *** [drivers/serial/8250.o] Error 1
> > 
> > <--  snip  -->
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> > ---
> > 3cb4ef80d75e118ccfd44f7006aea3db54afb31c diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
> > index b1bbaa0..b0e216d 100644
> > --- a/drivers/serial/Kconfig
> > +++ b/drivers/serial/Kconfig
> > @@ -11,7 +11,7 @@ menu "Serial drivers"
> >  # The new 8250/16550 serial drivers
> >  config SERIAL_8250
> >  	tristate "8250/16550 and compatible serial support"
> > -	depends on (BROKEN || !SPARC)
> > +	depends on (BROKEN || !SPARC) && !AVR32
> >  	select SERIAL_CORE
> >  	---help---
> 
> NAK.
> 
> Add an asm/serial.h to the platform as it has PCI so will have 8250 PCI
> devices available to it. A copy of the MIPS one should be right.

Patch below.

> Alan

cu
Adrian


<--  snip  -->


This patch fixes the following build error with CONFIG_SERIAL_8250:

<--  snip  -->

...
  CC [M]  drivers/serial/8250.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/8250.c:95:24: error: asm/serial.h: No such file or directory
make[3]: *** [drivers/serial/8250.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/asm-avr32/serial.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

7beddb9fe7aee73227a9796a039cee9583cecc0a diff --git a/include/asm-avr32/serial.h b/include/asm-avr32/serial.h
new file mode 100644
index 0000000..5ecaebc
--- /dev/null
+++ b/include/asm-avr32/serial.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_SERIAL_H
+#define _ASM_SERIAL_H
+
+/*
+ * This assumes you have a 1.8432 MHz clock for your UART.
+ *
+ * It'd be nice if someone built a serial card with a 24.576 MHz
+ * clock, since the 16550A is capable of handling a top speed of 1.5
+ * megabits/second; but this requires the faster clock.
+ */
+#define BASE_BAUD (1843200 / 16)
+
+#endif /* _ASM_SERIAL_H */

