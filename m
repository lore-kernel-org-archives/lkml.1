Return-Path: <linux-kernel-owner+w=401wt.eu-S1760928AbYASOgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760928AbYASOgu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 09:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761416AbYASOfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 09:35:53 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:42109 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761326AbYASOfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 09:35:48 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: david-b@pacbell.net, tony@atomide.com, Felipe Balbi <me@felipebalbi.com>
Subject: [PATCH 4/4] USB: OTG: Add check for roothub initialization
Date: Sat, 19 Jan 2008 16:37:25 +0200
Message-Id: <1200753446-9378-5-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.5.4.rc3.24.gb53139
In-Reply-To: <1200753446-9378-4-git-send-email-me@felipebalbi.com>
References: <1200753446-9378-1-git-send-email-me@felipebalbi.com>
 <1200753446-9378-2-git-send-email-me@felipebalbi.com>
 <1200753446-9378-3-git-send-email-me@felipebalbi.com>
 <1200753446-9378-4-git-send-email-me@felipebalbi.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

Roothub may not be initialized if no gadget is loaded on musb
for example. Add check for roothub initialization. Also make
comment more accurate.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/usb/core/otg.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/core/otg.c b/drivers/usb/core/otg.c
index e9ece31..9a2ce7e 100644
--- a/drivers/usb/core/otg.c
+++ b/drivers/usb/core/otg.c
@@ -33,16 +33,25 @@ struct otg_transceiver *otg_get_transceiver(void)
 }
 EXPORT_SYMBOL(otg_get_transceiver);
 
-/* OTG MESSAGE: report errors here, customize to match your product */
+/*
+ * OTG MESSAGE: report errors here, customize to match your product
+ * See also otg_last_error_show().
+ */
 void otg_set_error(struct otg_transceiver *x, enum usb_otg_error errno)
 {
 	if (!x)
 		return;
+
 	if (!x->tpl_enabled)
 		x->last_error = OTG_ERR_DEVICE_SUPPORTED;
 	else
 		x->last_error = errno;
 
+	if (!x->host->root_hub) {
+		printk(KERN_WARNING "OTG: root hub not yet initialized\n");
+		return;
+	}
+
 	sysfs_notify(&x->host->root_hub->dev.kobj, NULL, "otg_last_error");
 }
 EXPORT_SYMBOL(otg_set_error);
-- 
1.5.4.rc3.24.gb53139

