Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbZKYMLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbZKYMLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 07:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758694AbZKYMLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 07:11:23 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30559 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758742AbZKYMLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 07:11:22 -0500
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Nov 2009 07:11:21 EST
Date: Wed, 25 Nov 2009 12:59:46 +0100
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] USB: g_multi: Fixed '"CONFIG_USB_ETH_RNDIS" redefined' warning
In-reply-to: <20091125223508.c0924e2d.sfr@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <1259150386-7291-1-git-send-email-m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.6.5
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <20091125223508.c0924e2d.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <m.nazarewicz@samsung.com>

CONFIG_USB_ETH_RNDIS may be defined when g_ether is built causing
warning when multi.c tries to redefine its value.  Changed to first
undefine CONFIG_USB_ETH_RNDIS in multi.c.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
---
 drivers/usb/gadget/multi.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index 64711fe..227dc81 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -26,6 +26,9 @@
 #include <linux/utsname.h>
 
 
+#if defined CONFIG_USB_ETH_RNDIS
+#  undef CONFIG_USB_ETH_RNDIS
+#endif
 #if defined CONFIG_USB_G_MULTI_RNDIS
 #  define CONFIG_USB_ETH_RNDIS y
 #endif
-- 
1.6.5


