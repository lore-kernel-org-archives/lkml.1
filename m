Return-Path: <linux-kernel-owner+w=401wt.eu-S933255AbXG2Ruj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255AbXG2Ruj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 13:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763929AbXG2Ruc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 13:50:32 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2763 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758139AbXG2Rub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 13:50:31 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: paulus@samba.org, Andrew Morton <akpm@linux-foundation.org>, pavel@suse.cz,
       rjw@sisk.pl
Subject: [PATCH] ppc: chipsfb.c build fix for CONFIG_PM
Date: Sun, 29 Jul 2007 19:50:28 +0200
User-Agent: KMail/1.9.5
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707291950.30261.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	This patch fixes the following build error on powerpc:

  CC      drivers/video/chipsfb.o
drivers/video/chipsfb.c: In function 'chipsfb_pci_suspend':
drivers/video/chipsfb.c:461: error: 'PM_SUSPEND_MEM' undeclared (first use in this function)
drivers/video/chipsfb.c:461: error: (Each undeclared identifier is reported only once
drivers/video/chipsfb.c:461: error: for each function it appears in.)
make[2]: *** [drivers/video/chipsfb.o] Blad 1
make[1]: *** [drivers/video] Blad 2
make: *** [drivers] Blad 2



Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/video/chipsfb.c | 12751 -> 12804 (+53 bytes)
 drivers/video/chipsfb.o |  -> 112880 ( bytes)

 drivers/video/chipsfb.c |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-2.6.23-rc1-mm1-a/drivers/video/chipsfb.c	2007-07-26 13:07:41.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/video/chipsfb.c	2007-07-29 19:34:15.000000000 +0200
@@ -27,6 +27,11 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/console.h>
+
+#ifdef CONFIG_PM
+#include <linux/suspend.h>
+#endif
+
 #include <asm/io.h>

 #ifdef CONFIG_PMAC_BACKLIGHT
