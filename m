Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbZCFRyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbZCFRyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 12:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbZCFRyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 12:54:40 -0500
Received: from zelda.netsplit.com ([87.194.19.211]:38659 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZCFRyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 12:54:39 -0500
From: Scott James Remnant <scott@canonical.com>
Date: Fri, 6 Mar 2009 17:50:47 +0000
Subject: [PATCH] floppy: Provide a PNP device table in the module.
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Message-Id: <E1LfeFk-0002mD-OE@zelda.netsplit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The missing device table means that the floppy module is not
auto-loaded, even when the appropriate PNP device (0700) is found.

We don't actually use the table in the module, since the device doesn't
have a struct pnp_driver, but it's sufficient to cause an alias in the
module that udev/modprobe will use.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/block/floppy.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 83d8ed3..7aa1264 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -177,6 +177,7 @@ static int print_unex = 1;
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/mod_devicetable.h>
 #include <linux/buffer_head.h>	/* for invalidate_buffers() */
 #include <linux/mutex.h>
 
@@ -4598,6 +4599,13 @@ MODULE_AUTHOR("Alain L. Knaff");
 MODULE_SUPPORTED_DEVICE("fd");
 MODULE_LICENSE("GPL");
 
+/* This doesn't actually get used other than for module information */
+static const struct pnp_device_id floppy_pnpids[] = {
+	{ "PNP0700", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(pnp, floppy_pnpids);
+
 #else
 
 __setup("floppy=", floppy_setup);
-- 
1.6.0.5

