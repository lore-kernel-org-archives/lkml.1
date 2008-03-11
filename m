Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362AbYCKJPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbYCKJPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 05:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbYCKJKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 05:10:35 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:50307 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbYCKJK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 05:10:28 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org, akpm@linux-foundation.org,
       galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 16/17] Change RapidIO doorbell source and target ID field to 16-bit.
Date: Tue, 11 Mar 2008 17:07:57 +0800
Message-Id: <1205226478-7641-16-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1205226478-7641-15-git-send-email-wei.zhang@freescale.com>
References: <1205226478-7641-1-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-2-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-3-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-4-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-5-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-6-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-7-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-8-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-9-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-10-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-11-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-12-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-13-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-14-git-send-email-wei.zhang@freescale.com>
 <1205226478-7641-15-git-send-email-wei.zhang@freescale.com>
X-OriginalArrivalTime: 11 Mar 2008 09:10:03.0055 (UTC) FILETIME=[B0BBCBF0:01C88357]
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
index 656f754..f67f7df 100644
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

