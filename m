Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbYAPNBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbYAPNBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 08:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbYAPNAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 08:00:43 -0500
Received: from saeurebad.de ([85.214.36.134]:54853 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbYAPNAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:00:42 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: ibm-acpi@hmh.eng.br, Johannes Weiner <hannes@saeurebad.de>
Subject: [PATCH] thinkpad_acpi: Define _sta() only when there are callsites
Date: Wed, 16 Jan 2008 14:01:44 +0100
Message-Id: <1200488504-6789-3-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1200488504-6789-2-git-send-email-hannes@saeurebad.de>
References: <1200488504-6789-1-git-send-email-hannes@saeurebad.de>
 <1200488504-6789-2-git-send-email-hannes@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With configs where neither the dock nor the bay subdriver is enabled,
_sta() is defined but never used.  Define it conditionally.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 drivers/misc/thinkpad_acpi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
index cf56647..d5ac8b7 100644
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -293,6 +293,7 @@ static int acpi_ec_write(int i, u8 v)
 	return 1;
 }
 
+#if defined(CONFIG_THINKPAD_ACPI_DOCK) || defined(CONFIG_THINKPAD_ACPI_DOCK)
 static int _sta(acpi_handle handle)
 {
 	int status;
@@ -302,6 +303,7 @@ static int _sta(acpi_handle handle)
 
 	return status;
 }
+#endif
 
 static int issue_thinkpad_cmos_command(int cmos_cmd)
 {
-- 
1.5.3.8

