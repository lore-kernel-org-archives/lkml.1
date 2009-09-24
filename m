Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbZIXMe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbZIXMe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZIXMeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:34:24 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:8383 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751832AbZIXMeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:34:22 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMzz1202hzzz32i6bh66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KQH6X3-02-6IE-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <norsk5@yahoo.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 03/10] amd64_edac: fix driver instance lookup table allocation
Date: Thu, 24 Sep 2009 14:32:41 +0200
Message-ID: <1253795568-9877-4-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253795568-9877-1-git-send-email-borislav.petkov@amd.com>
References: <1253795568-9877-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 24 Sep 2009 12:33:36.0084 (UTC) FILETIME=[3C6BA140:01CA3D13]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate memory statically for 8-node machines max for simplicity
instead of relying on MAX_NUMNODES which is 0 on !CONFIG_NUMA builds.

Spotted by Jan Beulich.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    4 ++--
 drivers/edac/amd64_edac.h |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index ebb5a96..49911be 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -15,8 +15,8 @@ module_param(ecc_enable_override, int, 0644);
 
 /* Lookup table for all possible MC control instances */
 struct amd64_pvt;
-static struct mem_ctl_info *mci_lookup[MAX_NUMNODES];
-static struct amd64_pvt *pvt_lookup[MAX_NUMNODES];
+static struct mem_ctl_info *mci_lookup[EDAC_MAX_NUMNODES];
+static struct amd64_pvt *pvt_lookup[EDAC_MAX_NUMNODES];
 
 /*
  * See F2x80 for K8 and F2x[1,0]80 for Fam10 and later. The table below is only
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index ec08870..ea96f5a 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -135,6 +135,8 @@
 #define EDAC_AMD64_VERSION		" Ver: 3.2.0 " __DATE__
 #define EDAC_MOD_STR			"amd64_edac"
 
+#define EDAC_MAX_NUMNODES		8
+
 /* Extended Model from CPUID, for CPU Revision numbers */
 #define OPTERON_CPU_LE_REV_C		0
 #define OPTERON_CPU_REV_D		1
-- 
1.6.3.3


