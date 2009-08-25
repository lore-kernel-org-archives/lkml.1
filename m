Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbZHYUgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbZHYUgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 16:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbZHYUgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 16:36:37 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:43855 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbZHYUgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 16:36:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=rXBw+tHmYh9KCHBTaMvz0MxikuhSba/h2qItF2mcJ5LNuAhpgR19lbObpt4riDUzcj
         EMw1tjp6VpLDNEbGYzeB+HAF8R3iSvJv5zCEuU1gH7cHdUaMsu+3/S3REyjb7gMJRnVh
         pmWStHjgNi93FsMCgUbi7cN2tWeFHmTtW5WUg=
MIME-Version: 1.0
Date: Wed, 26 Aug 2009 00:36:36 +0400
Message-ID: <a872555b0908251336q2c4ee970qa12500d35d4e144e@mail.gmail.com>
Subject: [PATCH] Remove multiple definitions of the to_dev() macro
From: Denis Kirjanov <kirjanov@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove multiple definitions of the to_dev() macro

Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
---
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 7ecb193..6fd7d16 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -62,7 +62,6 @@ const char *dev_driver_string(const struct device *dev)
 }
 EXPORT_SYMBOL(dev_driver_string);

-#define to_dev(obj) container_of(obj, struct device, kobj)
 #define to_dev_attr(_attr) container_of(_attr, struct device_attribute, attr)

 static ssize_t dev_attr_show(struct kobject *kobj, struct attribute *attr,
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 7376367..9493c88 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -21,8 +21,6 @@
 #include <linux/firmware.h>
 #include "base.h"

-#define to_dev(obj) container_of(obj, struct device, kobj)
-
 MODULE_AUTHOR("Manuel Estrada Sainz");
 MODULE_DESCRIPTION("Multi purpose firmware loading support");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 55bf34f..7d4101a 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -38,7 +38,6 @@

 #include "bonding.h"

-#define to_dev(obj)	container_of(obj, struct device, kobj)
 #define to_bond(cd)	((struct bonding *)(netdev_priv(to_net_dev(cd))))

 /*
diff --git a/include/linux/device.h b/include/linux/device.h
index aebb810..c2b4ac9 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -364,6 +364,7 @@ struct device_dma_parameters {
 	unsigned long segment_boundary_mask;
 };

+#define to_dev(obj) container_of(obj, struct device, kobj)
 struct device {
 	struct device		*parent;

diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index ee4820a..41ed613 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -18,10 +18,10 @@
 #include <linux/rtnetlink.h>
 #include <linux/spinlock.h>
 #include <linux/times.h>
+#include <linux/device.h>

 #include "br_private.h"

-#define to_dev(obj)	container_of(obj, struct device, kobj)
 #define to_bridge(cd)	((struct net_bridge *)netdev_priv(to_net_dev(cd)))

 /*
