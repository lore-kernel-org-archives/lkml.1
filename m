Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbYLOOTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbYLOOTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbYLOOSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:18:23 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:53944 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbYLOOSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:18:22 -0500
X-BigFish: VPS3(zzzzzzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KBX926-04-RH8-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/22] AMD IOMMU: add necessary header defines for stats counting
Date: Mon, 15 Dec 2008 15:17:52 +0100
Message-ID: <1229350685-3816-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 15 Dec 2008 14:18:06.0147 (UTC) FILETIME=[F2C41130:01C95EBF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add defines to make iommu stats collection configurable

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 7abf9cf..1379c5f 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -396,4 +396,30 @@ static inline u16 calc_devid(u8 bus, u8 devfn)
 	return (((u16)bus) << 8) | devfn;
 }
 
+#ifdef CONFIG_AMD_IOMMU_STATS
+
+struct __iommu_counter {
+	char *name;
+	struct dentry *dent;
+	u64 value;
+};
+
+#define DECLARE_STATS_COUNTER(nm) \
+	static struct __iommu_counter nm = {	\
+		.name = #nm,			\
+	}
+
+#define INC_STATS_COUNTER(name)		name.value += 1
+#define ADD_STATS_COUNTER(name, x)	name.value += (x)
+#define SUB_STATS_COUNTER(name, x)	name.value -= (x)
+
+#else /* CONFIG_AMD_IOMMU_STATS */
+
+#define DECLARE_STATS_COUNTER(name)
+#define INC_STATS_COUNTER(name)
+#define ADD_STATS_COUNTER(name, x)
+#define SUB_STATS_COUNTER(name, x)
+
+#endif /* CONFIG_AMD_IOMMU_STATS */
+
 #endif /* _ASM_X86_AMD_IOMMU_TYPES_H */
-- 
1.5.6.4


