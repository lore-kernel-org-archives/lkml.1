Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbZLMX5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbZLMX5X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 18:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbZLMX5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34519 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681AbZLMX5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:18 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, lenb@kernel.org, bjorn.helgaas@hp.com,
       ming.m.lin@intel.com, robert.moore@intel.com,
       torvalds@linux-foundation.org
Subject: [PATCH 1/3] Constify struct acpi_dock_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:58:59 +0100
Message-Id: <4db4bc6fb310538aa53c9434394594bfbae284be.1260662994.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662994.git.re.emese@gmail.com>
References: <cover.1260662994.git.re.emese@gmail.com>
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/acpi/dock.c         |    4 ++--
 include/acpi/acpi_drivers.h |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 30be3c1..b3a5492 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -77,7 +77,7 @@ struct dock_dependent_device {
 	struct list_head list;
 	struct list_head hotplug_list;
 	acpi_handle handle;
-	struct acpi_dock_ops *ops;
+	const struct acpi_dock_ops *ops;
 	void *context;
 };
 
@@ -605,7 +605,7 @@ EXPORT_SYMBOL_GPL(unregister_dock_notifier);
  * the dock driver after _DCK is executed.
  */
 int
-register_hotplug_dock_device(acpi_handle handle, struct acpi_dock_ops *ops,
+register_hotplug_dock_device(acpi_handle handle, const struct acpi_dock_ops *ops,
 			     void *context)
 {
 	struct dock_dependent_device *dd;
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index f4906f6..71feb73 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -119,8 +119,8 @@ int acpi_processor_set_thermal_limit(acpi_handle handle, int type);
                                   Dock Station
   -------------------------------------------------------------------------- */
 struct acpi_dock_ops {
-	acpi_notify_handler handler;
-	acpi_notify_handler uevent;
+	const acpi_notify_handler handler;
+	const acpi_notify_handler uevent;
 };
 
 #if defined(CONFIG_ACPI_DOCK) || defined(CONFIG_ACPI_DOCK_MODULE)
@@ -128,7 +128,7 @@ extern int is_dock_device(acpi_handle handle);
 extern int register_dock_notifier(struct notifier_block *nb);
 extern void unregister_dock_notifier(struct notifier_block *nb);
 extern int register_hotplug_dock_device(acpi_handle handle,
-					struct acpi_dock_ops *ops,
+					const struct acpi_dock_ops *ops,
 					void *context);
 extern void unregister_hotplug_dock_device(acpi_handle handle);
 #else
@@ -144,7 +144,7 @@ static inline void unregister_dock_notifier(struct notifier_block *nb)
 {
 }
 static inline int register_hotplug_dock_device(acpi_handle handle,
-					       struct acpi_dock_ops *ops,
+					       const struct acpi_dock_ops *ops,
 					       void *context)
 {
 	return -ENODEV;
-- 
1.6.5.3

