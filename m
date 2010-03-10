Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab0CJLiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 06:38:55 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:53982 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab0CJLiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 06:38:54 -0500
Date: Wed, 10 Mar 2010 06:37:11 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org
Subject: [PATCH] Documentation:  Update "struct bus_type" definition.
Message-ID: <alpine.LFD.2.00.1003100634400.5419@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  not sure if the rest of this doc file needs updating as well but, at
the very least, the defintion of "struct bus_type" should be updated
to no longer refer to kset-related content or the obsolete "struct
subsystem."

diff --git a/Documentation/driver-model/bus.txt b/Documentation/driver-model/bus.txt
index 5001b75..32650be 100644
--- a/Documentation/driver-model/bus.txt
+++ b/Documentation/driver-model/bus.txt
@@ -5,24 +5,27 @@ Definition
 ~~~~~~~~~~

 struct bus_type {
-	char			* name;
+        const char              *name;
+        struct bus_attribute    *bus_attrs;
+        struct device_attribute *dev_attrs;
+        struct driver_attribute *drv_attrs;

-	struct subsystem	subsys;
-	struct kset		drivers;
-	struct kset		devices;
+        int (*match)(struct device *dev, struct device_driver *drv);
+        int (*uevent)(struct device *dev, struct kobj_uevent_env *env);
+        int (*probe)(struct device *dev);
+        int (*remove)(struct device *dev);
+        void (*shutdown)(struct device *dev);

-	struct bus_attribute	* bus_attrs;
-	struct device_attribute	* dev_attrs;
-	struct driver_attribute	* drv_attrs;
+        int (*suspend)(struct device *dev, pm_message_t state);
+        int (*resume)(struct device *dev);

-	int		(*match)(struct device * dev, struct device_driver * drv);
-	int		(*hotplug) (struct device *dev, char **envp,
-				    int num_envp, char *buffer, int buffer_size);
-	int		(*suspend)(struct device * dev, pm_message_t state);
-	int		(*resume)(struct device * dev);
+        const struct dev_pm_ops *pm;
+
+        struct bus_type_private *p;
 };

-int bus_register(struct bus_type * bus);
+extern int __must_check bus_register(struct bus_type *bus);
+extern void bus_unregister(struct bus_type *bus);


 Declaration


rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
