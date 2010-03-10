Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0CJLuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 06:50:46 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33953 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab0CJLun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 06:50:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=qL9JWEx7RXSLWyeIydQ5fyRznSpmmA0xEMF20a9mU+HWEMbupb7M4kO+NtCPkXuyIS
         RZuVaRbtoQxgCDFE6BlWItJo2/jsuKNHU3UG9ytcfaKxsCEc9nuTwCcap+dYYdJd3RAP
         NtbKN6/LFUPv4EshBOQamAKuNkGz9Sv01PaTI=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, gregkh@suse.de, rdunlap@xenotime.net
Date: Wed, 10 Mar 2010 20:50:38 +0900
Message-Id: <20100310115038.21785.46115.sendpatchset@t400s>
Subject: [PATCH] Driver core: Early platform kernel-doc update
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This patch updates the kernel-doc notation for early
platform functions.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/base/platform.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- 0001/drivers/base/platform.c
+++ work/drivers/base/platform.c	2010-03-10 20:45:06.000000000 +0900
@@ -1052,9 +1052,11 @@ static __initdata LIST_HEAD(early_platfo
 static __initdata LIST_HEAD(early_platform_device_list);
 
 /**
- * early_platform_driver_register
+ * early_platform_driver_register - register early platform driver
  * @epdrv: early_platform driver structure
  * @buf: string passed from early_param()
+ *
+ * Helper function for early_platform_init() / early_platform_init_buffer()
  */
 int __init early_platform_driver_register(struct early_platform_driver *epdrv,
 					  char *buf)
@@ -1106,9 +1108,12 @@ int __init early_platform_driver_registe
 }
 
 /**
- * early_platform_add_devices - add a numbers of early platform devices
+ * early_platform_add_devices - adds a number of early platform devices
  * @devs: array of early platform devices to add
  * @num: number of early platform devices in array
+ *
+ * Used by early architecture code to register early platform devices and
+ * their platform data.
  */
 void __init early_platform_add_devices(struct platform_device **devs, int num)
 {
@@ -1128,8 +1133,12 @@ void __init early_platform_add_devices(s
 }
 
 /**
- * early_platform_driver_register_all
+ * early_platform_driver_register_all - register early platform drivers
  * @class_str: string to identify early platform driver class
+ *
+ * Used by architecture code to register all early platform drivers
+ * for a certain class. If omitted then only early platform drivers
+ * with matching kernel command line class parameters will be registered.
  */
 void __init early_platform_driver_register_all(char *class_str)
 {
@@ -1151,7 +1160,7 @@ void __init early_platform_driver_regist
 }
 
 /**
- * early_platform_match
+ * early_platform_match - find early platform device matching driver
  * @epdrv: early platform driver structure
  * @id: id to match against
  */
@@ -1169,7 +1178,7 @@ early_platform_match(struct early_platfo
 }
 
 /**
- * early_platform_left
+ * early_platform_left - check if early platform driver has matching devices
  * @epdrv: early platform driver structure
  * @id: return true if id or above exists
  */
@@ -1187,7 +1196,7 @@ static  __init int early_platform_left(s
 }
 
 /**
- * early_platform_driver_probe_id
+ * early_platform_driver_probe_id - probe drivers matching class_str and id
  * @class_str: string to identify early platform driver class
  * @id: id to match against
  * @nr_probe: number of platform devices to successfully probe before exiting
@@ -1257,10 +1266,14 @@ static int __init early_platform_driver_
 }
 
 /**
- * early_platform_driver_probe
+ * early_platform_driver_probe - probe a class of registered drivers
  * @class_str: string to identify early platform driver class
  * @nr_probe: number of platform devices to successfully probe before exiting
  * @user_only: only probe user specified early platform devices
+ *
+ * Used by architecture code to probe registered early platform drivers
+ * within a certain class. For probe to happen a registered early platform
+ * device matching a registered early platform driver is needed.
  */
 int __init early_platform_driver_probe(char *class_str,
 				       int nr_probe,
