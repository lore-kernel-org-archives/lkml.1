Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbZAZRgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbZAZRgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZAZRgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:36:31 -0500
Received: from kroah.org ([198.145.64.141]:33411 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751856AbZAZRgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:36:31 -0500
Date: Mon, 26 Jan 2009 09:30:19 -0800
From: Greg KH <greg@kroah.com>
To: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: PS3: replace bus_id usage
Message-ID: <20090126173019.GA12010@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Greg Kroah-Hartman <gregkh@suse.de>

These simple debug statments should be using dev_dbg() instead of
accessing bus_id directly (or they should use device_name).

As bus_id is going away, this patch is necessary.

Cc: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---

This fixes a built-breakage in linux-next.  I'll be glad to keep this in
my tree if you don't want to take it in yours, just let me know.

 arch/powerpc/platforms/ps3/system-bus.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -376,7 +376,7 @@ static int ps3_system_bus_probe(struct d
 	struct ps3_system_bus_driver *drv;
 
 	BUG_ON(!dev);
-	pr_debug(" -> %s:%d: %s\n", __func__, __LINE__, _dev->bus_id);
+	dev_dbg(_dev, "%s:%d\n", __func__, __LINE__);
 
 	drv = ps3_system_bus_dev_to_system_bus_drv(dev);
 	BUG_ON(!drv);
@@ -398,7 +398,7 @@ static int ps3_system_bus_remove(struct 
 	struct ps3_system_bus_driver *drv;
 
 	BUG_ON(!dev);
-	pr_debug(" -> %s:%d: %s\n", __func__, __LINE__, _dev->bus_id);
+	dev_dbg(_dev, "%s:%d\n", __func__, __LINE__);
 
 	drv = ps3_system_bus_dev_to_system_bus_drv(dev);
 	BUG_ON(!drv);
