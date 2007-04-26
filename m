Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbXDZXD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbXDZXD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbXDZXD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:03:56 -0400
Received: from server1.freeshells.ch ([193.73.230.111]:52277 "EHLO
	server1.freeshells.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbXDZXDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:03:55 -0400
X-Greylist: delayed 1377 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Apr 2007 19:03:55 EDT
Date: Fri, 27 Apr 2007 00:40:55 +0200 (MEST)
From: Marko Vrh <mvrh@freeshells.ch>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH] rtc-cmos: make it load on PNPBIOS systems
Message-ID: <Pine.NEB.4.64.0704270011030.11494@freeshells.ch>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace CONFIG_PNPACPI with CONFIG_PNP, so it loads on
ACPI-less PNPBIOS systems.

Signed-off-by: Marko Vrh <mvrh@freeshells.ch>

----

diff -urNp linux-2.6.21/drivers/rtc/rtc-cmos.c linux-2.6.21.new/drivers/rtc/rtc-cmos.c
--- linux-2.6.21/drivers/rtc/rtc-cmos.c	2007-04-26 05:08:32.000000000 +0200
+++ linux-2.6.21.new/drivers/rtc/rtc-cmos.c	2007-04-26 23:58:36.000000000 +0200
@@ -379,12 +379,12 @@ static irqreturn_t cmos_interrupt(int ir
  		return IRQ_NONE;
  }

-#ifdef	CONFIG_PNPACPI
-#define	is_pnpacpi()	1
+#ifdef	CONFIG_PNP
+#define	is_pnp()	1
  #define	INITSECTION

  #else
-#define	is_pnpacpi()	0
+#define	is_pnp()	0
  #define	INITSECTION	__init
  #endif

@@ -427,7 +427,7 @@ cmos_do_probe(struct device *dev, struct
  	 * REVISIT for non-x86 systems we may need to handle io memory
  	 * resources: ioremap them, and request_mem_region().
  	 */
-	if (is_pnpacpi()) {
+	if (is_pnp()) {
  		retval = request_resource(&ioport_resource, ports);
  		if (retval < 0) {
  			dev_dbg(dev, "i/o registers already in use\n");
@@ -520,7 +520,7 @@ static void __exit cmos_do_remove(struct

  	cmos_do_shutdown();

-	if (is_pnpacpi())
+	if (is_pnp())
  		release_resource(cmos->iomem);
  	rename_region(cmos->iomem, NULL);

@@ -613,7 +613,7 @@ static int cmos_resume(struct device *de
   * the device node will always be created as a PNPACPI device.
   */

-#ifdef	CONFIG_PNPACPI
+#ifdef	CONFIG_PNP

  #include <linux/pnp.h>

@@ -684,11 +684,11 @@ static void __exit cmos_exit(void)
  }
  module_exit(cmos_exit);

-#else	/* no PNPACPI */
+#else	/* no PNP */

  /*----------------------------------------------------------------*/

-/* Platform setup should have set up an RTC device, when PNPACPI is
+/* Platform setup should have set up an RTC device, when PNP is
   * unavailable ... this could happen even on (older) PCs.
   */

@@ -734,7 +734,7 @@ static void __exit cmos_exit(void)
  module_exit(cmos_exit);


-#endif	/* !PNPACPI */
+#endif	/* !PNP */

  MODULE_AUTHOR("David Brownell");
  MODULE_DESCRIPTION("Driver for PC-style 'CMOS' RTCs");
