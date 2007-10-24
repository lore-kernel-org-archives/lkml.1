Return-Path: <linux-kernel-owner+w=401wt.eu-S1763494AbXJXQla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763494AbXJXQla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbXJXQZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:25:43 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60957 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759937AbXJXQZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:25:08 -0400
Date: Wed, 24 Oct 2007 18:25:37 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] acpi/battery.c: remove dead code
Message-ID: <20071024162537.GA30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After commit f1d4661abe05d0a2c014166042d15ed8b69ae8f2 this was dead 
code.

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- linux-2.6/drivers/acpi/battery.c.old	2007-10-23 18:44:13.000000000 +0200
+++ linux-2.6/drivers/acpi/battery.c	2007-10-23 18:44:43.000000000 +0200
@@ -550,18 +550,14 @@ static ssize_t acpi_battery_write_alarm(
 	int result = 0;
 	char alarm_string[12] = { '\0' };
 	struct seq_file *m = file->private_data;
 	struct acpi_battery *battery = m->private;
 
 	if (!battery || (count > sizeof(alarm_string) - 1))
 		return -EINVAL;
-	if (result) {
-		result = -ENODEV;
-		goto end;
-	}
 	if (!acpi_battery_present(battery)) {
 		result = -ENODEV;
 		goto end;
 	}
 	if (copy_from_user(alarm_string, buffer, count)) {
 		result = -EFAULT;
 		goto end;

