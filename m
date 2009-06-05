Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbZFEI7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbZFEI7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbZFEI7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:59:43 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36337 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbZFEI7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:59:42 -0400
Date: Fri, 5 Jun 2009 11:59:41 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: corentincj@iksaif.net
cc: acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] eeepc-laptop: enable camera by default
Message-ID: <Pine.LNX.4.64.0906051157460.22218@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

If we leave the camera disabled by default, userspace programs (e.g. 
Skype, Cheese) leave the user out in the cold saying that the machine "has 
no camera." Therefore, it's better to enable camera by default and let 
people who really don't want it just disable the thing.

Cc: <acpi4asus-user@lists.sourceforge.net>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/platform/x86/eeepc-laptop.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 353a898..c0f8eb1 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -334,6 +334,19 @@ static int eeepc_bluetooth_rfkill_state(void *data, enum rfkill_state *state)
 }
 
 /*
+ * Camera helpers
+ */
+
+static void eeepc_enable_camera(void)
+{
+	int err;
+
+	err = set_acpi(CM_ASL_CAMERA, 1);
+	if (err)
+		printk(EEEPC_WARNING "Unable to enable camera %d\n", err);
+}
+
+/*
  * Sys helpers
  */
 static int parse_arg(const char *buf, unsigned long count, int *val)
@@ -996,6 +1009,9 @@ static int __init eeepc_laptop_init(void)
 	result = eeepc_hwmon_init(dev);
 	if (result)
 		goto fail_hwmon;
+
+	eeepc_enable_camera();
+
 	/* Register platform stuff */
 	result = platform_driver_register(&platform_driver);
 	if (result)
-- 
1.5.6.3

