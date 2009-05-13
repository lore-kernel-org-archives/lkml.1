Return-Path: <linux-kernel-owner+w=401wt.eu-S1759592AbZEMNGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592AbZEMNGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbZEMNGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:06:39 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:59324 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbZEMNGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:06:38 -0400
X-Auth-Info: m1yaKeVyxYtGddRSOCQTUucQm7bf+ObtlgL+OdtDhX0=
From: Anatolij Gustschin <agust@denx.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Julian Calaby <julian.calaby@gmail.com>,
       Anatolij Gustschin <agust@denx.de>
Subject: [PATCH] mb862xxfb: Restrict compliation of platform driver to PPC
Date: Wed, 13 May 2009 15:06:38 +0200
Message-Id: <1242219998-8137-1-git-send-email-agust@denx.de>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julian Calaby <julian.calaby@gmail.com>

The OpenFirmware part of this driver is uncompilable
on SPARC due to it's dependance on several PPC specific
functions.

Restricting this to PPC to prevent these build errors:
  CC      drivers/video/mb862xx/mb862xxfb.o
drivers/video/mb862xx/mb862xxfb.c: In function 'of_platform_mb862xx_probe':
drivers/video/mb862xx/mb862xxfb.c:559: error: implicit declaration of function 'of_address_to_resource'
drivers/video/mb862xx/mb862xxfb.c:575: error: 'NO_IRQ' undeclared (first use in this function)
drivers/video/mb862xx/mb862xxfb.c:575: error: (Each undeclared identifier is reported only once
drivers/video/mb862xx/mb862xxfb.c:575: error: for each function it appears in.)

This was found using randconfig builds.

Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/video/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 0048f11..fe1083f 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2094,6 +2094,7 @@ config FB_MB862XX_LIME
 	bool "Lime GDC"
 	depends on FB_MB862XX
 	depends on OF && !FB_MB862XX_PCI_GDC
+	depends on PPC
 	select FB_FOREIGN_ENDIAN
 	select FB_LITTLE_ENDIAN
 	---help---
-- 
1.5.6.3

