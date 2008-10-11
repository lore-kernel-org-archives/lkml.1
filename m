Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYJKGjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYJKGjN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbYJKGg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:36:56 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:52440 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYJKGgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:36:54 -0400
Date: Sat, 11 Oct 2008 02:35:35 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 15/85] ACPICA: Fix warning for 64-bit build
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>
Message-id: <76a509bb8fabcfe111be65b67cfdc03d4768b654.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Fixes warning from exconfig.c on 64-bit build.

AK: This actually was fixed earlier in Linux, this just syncs with
AK: the version of the fix that went into the ACPCA codebase

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/executer/exconfig.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/executer/exconfig.c b/drivers/acpi/executer/exconfig.c
index 331a114..4c512c2 100644
--- a/drivers/acpi/executer/exconfig.c
+++ b/drivers/acpi/executer/exconfig.c
@@ -96,8 +96,7 @@ acpi_ex_add_table(u32 table_index,
 
 	/* Install the new table into the local data structures */
 
-	obj_desc->reference.object = ACPI_CAST_PTR(void,
-			(unsigned long)table_index);
+	obj_desc->reference.object = ACPI_TO_POINTER(table_index);
 
 	/* Add the table to the namespace */
 
-- 
1.5.5.1

