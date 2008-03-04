Return-Path: <linux-kernel-owner+w=401wt.eu-S1760433AbYCDIfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760433AbYCDIfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbYCDIbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:31:01 -0500
Received: from de01egw02.freescale.net ([192.88.165.103]:42814 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbYCDIa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:30:58 -0500
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org, galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 16/17] Change RapidIO doorbell source and target ID field to 16-bit.
Date: Wed,  5 Mar 2008 00:30:01 +0800
Message-Id: <1204648202-5495-16-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1204648202-5495-15-git-send-email-wei.zhang@freescale.com>
References: <1204648202-5495-1-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-2-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-3-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-4-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-5-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-6-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-7-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-8-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-9-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-10-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-11-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-12-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-13-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-14-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-15-git-send-email-wei.zhang@freescale.com>
X-OriginalArrivalTime: 04 Mar 2008 08:30:37.0516 (UTC) FILETIME=[05DEF0C0:01C87DD2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change RapidIO doorbell source and target ID field to 16-bit for
support large system size, which max rio devid is 65535.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 arch/powerpc/sysdev/fsl_rio.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index 350db4e..e2c7952 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -75,13 +75,13 @@
 #define DOORBELL_DSR_TE		0x00000080
 #define DOORBELL_DSR_QFI	0x00000010
 #define DOORBELL_DSR_DIQI	0x00000001
-#define DOORBELL_TID_OFFSET	0x03
-#define DOORBELL_SID_OFFSET	0x05
+#define DOORBELL_TID_OFFSET	0x02
+#define DOORBELL_SID_OFFSET	0x04
 #define DOORBELL_INFO_OFFSET	0x06
 
 #define DOORBELL_MESSAGE_SIZE	0x08
-#define DBELL_SID(x)		(*(u8 *)(x + DOORBELL_SID_OFFSET))
-#define DBELL_TID(x)		(*(u8 *)(x + DOORBELL_TID_OFFSET))
+#define DBELL_SID(x)		(*(u16 *)(x + DOORBELL_SID_OFFSET))
+#define DBELL_TID(x)		(*(u16 *)(x + DOORBELL_TID_OFFSET))
 #define DBELL_INF(x)		(*(u16 *)(x + DOORBELL_INFO_OFFSET))
 
 struct rio_atmu_regs {
-- 
1.5.4

