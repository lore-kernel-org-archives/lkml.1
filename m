Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbZJZN0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbZJZN0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 09:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbZJZN0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 09:26:38 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:47828 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbZJZN0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 09:26:38 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       Jean-Christophe Dubois <jcd@tribudubois.net>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
       Stable Kernel <stable@kernel.org>
Subject: [PATCH] tpm add default function definitions
Date: Mon, 26 Oct 2009 09:26:18 -0400
Message-Id: <1256563579-11014-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add default tpm_pcr_read/extend function definitions required
by IMA/Kconfig changes.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Cc: Stable Kernel <stable@kernel.org>
---
 include/linux/tpm.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 3338b3f..8eaa8f8 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -31,5 +31,12 @@
 
 extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
 extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
+#else
+static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
+	return -ENODEV;
+}
+static inline int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash) {
+	return -ENODEV;
+}
 #endif
 #endif
-- 
1.6.0.6

