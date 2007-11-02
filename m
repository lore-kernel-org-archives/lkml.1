Return-Path: <linux-kernel-owner+w=401wt.eu-S1763826AbXKCANb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763826AbXKCANb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761943AbXKCACv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:02:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34937 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761936AbXKCACu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:02:50 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Matt Tolentino <matthew.e.tolentino@intel.com>
Subject: [PATCH 40/54] firmware: export firmware_kset so that people can use that instead of the braindead firmware_register interface
Date: Fri,  2 Nov 2007 16:59:18 -0700
Message-Id: <1194047972-9850-40-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Needed for future firmware subsystem cleanups.

In the end, the firmware_register/unregister functions will be deleted
entirely, but we need this symbol so that subsystems can migrate over.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Matt Tolentino <matthew.e.tolentino@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware.c |    3 ++-
 include/linux/kobject.h |    2 ++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/base/firmware.c b/drivers/base/firmware.c
index d1c2ef4..d225059 100644
--- a/drivers/base/firmware.c
+++ b/drivers/base/firmware.c
@@ -16,7 +16,8 @@
 
 #include "base.h"
 
-static struct kset *firmware_kset;
+struct kset *firmware_kset;
+EXPORT_SYMBOL_GPL(firmware_kset);
 
 int firmware_register(struct kset *s)
 {
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index cf9768a..3aa8108 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -204,6 +204,8 @@ extern struct kset *kernel_kset;
 extern struct kset *hypervisor_kset;
 /* The global /sys/power/ kset for people to chain off of */
 extern struct kset *power_kset;
+/* The global /sys/firmware/ kset for people to chain off of */
+extern struct kset *firmware_kset;
 
 extern int __must_check subsystem_register(struct kset *);
 extern void subsystem_unregister(struct kset *);
-- 
1.5.3.4

