Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbYJKHht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbYJKHht (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbYJKHgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 03:36:53 -0400
Received: from vms172073pub.verizon.net ([206.46.172.73]:32775 "EHLO
	vms172073pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbYJKHgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 03:36:52 -0400
Date: Sat, 11 Oct 2008 02:35:29 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 09/85] ACPICA: Add check for invalid handle in
 acpi_get_object_info
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Fiodor Suietov <fiodor.f.suietov@intel.com>,
       Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>
Message-id: <52c2741285fe19261e119a08d676fbbb42b7d306.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fiodor Suietov <fiodor.f.suietov@intel.com>

Return AE_BAD_PARAMETER if input handle is invalid.

http://www.acpica.org/bugzilla/show_bug.cgi?id=474

Signed-off-by: Fiodor Suietov <fiodor.f.suietov@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/namespace/nsxfname.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/namespace/nsxfname.c b/drivers/acpi/namespace/nsxfname.c
index a287ed5..3cb910d 100644
--- a/drivers/acpi/namespace/nsxfname.c
+++ b/drivers/acpi/namespace/nsxfname.c
@@ -253,6 +253,7 @@ acpi_get_object_info(acpi_handle handle, struct acpi_buffer * buffer)
 	node = acpi_ns_map_handle_to_node(handle);
 	if (!node) {
 		(void)acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
+		status = AE_BAD_PARAMETER;
 		goto cleanup;
 	}
 
-- 
1.5.5.1

