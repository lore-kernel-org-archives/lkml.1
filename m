Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbZHNUll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbZHNUll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 16:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbZHNUkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 16:40:37 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:56084 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbZHNUkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 16:40:36 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>, Feng Tang <feng.tang@intel.com>
Subject: [PATCH 03/11] ACPI: check acpi_disabled in acpi_table_parse() and
 acpi_table_parse_entries()
Date: Fri, 14 Aug 2009 16:38:07 -0400
Message-id: <55ec50ee899aa3199c126bb4b740abb9a4ab51df.1250281826.git.len.brown@intel.com>
X-Mailer: git-send-email 1.6.4.122.g6ffd7
In-reply-to: <1250282295-25216-1-git-send-email-lenb@kernel.org>
References: <1250282295-25216-1-git-send-email-lenb@kernel.org>
In-reply-to: <0763223ab0ef5c0016b7a179c1acccaabbefea02.1250281826.git.len.brown@intel.com>
References: <0763223ab0ef5c0016b7a179c1acccaabbefea02.1250281826.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Allow consumers of the acpi_table_parse()/acpi_table_parse_entries() API
to gracefully handle the acpi_disabled=1 case via return value
rather than checking the global flag themselves.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/tables.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index 646d39c..f336bca 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -213,6 +213,9 @@ acpi_table_parse_entries(char *id,
 	unsigned long table_end;
 	acpi_size tbl_size;
 
+	if (acpi_disabled)
+		return -ENODEV;
+
 	if (!handler)
 		return -EINVAL;
 
@@ -277,6 +280,9 @@ int __init acpi_table_parse(char *id, acpi_table_handler handler)
 	struct acpi_table_header *table = NULL;
 	acpi_size tbl_size;
 
+	if (acpi_disabled)
+		return -ENODEV;
+
 	if (!handler)
 		return -EINVAL;
 
-- 
1.6.0.6

