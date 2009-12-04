Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbZLDWEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbZLDWEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbZLDWEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:04:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56601 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757347AbZLDWEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:04:22 -0500
Message-ID: <4B1987AE.8000800@gmail.com>
Date: Fri, 04 Dec 2009 23:05:34 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: lenb@kernel.org, jgarzik@pobox.com, jbarnes@virtuousgeek.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/31] Constify struct acpi_dock_ops for 2.6.32 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
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

Constify struct acpi_dock_ops.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/acpi/dock.c                |    4 ++--
 drivers/ata/libata-acpi.c          |    4 ++--
 drivers/pci/hotplug/acpiphp_glue.c |    2 +-
 include/acpi/acpi_drivers.h        |    8 ++++----
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 7338b6a..82f0257 100644
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
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index b0882cd..c295d65 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -223,12 +223,12 @@ static void ata_acpi_dev_uevent(acpi_handle handle, u32 event, void *data)
 	ata_acpi_uevent(dev->link->ap, dev, event);
 }
 
-static struct acpi_dock_ops ata_acpi_dev_dock_ops = {
+static const struct acpi_dock_ops ata_acpi_dev_dock_ops = {
 	.handler = ata_acpi_dev_notify_dock,
 	.uevent = ata_acpi_dev_uevent,
 };
 
-static struct acpi_dock_ops ata_acpi_ap_dock_ops = {
+static const struct acpi_dock_ops ata_acpi_ap_dock_ops = {
 	.handler = ata_acpi_ap_notify_dock,
 	.uevent = ata_acpi_ap_uevent,
 };
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 58d25a1..3e5aacb 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -111,7 +111,7 @@ static int post_dock_fixups(struct notifier_block *nb, unsigned long val,
 }
 
 
-static struct acpi_dock_ops acpiphp_dock_ops = {
+static const struct acpi_dock_ops acpiphp_dock_ops = {
 	.handler = handle_hotplug_event_func,
 };
 
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
