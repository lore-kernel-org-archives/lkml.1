Return-Path: <linux-kernel-owner+w=401wt.eu-S1761877AbYAYHm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761877AbYAYHm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759612AbYAYHTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:19:17 -0500
Received: from mail.suse.de ([195.135.220.2]:53018 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759375AbYAYHTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:19:15 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Matt Tolentino <matthew.e.tolentino@intel.com>
Subject: [PATCH 079/196] firmware: export firmware_kset so that people can use that instead of the braindead firmware_register interface
Date: Thu, 24 Jan 2008 23:10:17 -0800
Message-Id: <1201245134-4876-79-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
index 6a4e494..c7f635b 100644
--- a/drivers/base/firmware.c
+++ b/drivers/base/firmware.c
@@ -15,7 +15,8 @@
 
 #include "base.h"
 
-static struct kset *firmware_kset;
+struct kset *firmware_kset;
+EXPORT_SYMBOL_GPL(firmware_kset);
 
 int firmware_register(struct kset *s)
 {
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index e694261..29dc444 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -210,6 +210,8 @@ extern struct kset *kernel_kset;
 extern struct kobject *hypervisor_kobj;
 /* The global /sys/power/ kset for people to chain off of */
 extern struct kset *power_kset;
+/* The global /sys/firmware/ kset for people to chain off of */
+extern struct kset *firmware_kset;
 
 extern int __must_check subsystem_register(struct kset *);
 extern void subsystem_unregister(struct kset *);
-- 
1.5.3.8

