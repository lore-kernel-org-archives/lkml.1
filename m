Return-Path: <linux-kernel-owner+w=401wt.eu-S1759496AbZGHERK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759496AbZGHERK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 00:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758479AbZGHEPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 00:15:07 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:42823 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758513AbZGHEPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 00:15:06 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>, Feng Tang <feng.tang@intel.com>
Subject: [PATCH 10/12] ACPI: check acpi_disabled in acpi_table_parse()
Date: Wed, 08 Jul 2009 00:13:56 -0400
Message-id: <4e176b0f00143e2dfca4480402d3b27b3a0f835f.1247025117.git.len.brown@intel.com>
X-Mailer: git-send-email 1.6.3.3.385.g60647
In-reply-to: <1247026438-20891-1-git-send-email-lenb@kernel.org>
References: <1247026438-20891-1-git-send-email-lenb@kernel.org>
In-reply-to: <8e4a93858bce74ed3080dd607aa471023f1a2737.1247025117.git.len.brown@intel.com>
References: <8e4a93858bce74ed3080dd607aa471023f1a2737.1247025117.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Allow consumers of the acpi_table_parse() API
to gracefully handle the acpi_disabled=1 case
without checking the flag themselves.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/tables.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index 646d39c..921746f 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -277,6 +277,9 @@ int __init acpi_table_parse(char *id, acpi_table_handler handler)
 	struct acpi_table_header *table = NULL;
 	acpi_size tbl_size;
 
+	if (acpi_disabled)
+		return 1;
+
 	if (!handler)
 		return -EINVAL;
 
-- 
1.6.0.6

