Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579Ab0ATHGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab0ATHGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 02:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019Ab0ATHGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 02:06:35 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:7720 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab0ATHGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 02:06:32 -0500
Subject: [PATCH 1/2] ACPI: processor: add kernel command line support for
	early _PDC eval
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 20 Jan 2010 00:06:30 -0700
Message-ID: <20100120070630.19777.9292.stgit@bob.kio>
In-Reply-To: <20100120070403.19777.31978.stgit@bob.kio>
References: <20100120070403.19777.31978.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow platforms not listed in DMI table to opt-in and evaluate _PDC
early.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 Documentation/kernel-parameters.txt |    4 ++++
 drivers/acpi/processor_pdc.c        |    7 +++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 736d456..826b6e1 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -199,6 +199,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			acpi_display_output=video
 			See above.
 
+	acpi_early_pdc_eval	[HW,ACPI] Evaluate processor _PDC methods
+				early. Needed on some platforms to properly
+				initialize the EC.
+
 	acpi_irq_balance [HW,ACPI]
 			ACPI will balance active IRQs
 			default in APIC mode
diff --git a/drivers/acpi/processor_pdc.c b/drivers/acpi/processor_pdc.c
index f336437..2944e7d 100644
--- a/drivers/acpi/processor_pdc.c
+++ b/drivers/acpi/processor_pdc.c
@@ -151,6 +151,13 @@ static int set_early_pdc_optin(const struct dmi_system_id *id)
 	return 0;
 }
 
+static int param_early_pdc_optin(char *s)
+{
+	early_pdc_optin = 1;
+	return 1;
+}
+__setup("acpi_early_pdc_eval", param_early_pdc_optin);
+
 static struct dmi_system_id __cpuinitdata early_pdc_optin_table[] = {
 	{
 	set_early_pdc_optin, "HP Envy", {

