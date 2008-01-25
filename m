Return-Path: <linux-kernel-owner+w=401wt.eu-S1761779AbYAYHgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761779AbYAYHgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758974AbYAYHSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:18:05 -0500
Received: from mail.suse.de ([195.135.220.2]:52842 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759394AbYAYHSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:18:03 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 062/196] kset: convert drivers/base/firmware.c to use kset_create
Date: Thu, 24 Jan 2008 23:10:00 -0800
Message-Id: <1201245134-4876-62-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/base/firmware.c b/drivers/base/firmware.c
index 336be04..6a4e494 100644
--- a/drivers/base/firmware.c
+++ b/drivers/base/firmware.c
@@ -15,11 +15,11 @@
 
 #include "base.h"
 
-static decl_subsys(firmware, NULL);
+static struct kset *firmware_kset;
 
 int firmware_register(struct kset *s)
 {
-	s->kobj.kset = &firmware_subsys;
+	s->kobj.kset = firmware_kset;
 	s->kobj.ktype = NULL;
 	return subsystem_register(s);
 }
@@ -31,7 +31,10 @@ void firmware_unregister(struct kset *s)
 
 int __init firmware_init(void)
 {
-	return subsystem_register(&firmware_subsys);
+	firmware_kset = kset_create_and_add("firmware", NULL, NULL);
+	if (!firmware_kset)
+		return -ENOMEM;
+	return 0;
 }
 
 EXPORT_SYMBOL_GPL(firmware_register);
-- 
1.5.3.8

