Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbYJPWPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbYJPWPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756901AbYJPWPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:15:14 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:31590 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802AbYJPWPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:15:13 -0400
Message-ID: <48F7BCC2.1050604@oracle.com>
Date: Thu, 16 Oct 2008 15:14:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
Subject: [PATCH -mmotm] compal-laptop: depends on RKFILL
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

compal-laptop uses rfkill_*() so needs to depend on RFKILL
(or select it).

drivers/built-in.o: In function `compal_rfkill':
compal-laptop.c:(.init.text+0x9ac3): undefined reference to `rfkill_allocate'
compal-laptop.c:(.init.text+0x9afa): undefined reference to `rfkill_register'
compal-laptop.c:(.init.text+0x9b17): undefined reference to `rfkill_free'
drivers/built-in.o: In function `compal_cleanup':
compal-laptop.c:(.exit.text+0x912): undefined reference to `rfkill_unregister'
compal-laptop.c:(.exit.text+0x92a): undefined reference to `rfkill_unregister'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
---
 drivers/misc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-2008-1016-0052.orig/drivers/misc/Kconfig
+++ mmotm-2008-1016-0052/drivers/misc/Kconfig
@@ -263,6 +263,7 @@ config COMPAL_LAPTOP
 	depends on X86
 	depends on ACPI_EC
 	depends on BACKLIGHT_CLASS_DEVICE
+	depends on RFKILL
 	---help---
 	  This is a driver for laptops built by Compal:
 
