Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbXKGVRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbXKGVRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 16:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbXKGVRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 16:17:44 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:55133 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbXKGVRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 16:17:43 -0500
Date: Wed, 7 Nov 2007 13:15:03 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, adaplas@gmail.com
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH] chipsfb: uses/depends on PCI
Message-Id: <20071107131503.11c68fbd.randy.dunlap@oracle.com>
In-Reply-To: <4732186D.1010502@linux.vnet.ibm.com>
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
	<4732186D.1010502@linux.vnet.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

chipsfb uses PCI interfaces and should depend on PCI.

  CC      drivers/video/chipsfb.o
drivers/video/chipsfb.c: In function 'chipsfb_pci_init':
drivers/video/chipsfb.c:378: error: implicit declaration of function 'pci_request_region'
drivers/video/chipsfb.c:435: error: implicit declaration of function 'pci_release_region'
make[2]: *** [drivers/video/chipsfb.o] Error 1
make[1]: *** [drivers/video] Error 2
make: *** [drivers] Error 2

!CONFIG_PCI causes the build to fail.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2624-rc1-mmbo.orig/drivers/video/Kconfig
+++ linux-2624-rc1-mmbo/drivers/video/Kconfig
@@ -503,7 +503,7 @@ config FB_VALKYRIE
 
 config FB_CT65550
 	bool "Chips 65550 display support"
-	depends on (FB = y) && PPC32
+	depends on (FB = y) && PPC32 && PCI
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
