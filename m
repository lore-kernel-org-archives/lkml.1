Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbYB1I0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbYB1I0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 03:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbYB1I0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 03:26:35 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:49396 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319AbYB1I0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 03:26:35 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Mark McLoughlin <markmc@redhat.com>
Date: Thu, 28 Feb 2008 08:26:13 +0000
Message-Id: <1204187174-27143-1-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.4.2
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCH 1/2] x86: Add nodmi command line option to turn off DMI parsing.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mark McLoughlin <markmc@redhat.com>
---
 drivers/firmware/dmi_scan.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 4072449..62b6200 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -117,6 +117,12 @@ static int __init dmi_checksum(const u8 *buf)
 static char *dmi_ident[DMI_STRING_MAX];
 static LIST_HEAD(dmi_devices);
 int dmi_available;
+static int __init setup_disable_dmi(char *str)
+{
+	dmi_available = -1;
+	return 0;
+}
+early_param("nodmi", setup_disable_dmi);
 
 /*
  *	Save a DMI string
@@ -359,6 +365,12 @@ void __init dmi_scan_machine(void)
 	char __iomem *p, *q;
 	int rc;
 
+	if (dmi_available < 0) {
+		printk(KERN_INFO "DMI disabled.\n");
+		dmi_available = 0;
+		return;
+	}
+
 	if (efi_enabled) {
 		if (efi.smbios == EFI_INVALID_TABLE_ADDR)
 			goto out;
-- 
1.5.4.2

