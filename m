Return-Path: <linux-kernel-owner+w=401wt.eu-S1761481AbYDNOUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761481AbYDNOUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760846AbYDNOS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:18:27 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41218 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760838AbYDNOS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:18:26 -0400
Date: Mon, 14 Apr 2008 17:17:21 +0300
From: Adrian Bunk <bunk@kernel.org>
To: hskinnemoen@atmel.com
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] avr32: don't offer SERIAL_8250
Message-ID: <20080414141721.GI6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error:

<--  snip  -->

...
  CC [M]  drivers/serial/8250.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/8250.c:95:24: error: asm/serial.h: No such file or directory
make[3]: *** [drivers/serial/8250.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
3cb4ef80d75e118ccfd44f7006aea3db54afb31c diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index b1bbaa0..b0e216d 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -11,7 +11,7 @@ menu "Serial drivers"
 # The new 8250/16550 serial drivers
 config SERIAL_8250
 	tristate "8250/16550 and compatible serial support"
-	depends on (BROKEN || !SPARC)
+	depends on (BROKEN || !SPARC) && !AVR32
 	select SERIAL_CORE
 	---help---
 	  This selects whether you want to include the driver for the standard

