Return-Path: <linux-kernel-owner+w=401wt.eu-S1752484AbXA2J2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbXA2J2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 04:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbXA2J2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 04:28:38 -0500
Received: from mail.first.fraunhofer.de ([194.95.169.2]:57116 "EHLO
	mail.first.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbXA2J20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 04:28:26 -0500
Subject: [PATCH] 2.6.20-rc6 trivially enable mouse button 2+3 emulation for
	x86 macs
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 28 Jan 2007 06:54:04 +0100
Message-Id: <1169963644.15163.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I would think this patch is too trivial to not be in 2.6.20:

As macbook/macbook pro's also have to live with a single mouse button
the following patch just enables the Macintosh device drivers menu in
Kconfig + adds the macintosh dir to the obj-* to make macbook* users
happy (who use exactly that since months....


Signed-off-by: Soeren Sonnenburg <kernel@nn7.de>

diff -ur linux-2.6.20-rc6/drivers/macintosh/Kconfig linux-2.6.20-rc6-sonne/drivers/macintosh/Kconfig
--- linux-2.6.20-rc6/drivers/macintosh/Kconfig  2007-01-25 03:19:28.000000000 +0100
+++ linux-2.6.20-rc6-sonne/drivers/macintosh/Kconfig    2007-01-26 21:30:51.000000000 +0100
@@ -1,6 +1,6 @@

 menu "Macintosh device drivers"
-   depends on PPC || MAC
+   depends on PPC || MAC || X86

 config ADB
    bool "Apple Desktop Bus (ADB) support"

diff -ur linux-2.6.20-rc6/drivers/Makefile linux-2.6.20-rc6-sonne/drivers/Makefile
--- linux-2.6.20-rc6/drivers/Makefile   2007-01-25 03:19:28.000000000 +0100
+++ linux-2.6.20-rc6-sonne/drivers/Makefile 2007-01-26 21:30:51.000000000 +0100
@@ -30,7 +30,7 @@
 obj-y              += base/ block/ misc/ mfd/ net/ media/
 obj-$(CONFIG_NUBUS)        += nubus/
 obj-$(CONFIG_ATM)      += atm/
-obj-$(CONFIG_PPC_PMAC)     += macintosh/
+obj-y              += macintosh/
 obj-$(CONFIG_IDE)      += ide/
 obj-$(CONFIG_FC4)      += fc4/
 obj-$(CONFIG_SCSI)     += scsi/
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
