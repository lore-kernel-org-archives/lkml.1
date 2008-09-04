Return-Path: <linux-kernel-owner+w=401wt.eu-S1758176AbYIDNAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbYIDNAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 09:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757698AbYIDM7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:59:54 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43581 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbYIDM7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:59:53 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, Anssi Hannula <anssi.hannula@gmail.com>,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 5/5] HID: convert to dev_* prints
Date: Thu,  4 Sep 2008 14:59:47 +0200
Message-Id: <1220533187-21848-5-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0
In-Reply-To: <1220533187-21848-4-git-send-email-jirislaby@gmail.com>
References: <1220533187-21848-1-git-send-email-jirislaby@gmail.com>
 <1220533187-21848-2-git-send-email-jirislaby@gmail.com>
 <1220533187-21848-3-git-send-email-jirislaby@gmail.com>
 <1220533187-21848-4-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we have a real device bound to a driver, we may use struct
device for printing. Use dev_* functions instead of printks in
3 drivers.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/hid/hid-lg2ff.c |    8 ++++----
 drivers/hid/hid-pl.c    |   11 ++++++-----
 drivers/hid/hid-zpff.c  |    6 +++---
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/hid/hid-lg2ff.c b/drivers/hid/hid-lg2ff.c
index b2e9a67..4e6dc6e 100644
--- a/drivers/hid/hid-lg2ff.c
+++ b/drivers/hid/hid-lg2ff.c
@@ -71,18 +71,18 @@ int lg2ff_init(struct hid_device *hid)
 	int error;
 
 	if (list_empty(report_list)) {
-		printk(KERN_ERR "hid-lg2ff: no output report found\n");
+		dev_err(&hid->dev, "no output report found\n");
 		return -ENODEV;
 	}
 
 	report = list_entry(report_list->next, struct hid_report, list);
 
 	if (report->maxfield < 1) {
-		printk(KERN_ERR "hid-lg2ff: output report is empty\n");
+		dev_err(&hid->dev, "output report is empty\n");
 		return -ENODEV;
 	}
 	if (report->field[0]->report_count < 7) {
-		printk(KERN_ERR "hid-lg2ff: not enough values in the field\n");
+		dev_err(&hid->dev, "not enough values in the field\n");
 		return -ENODEV;
 	}
 
@@ -109,7 +109,7 @@ int lg2ff_init(struct hid_device *hid)
 
 	usbhid_submit_report(hid, report, USB_DIR_OUT);
 
-	printk(KERN_INFO "Force feedback for Logitech Rumblepad 2 by "
+	dev_info(&hid->dev, "Force feedback for Logitech Rumblepad 2 by "
 	       "Anssi Hannula <anssi.hannula@gmail.com>\n");
 
 	return 0;
diff --git a/drivers/hid/hid-pl.c b/drivers/hid/hid-pl.c
index b450084..682cac1 100644
--- a/drivers/hid/hid-pl.c
+++ b/drivers/hid/hid-pl.c
@@ -90,7 +90,7 @@ static int plff_init(struct hid_device *hid)
 	   currently unknown. */
 
 	if (list_empty(report_list)) {
-		printk(KERN_ERR "hid-plff: no output reports found\n");
+		dev_err(&hid->dev, "no output reports found\n");
 		return -ENODEV;
 	}
 
@@ -99,18 +99,19 @@ static int plff_init(struct hid_device *hid)
 		report_ptr = report_ptr->next;
 
 		if (report_ptr == report_list) {
-			printk(KERN_ERR "hid-plff: required output report is missing\n");
+			dev_err(&hid->dev, "required output report is "
+					"missing\n");
 			return -ENODEV;
 		}
 
 		report = list_entry(report_ptr, struct hid_report, list);
 		if (report->maxfield < 1) {
-			printk(KERN_ERR "hid-plff: no fields in the report\n");
+			dev_err(&hid->dev, "no fields in the report\n");
 			return -ENODEV;
 		}
 
 		if (report->field[0]->report_count < 4) {
-			printk(KERN_ERR "hid-plff: not enough values in the field\n");
+			dev_err(&hid->dev, "not enough values in the field\n");
 			return -ENODEV;
 		}
 
@@ -136,7 +137,7 @@ static int plff_init(struct hid_device *hid)
 		usbhid_submit_report(hid, plff->report, USB_DIR_OUT);
 	}
 
-	printk(KERN_INFO "hid-plff: Force feedback for PantherLord/GreenAsia "
+	dev_info(&hid->dev, "Force feedback for PantherLord/GreenAsia "
 	       "devices by Anssi Hannula <anssi.hannula@gmail.com>\n");
 
 	return 0;
diff --git a/drivers/hid/hid-zpff.c b/drivers/hid/hid-zpff.c
index 9ed04ee..ea82f37 100644
--- a/drivers/hid/hid-zpff.c
+++ b/drivers/hid/hid-zpff.c
@@ -73,14 +73,14 @@ static int zpff_init(struct hid_device *hid)
 	int error;
 
 	if (list_empty(report_list)) {
-		printk(KERN_ERR "hid-zpff: no output report found\n");
+		dev_err(&hid->dev, "no output report found\n");
 		return -ENODEV;
 	}
 
 	report = list_entry(report_list->next, struct hid_report, list);
 
 	if (report->maxfield < 4) {
-		printk(KERN_ERR "hid-zpff: not enough fields in report\n");
+		dev_err(&hid->dev, "not enough fields in report\n");
 		return -ENODEV;
 	}
 
@@ -103,7 +103,7 @@ static int zpff_init(struct hid_device *hid)
 	zpff->report->field[3]->value[0] = 0x00;
 	usbhid_submit_report(hid, zpff->report, USB_DIR_OUT);
 
-	printk(KERN_INFO "Force feedback for Zeroplus based devices by "
+	dev_info(&hid->dev, "force feedback for Zeroplus based devices by "
 	       "Anssi Hannula <anssi.hannula@gmail.com>\n");
 
 	return 0;
-- 
1.6.0

