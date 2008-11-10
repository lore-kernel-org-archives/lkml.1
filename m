Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbYKJVei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbYKJVei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 16:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbYKJVe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 16:34:27 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53506 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbYKJVe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 16:34:26 -0500
Date: Mon, 10 Nov 2008 22:51:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: jkosina@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] Use single threaded work queue for hid_compat
Message-ID: <20081110215150.GA8460@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use single threaded work queue for hid_compat

I doubt HID really needs to scale over multiple CPUs. So only use a
single threaded workqueue for HID_COMPAT. This avoids some excessive
thread use on systems with a larger number of CPUs.

Should still go into 2.6.28 if possible.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/hid/hid-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.28-rc4-test/drivers/hid/hid-core.c
===================================================================
--- linux-2.6.28-rc4-test.orig/drivers/hid/hid-core.c	2008-11-06 20:26:34.000000000 +0100
+++ linux-2.6.28-rc4-test/drivers/hid/hid-core.c	2008-11-10 22:36:49.000000000 +0100
@@ -1729,7 +1729,7 @@
 		goto err_bus;
 
 #ifdef CONFIG_HID_COMPAT
-	hid_compat_wq = create_workqueue("hid_compat");
+	hid_compat_wq = create_singlethread_workqueue("hid_compat");
 	if (!hid_compat_wq) {
 		hidraw_exit();
 		goto err;
