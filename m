Return-Path: <linux-kernel-owner+w=401wt.eu-S1767083AbXEBSKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767083AbXEBSKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767080AbXEBSKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:10:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36789 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767082AbXEBSKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:10:46 -0400
Subject: Re: [v4l-dvb-maintainer] [PATCH 35/36] Use menuconfig objects II -
	DVB
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, v4l-dvb-maintainer@linuxtv.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0704301429450.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0704301429450.29151@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=utf-8
Date: Wed, 02 May 2007 15:10:26 -0300
Message-Id: <1178129426.29579.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

Em Seg, 2007-04-30 às 14:30 +0200, Jan Engelhardt escreveu:
> Change Kconfig objects from "menu, config" into "menuconfig" so
> that the user can disable the whole feature without having to
> enter the menu first.
> 
> Also remove one indirection (CONFIG_DVB) that does not seem to
> be really used inside the kernel.

Hmm.. in fact, it becames harder to unselect DVB, at least on my tests.
The patch bellow solved the issue. It also allows keeping core DVB,
disabling the adapters menu.

If nobody is against, I intend to apply both Jan and the patch bellow on
my tree by tomorrow.

---

Allow disabling DVB Adapters

From: Mauro Carvalho Chehab <mchehab@infradead.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

diff -r 497b1a27357c linux/drivers/media/dvb/Kconfig
--- a/linux/drivers/media/dvb/Kconfig   Wed May 02 10:11:47 2007 -0300
+++ b/linux/drivers/media/dvb/Kconfig   Wed May 02 11:27:23 2007 -0300
@@ -3,6 +3,15 @@
 #

 source "drivers/media/dvb/dvb-core/Kconfig"
+
+menuconfig DVB_CAPTURE_DRIVERS
+	bool "DVB/ATSC adapters"
+	depends on DVB_CORE
+	default y
+	---help---
+	  Say Y to select Digital TV adapters
+
+if DVB_CAPTURE_DRIVERS

 comment "Supported SAA7146 based PCI Adapters"
	depends on DVB_CORE && PCI && I2C
@@ -30,3 +39,5 @@ comment "Supported DVB Frontends"
 comment "Supported DVB Frontends"
	depends on DVB_CORE
 source "drivers/media/dvb/frontends/Kconfig"
+
+endif # DVB_CAPTURE_DRIVERS
diff -r 497b1a27357c linux/drivers/media/dvb/dvb-core/Kconfig
--- a/linux/drivers/media/dvb/dvb-core/Kconfig  Wed May 02 10:11:47 2007
-0300
+++ b/linux/drivers/media/dvb/dvb-core/Kconfig  Wed May 02 11:06:31 2007
-0300
@@ -1,4 +1,4 @@ menuconfig DVB_CORE
-menuconfig DVB_CORE
+config DVB_CORE
	tristate "DVB for Linux"
	depends on NET && INET
	select CRC32


