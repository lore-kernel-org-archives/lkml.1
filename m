Return-Path: <linux-kernel-owner+w=401wt.eu-S1759147AbYGCHFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147AbYGCHFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbYGCG5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:19146 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbYGCCZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 22:25:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,741,1204531200"; 
   d="scan'208";a="584545871"
Subject: [RFC PATCH 1/4] swsusp: call platform_begin before
	swsusp_shrink_memory
From: Zhang Rui <rui.zhang@intel.com>
To: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 10:24:31 +0800
Message-Id: <1215051871.5628.33.camel@rzhang-dt.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


call platform_begin before swsusp shrink memory so that
we can allocate enough pages for ACPI NVS memory region
in platform_begin.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 kernel/power/disk.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c	2008-07-01 09:32:36.000000000 +0800
+++ linux-2.6/kernel/power/disk.c	2008-07-03 09:08:20.000000000 +0800
@@ -243,12 +243,12 @@
 {
 	int error;
 
-	/* Free memory before shutting down devices. */
-	error = swsusp_shrink_memory();
+	error = platform_begin(platform_mode);
 	if (error)
 		return error;
 
-	error = platform_begin(platform_mode);
+	/* Free memory before shutting down devices. */
+	error = swsusp_shrink_memory();
 	if (error)
 		goto Close;
 


