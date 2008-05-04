Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbYEDMe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbYEDMe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 08:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbYEDMeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 08:34:20 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:39141 "EHLO
	seznam.cz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753188AbYEDMeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 08:34:19 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 36/56] microblaze_v2: dma support
Date: Sun,  4 May 2008 13:41:25 +0200
Message-Id: <92cd3a27b393bb394d48902594152351a92c59bb.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <96f2004535c34a0c762bf2012c299cbf9f89ab32.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
 <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>
 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>
 <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>
 <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu>
 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>
 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>
 <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>
 <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>
 <eadcc6f4754df78b69d6d54c404624d0390c8558.1209897266.git.monstr@monstr.eu>
 <4df4022e06b9056202cc2fdf0b99deb01563a0fa.1209897266.git.monstr@monstr.eu>
 <6b0c9864dc80776ae48d6488a6892e5d698751b7.1209897266.git.monstr@monstr.eu>
 <ea5cbbca49c38c506960fddba29cbd8cb24e1a8d.1209897266.git.monstr@monstr.eu>
 <4f4d6ed3fce9b21cdd6dcacb2d72fff7e9830628.1209897266.git.monstr@monstr.eu>
 <35e662a81eb86c7ffb2aaa6141ca38a07789f382.1209897266.git.monstr@monstr.eu>
 <b41fcf3dd830f4ba82692a9bec2406ed0c290e7e.1209897266.git.monstr@monstr.eu>
 <14acb31da2794d2d5916da3db3d75fe2285ac055.1209897266.git.monstr@monstr.eu>
 <598221ce2159046614d7b158ea62d5af51907af3.1209897266.git.monstr@monstr.eu>
 <41c1f410eaafd875246362d10ef9866d8cc2a934.1209897266.git.monstr@monstr.eu>
 <09ce2baf0c8308d3fbca98e7eb36a6aab59112a7.1209897266.git.monstr@monstr.eu>
 <c9418c683be99ae12abb89575c362d586c026bad.1209897266.git.monstr@monstr.eu>
 <cfde3796e95bdd17c32e4fd7762d0aee55967707.1209897266.git.monstr@monstr.eu>
 <8aba2d82c85cd1d5b56de328c1fd080ee51f0211.1209897266.git.monstr@monstr.eu>
 <c4000ff625bd217f9bb683e3bf8c7193a82bd744.1209897266.git.monstr@monstr.eu>
 <491f823fac6c03cc36834ec569a45d30a03a72cf.1209897266.git.monstr@monstr.eu>
 <96f2004535c34a0c762bf2012c299cbf9f89ab32.1209897266.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/dma-mapping.h |   17 +++++++++++++++++
 include/asm-microblaze/dma.h         |   20 ++++++++++++++++++++
 include/asm-microblaze/scatterlist.h |   21 +++++++++++++++++++++
 3 files changed, 58 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/dma-mapping.h
 create mode 100644 include/asm-microblaze/dma.h
 create mode 100644 include/asm-microblaze/scatterlist.h

diff --git a/include/asm-microblaze/dma-mapping.h b/include/asm-microblaze/dma-mapping.h
new file mode 100644
index 0000000..7227661
--- /dev/null
+++ b/include/asm-microblaze/dma-mapping.h
@@ -0,0 +1,17 @@
+/*
+ * include/asm-microblaze/dma-mapping.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_DMA_MAPPING_H
+#define _ASM_MICROBLAZE_DMA_MAPPING_H
+
+#include <asm-generic/dma-mapping.h>
+
+#endif /* _ASM_MICROBLAZE_DMA_MAPPING_H */
diff --git a/include/asm-microblaze/dma.h b/include/asm-microblaze/dma.h
new file mode 100644
index 0000000..e36619f
--- /dev/null
+++ b/include/asm-microblaze/dma.h
@@ -0,0 +1,20 @@
+/*
+ * include/asm-microblaze/dma.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_DMA_H
+#define _ASM_MICROBLAZE_DMA_H
+
+/* we don't have dma address limit. define it as zero to be
+ * unlimited. */
+#define MAX_DMA_ADDRESS		(0)
+
+#define ISA_DMA_THRESHOLD	(0)
+
+#endif /* _ASM_MICROBLAZE_DMA_H */
diff --git a/include/asm-microblaze/scatterlist.h b/include/asm-microblaze/scatterlist.h
new file mode 100644
index 0000000..76fab58
--- /dev/null
+++ b/include/asm-microblaze/scatterlist.h
@@ -0,0 +1,21 @@
+/*
+ * include/asm-microblaze/scatterlist.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_SCATTERLIST_H
+#define _ASM_MICROBLAZE_SCATTERLIST_H
+
+struct scatterlist {
+	unsigned long page_link;
+	unsigned int	offset;
+	dma_addr_t	dma_address;
+	unsigned int	length;
+};
+
+#endif /* _ASM_MICROBLAZE_SCATTERLIST_H */
-- 
1.5.4.GIT

