Return-Path: <linux-kernel-owner+w=401wt.eu-S936196AbZFPFxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936196AbZFPFxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758982AbZFPFvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:00 -0400
Received: from kroah.org ([198.145.64.141]:48318 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761471AbZFPFu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:50:59 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/64] driver-core: make sysdev_class_register check kobject_set_name return value
Date: Mon, 15 Jun 2009 22:46:00 -0700
Message-Id: <1245131213-24168-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>

sysdev_class_register should check the kobject_set_name return value.

Add the return value checking code.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/sys.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 9742a78..162355c 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -131,6 +131,8 @@ static struct kset *system_kset;
 
 int sysdev_class_register(struct sysdev_class *cls)
 {
+	int retval;
+
 	pr_debug("Registering sysdev class '%s'\n", cls->name);
 
 	INIT_LIST_HEAD(&cls->drivers);
@@ -138,7 +140,11 @@ int sysdev_class_register(struct sysdev_class *cls)
 	cls->kset.kobj.parent = &system_kset->kobj;
 	cls->kset.kobj.ktype = &ktype_sysdev_class;
 	cls->kset.kobj.kset = system_kset;
-	kobject_set_name(&cls->kset.kobj, cls->name);
+
+	retval = kobject_set_name(&cls->kset.kobj, cls->name);
+	if (retval)
+		return retval;
+
 	return kset_register(&cls->kset);
 }
 
-- 
1.6.3.2

