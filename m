Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbZI1XtC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbZI1XtC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 19:49:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZI1XtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 19:49:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:60896 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753510AbZI1XtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 19:49:00 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/JgcBlpUTJSU14Vk6vk9gEt4uU5xydPgPCt98VgY
	RuRkJhuG2NuDw8
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [PATCH] staging/p9auth:  adding __init/__exit macros
Date: Tue, 29 Sep 2009 01:49:00 +0200
User-Agent: KMail/1.9.10
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>,
       kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909290149.01257.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init/__exit macros to the module_init/
module_exit functions of drivers/staging/p9auth/p9auth.c

Greg, please have a look at the small patch and either pull it through
your staging tree, or please ack' it so Jiri can pull it through the trivial tree.

linux version v2.6.32-rc1 - linus git tree, Di 29. Sep 01:10:18 CEST 2009

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
diff --git a/drivers/staging/p9auth/p9auth.c b/drivers/staging/p9auth/p9auth.c
index 9111dcb..c64ace0 100644
--- a/drivers/staging/p9auth/p9auth.c
+++ b/drivers/staging/p9auth/p9auth.c
@@ -332,6 +332,7 @@ static const struct file_operations cap_fops = {
 	.release = cap_release,
 };
 
+/* no __exit here because it can be called by the init function */
 static void cap_cleanup_module(void)
 {
 	int i;
@@ -358,7 +359,7 @@ static void cap_setup_cdev(struct cap_dev *dev, int index)
 		printk(KERN_NOTICE "Error %d adding cap%d", err, index);
 }
 
-static int cap_init_module(void)
+static int __init cap_init_module(void)
 {
 	int result, i;
 	dev_t dev = 0;
