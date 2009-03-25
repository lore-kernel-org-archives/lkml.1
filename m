Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbZCYAjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbZCYAjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756860AbZCYAaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:04 -0400
Received: from kroah.org ([198.145.64.141]:54106 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756849AbZCYA37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:59 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 27/61] PS3: replace bus_id usage
Date: Tue, 24 Mar 2009 17:26:31 -0700
Message-Id: <1237940825-22904-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These simple debug statments should be using dev_dbg() instead of
accessing bus_id directly (or they should use device_name).

As bus_id is going away, this patch is necessary.

Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/platforms/ps3/system-bus.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index 58311a8..a705fff 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -376,7 +376,7 @@ static int ps3_system_bus_probe(struct device *_dev)
 	struct ps3_system_bus_driver *drv;
 
 	BUG_ON(!dev);
-	pr_debug(" -> %s:%d: %s\n", __func__, __LINE__, _dev->bus_id);
+	dev_dbg(_dev, "%s:%d\n", __func__, __LINE__);
 
 	drv = ps3_system_bus_dev_to_system_bus_drv(dev);
 	BUG_ON(!drv);
@@ -398,7 +398,7 @@ static int ps3_system_bus_remove(struct device *_dev)
 	struct ps3_system_bus_driver *drv;
 
 	BUG_ON(!dev);
-	pr_debug(" -> %s:%d: %s\n", __func__, __LINE__, _dev->bus_id);
+	dev_dbg(_dev, "%s:%d\n", __func__, __LINE__);
 
 	drv = ps3_system_bus_dev_to_system_bus_drv(dev);
 	BUG_ON(!drv);
-- 
1.6.2

