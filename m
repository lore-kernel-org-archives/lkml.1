Return-Path: <linux-kernel-owner+w=401wt.eu-S932916AbYCFCZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916AbYCFCZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYCFCY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:24:56 -0500
Received: from gv-out-0910.google.com ([216.239.58.187]:26847 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423AbYCFCYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:24:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=icBW3c+cr3/nzEI9M0o3fRI25ZdPV2WI9j6rwNrSMl4WOkOQwGRWrRESSu5kwGb1WmUgMmKTK63qi6lXb8c55kEPEbsLj4I1sXoHOdf/wSYKMshDWFVL58DmXNYoF8/yZ4lAFEZobqGn8mrL0Y3FIUQDq6haGA8ZCLZirT9aBd4=
Subject: [PATCH 01/16] acpi: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 18:24:51 -0800
Message-Id: <1204770291.14154.37.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/acpi/bus.c               |    2 +-
 drivers/acpi/scan.c              |    2 +-
 drivers/acpi/sleep/main.c        |    2 +-
 drivers/acpi/utilities/utdebug.c |    2 +-
 drivers/acpi/video.c             |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index ce3c0a2..5b6760e 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -776,7 +776,7 @@ static int __init acpi_init(void)
 
 	acpi_kobj = kobject_create_and_add("acpi", firmware_kobj);
 	if (!acpi_kobj) {
-		printk(KERN_WARNING "%s: kset create error\n", __FUNCTION__);
+		printk(KERN_WARNING "%s: kset create error\n", __func__);
 		acpi_kobj = NULL;
 	}
 
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 3fac011..b26e301 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -966,7 +966,7 @@ static void acpi_device_set_id(struct acpi_device *device,
 	case ACPI_BUS_TYPE_DEVICE:
 		status = acpi_get_object_info(handle, &buffer);
 		if (ACPI_FAILURE(status)) {
-			printk(KERN_ERR PREFIX "%s: Error reading device info\n", __FUNCTION__);
+			printk(KERN_ERR PREFIX "%s: Error reading device info\n", __func__);
 			return;
 		}
 
diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index 293a1cb..d2f71a5 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -504,7 +504,7 @@ static void acpi_power_off_prepare(void)
 static void acpi_power_off(void)
 {
 	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
-	printk("%s called\n", __FUNCTION__);
+	printk("%s called\n", __func__);
 	local_irq_disable();
 	acpi_enable_wakeup_device(ACPI_STATE_S5);
 	acpi_enter_sleep_state(ACPI_STATE_S5);
diff --git a/drivers/acpi/utilities/utdebug.c b/drivers/acpi/utilities/utdebug.c
index c7e128e..7361204 100644
--- a/drivers/acpi/utilities/utdebug.c
+++ b/drivers/acpi/utilities/utdebug.c
@@ -109,7 +109,7 @@ void acpi_ut_track_stack_ptr(void)
  * RETURN:      Updated pointer to the function name
  *
  * DESCRIPTION: Remove the "Acpi" prefix from the function name, if present.
- *              This allows compiler macros such as __FUNCTION__ to be used
+ *              This allows compiler macros such as __func__ to be used
  *              with no change to the debug output.
  *
  ******************************************************************************/
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 12cce69..d64a142 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1201,7 +1201,7 @@ static int acpi_video_bus_ROM_seq_show(struct seq_file *seq, void *offset)
 	if (!video)
 		goto end;
 
-	printk(KERN_INFO PREFIX "Please implement %s\n", __FUNCTION__);
+	printk(KERN_INFO PREFIX "Please implement %s\n", __func__);
 	seq_printf(seq, "<TODO>\n");
 
       end:
-- 
1.5.4.GIT


