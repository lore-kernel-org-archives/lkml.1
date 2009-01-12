Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbZALASU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbZALASU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 19:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbZALASL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 19:18:11 -0500
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:51730
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116AbZALASK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 19:18:10 -0500
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Jan 2009 19:18:09 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au8AAHIYakl8qHf+/2dsb2JhbAAIjFy4dotGhW8
X-IronPort-AV: E=Sophos;i="4.37,249,1231081200"; 
   d="scan'208";a="439642647"
Message-ID: <496A89A1.8050302@gmail.com>
Date: Mon, 12 Jan 2009 11:06:57 +1100
From: Julian Calaby <julian.calaby@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Anatolij Gustschin <agust@denx.de>
CC: Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Matteo Fortini <m.fortini@selcomgroup.com>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: [PATCH] mb862xx: Restrict compliation of platform driver to PPC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mb862xx: Restrict compliation of platform driver to PPC

The OpenFirmware part of this driver is uncompilable on SPARC due to it's dependance on several PPC specific functions.

Restricting this to PPC to prevent these build errors.

This was found using randconfig builds.

Signed-off-by: Julian Calaby <julian.calaby@gmail.com>

---

A couple of notes:

1. After looking at the includes used by this driver, the OF part may not compile cleanly on PPC either as it doesn't appear to pull in the required headers for all the functions and constants it uses.

2. Also, this bug will *not* show up in allmodconfigs or allyesconfigs as the OF part of this driver is prevented from building when the PCI driver is built, and the PCI driver appears first.

3. This patch is over DaveM's sparc-2.6 git tree as of today.

4. I apologise for the massive cross-posting - I am not sure where exactly to send this patch.

5. Please note that I am not a member of any of these lists, so please keep me CC'd.

Thanks,

Julian Calaby

---
 drivers/video/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 6372f8b..8f18169 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2111,6 +2111,7 @@ config FB_MB862XX_LIME
 	bool "Lime GDC"
 	depends on FB_MB862XX
 	depends on OF && !FB_MB862XX_PCI_GDC
+	depends on PPC
 	select FB_FOREIGN_ENDIAN
 	select FB_LITTLE_ENDIAN
 	---help---
