Return-Path: <linux-kernel-owner+w=401wt.eu-S1763377AbYENRvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763377AbYENRvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762932AbYENRuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:50:39 -0400
Received: from ns2.suse.de ([195.135.220.15]:38463 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760985AbYENRu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:50:26 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/2] Driver core: struct class remove children list
Date: Wed, 14 May 2008 10:49:55 -0700
Message-Id: <1210787395-25887-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080514174920.GA25856@suse.de>
References: <20080514174920.GA25856@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>

because of the class_device was removed, now do the children list removing

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/class.c   |    1 -
 include/linux/device.h |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 0ef00e8..e085af0 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -140,7 +140,6 @@ int class_register(struct class *cls)
 
 	pr_debug("device class '%s': registering\n", cls->name);
 
-	INIT_LIST_HEAD(&cls->children);
 	INIT_LIST_HEAD(&cls->devices);
 	INIT_LIST_HEAD(&cls->interfaces);
 	kset_init(&cls->class_dirs);
diff --git a/include/linux/device.h b/include/linux/device.h
index 8c23e3d..15e9fa3 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -183,7 +183,6 @@ struct class {
 	struct module		*owner;
 
 	struct kset		subsys;
-	struct list_head	children;
 	struct list_head	devices;
 	struct list_head	interfaces;
 	struct kset		class_dirs;
-- 
1.5.5.1

