Return-Path: <linux-kernel-owner+w=401wt.eu-S1754289AbYJOCVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbYJOCVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 22:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbYJOCVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 22:21:06 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:55455 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYJOCVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 22:21:05 -0400
Date: Sat, 11 Oct 2008 02:36:45 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 85/85] panasonic-laptop: fix build
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>
Message-id: <2f7398c9ee4c227ec9a68d547e24dfd196612093.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

sync with acpi_driver_data(device)
and acpi_evaluate_integer(..., long long)
changes that happened since this driver
was checked in.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/misc/panasonic-laptop.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/panasonic-laptop.c b/drivers/misc/panasonic-laptop.c
index 9aecda5..a2cb598 100644
--- a/drivers/misc/panasonic-laptop.c
+++ b/drivers/misc/panasonic-laptop.c
@@ -252,7 +252,7 @@ static int acpi_pcc_write_sset(struct pcc_acpi *pcc, int func, int val)
 
 static inline int acpi_pcc_get_sqty(struct acpi_device *device)
 {
-	unsigned long s;
+	unsigned long long s;
 	acpi_status status;
 
 	ACPI_FUNCTION_TRACE("acpi_pcc_get_sqty");
@@ -500,7 +500,7 @@ static void acpi_pcc_generate_keyinput(struct pcc_acpi *pcc)
 	struct input_dev *hotk_input_dev = pcc->input_dev;
 	int rc;
 	int key_code, hkey_num;
-	unsigned long result;
+	unsigned long long result;
 
 	ACPI_FUNCTION_TRACE("acpi_pcc_generate_keyinput");
 
@@ -645,7 +645,7 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 	pcc->device = device;
 	pcc->handle = device->handle;
 	pcc->num_sifr = num_sifr;
-	acpi_driver_data(device) = pcc;
+	device->driver_data = pcc;
 	strcpy(acpi_device_name(device), ACPI_PCC_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_PCC_CLASS);
 
-- 
1.5.5.1

