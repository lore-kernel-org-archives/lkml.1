Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbZA2XCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbZA2XCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbZA2XBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:01:48 -0500
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:44496 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbZA2XBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:01:47 -0500
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, dave@linux.vnet.ibm.com, jmorris@namei.org,
       matthltc@us.ibm.com, zohar@linux.vnet.ibm.com
Subject: [PATCH 2/2] TPM: integrity interface
Date: Thu, 29 Jan 2009 21:01:35 -0200
Message-Id: <85d5d1dd55645f16dd4a9129ff6d9acd07c4d255.1233269000.git.srajiv@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <cover.1233060433.git.srajiv@linux.vnet.ibm.com>
References: <cover.1233060433.git.srajiv@linux.vnet.ibm.com>
In-Reply-To: <83b938103ecea5b82372cf55c722d7e986959f62.1233269000.git.srajiv@linux.vnet.ibm.com>
References: <83b938103ecea5b82372cf55c722d7e986959f62.1233269000.git.srajiv@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds internal kernel support for:
  - reading/extending a pcr value
  - looking up the tpm_chip for a given chip number

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 include/linux/tpm.h |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/tpm.h

diff --git a/include/linux/tpm.h b/include/linux/tpm.h
new file mode 100644
index 0000000..3338b3f
--- /dev/null
+++ b/include/linux/tpm.h
@@ -0,0 +1,35 @@
+/*
+ * Copyright (C) 2004,2007,2008 IBM Corporation
+ *
+ * Authors:
+ * Leendert van Doorn <leendert@watson.ibm.com>
+ * Dave Safford <safford@watson.ibm.com>
+ * Reiner Sailer <sailer@watson.ibm.com>
+ * Kylene Hall <kjhall@us.ibm.com>
+ * Debora Velarde <dvelarde@us.ibm.com>
+ *
+ * Maintained by: <tpmdd_devel@lists.sourceforge.net>
+ *
+ * Device driver for TCG/TCPA TPM (trusted platform module).
+ * Specifications at www.trustedcomputinggroup.org
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ */
+#ifndef __LINUX_TPM_H__
+#define __LINUX_TPM_H__
+
+/*
+ * Chip num is this value or a valid tpm idx
+ */
+#define	TPM_ANY_NUM 0xFFFF
+
+#if defined(CONFIG_TCG_TPM)
+
+extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
+extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
+#endif
+#endif
-- 
1.5.6.3

