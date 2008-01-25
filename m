Return-Path: <linux-kernel-owner+w=401wt.eu-S1759249AbYAYHU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249AbYAYHU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758258AbYAYHPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:15:13 -0500
Received: from ns2.suse.de ([195.135.220.15]:47479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757527AbYAYHPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:15:11 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tony Jones <tonyj@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 021/196] ISDN: Convert from class_device to device for ISDN capi
Date: Thu, 24 Jan 2008 23:09:19 -0800
Message-Id: <1201245134-4876-21-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Jones <tonyj@suse.de>

Signed-off-by: Tony Jones <tonyj@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/isdn/capi/capi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index f449dae..23ae66c 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1544,11 +1544,11 @@ static int __init capi_init(void)
 		return PTR_ERR(capi_class);
 	}
 
-	class_device_create(capi_class, NULL, MKDEV(capi_major, 0), NULL, "capi");
+	device_create(capi_class, NULL, MKDEV(capi_major, 0), "capi");
 
 #ifdef CONFIG_ISDN_CAPI_MIDDLEWARE
 	if (capinc_tty_init() < 0) {
-		class_device_destroy(capi_class, MKDEV(capi_major, 0));
+		device_destroy(capi_class, MKDEV(capi_major, 0));
 		class_destroy(capi_class);
 		unregister_chrdev(capi_major, "capi20");
 		return -ENOMEM;
@@ -1576,7 +1576,7 @@ static void __exit capi_exit(void)
 {
 	proc_exit();
 
-	class_device_destroy(capi_class, MKDEV(capi_major, 0));
+	device_destroy(capi_class, MKDEV(capi_major, 0));
 	class_destroy(capi_class);
 	unregister_chrdev(capi_major, "capi20");
 
-- 
1.5.3.8

