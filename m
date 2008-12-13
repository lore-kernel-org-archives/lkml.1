Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbYLMKeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbYLMKeU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 05:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbYLMKeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 05:34:09 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:2853 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbYLMKeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 05:34:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Z+O5C58COlUnPl3muUuhE5j1/cq5MBKbL5YV3Y6Vvh8it42PSGOWULROaCfDk3s/pF
         HGg5y9NrvgbFRpGbazdIz9yzzF8MAj3MDORCEAW25qjPmgeAdEDaQhxr/UriOGKnofiH
         Le5qmsu8d4wHg5ZM00gAnoAmZIi3eJ+JR868M=
From: tom.leiming@gmail.com
To: kay.sievers@vrfy.org, greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] driver core: don't pass cls->name as format string in sysdev_class_register()
Date: Sat, 13 Dec 2008 18:34:00 +0800
Message-Id: <1229164440-4631-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

If cls->name contains substring which can be interpreted as
format,maybe it causes oops, so fix it.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/base/sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index c98c31e..736ecf7 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -137,7 +137,7 @@ int sysdev_class_register(struct sysdev_class * cls)
 	cls->kset.kobj.parent = &system_kset->kobj;
 	cls->kset.kobj.ktype = &ktype_sysdev_class;
 	cls->kset.kobj.kset = system_kset;
-	kobject_set_name(&cls->kset.kobj, cls->name);
+	kobject_set_name(&cls->kset.kobj, "%s", cls->name);
 	return kset_register(&cls->kset);
 }
 
-- 
1.6.0

