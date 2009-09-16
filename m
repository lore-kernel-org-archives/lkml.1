Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbZIPNvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbZIPNvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbZIPNvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:51:38 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:40873 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbZIPNvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:51:38 -0400
X-SpamScore: 10
X-BigFish: VPS10(zza4b1ozz1202hzzz32i203h43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KQ2H5T-03-4MQ-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <torvalds@linux-foundation.org>
CC: <norsk5@yahoo.com>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/5] amd64_edac: build driver only on AMD hardware
Date: Wed, 16 Sep 2009 15:50:46 +0200
Message-ID: <1253109050-31165-2-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253109050-31165-1-git-send-email-borislav.petkov@amd.com>
References: <1253109050-31165-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Sep 2009 13:51:22.0988 (UTC) FILETIME=[C6CEAAC0:01CA36D4]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

-tip testing found the following build failure (config attached):

drivers/built-in.o: In function `amd64_check':
amd64_edac.c:(.text+0x3e9491): undefined reference to `amd_decode_nb_mce'
drivers/built-in.o: In function `amd64_init_2nd_stage':
amd64_edac.c:(.text+0x3e9b46): undefined reference to `amd_report_gart_errors'
amd64_edac.c:(.text+0x3e9b55): undefined reference to `amd_register_ecc_decoder'
drivers/built-in.o: In function `amd64_nbea_store':
amd64_edac_dbg.c:(.text+0x3ea22e): undefined reference to `amd_decode_nb_mce'
drivers/built-in.o: In function `amd64_remove_one_instance':
amd64_edac.c:(.devexit.text+0x3eea): undefined reference to `amd_report_gart_errors'
amd64_edac.c:(.devexit.text+0x3ef6): undefined reference to `amd_unregister_ecc_decoder'

the AMD EDAC code has a dependency on CONFIG_CPU_SUP_AMD facilities. The
patch below solves the problem here.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 4339b1a..a3ca18e 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -59,7 +59,7 @@ config EDAC_MM_EDAC
 
 config EDAC_AMD64
 	tristate "AMD64 (Opteron, Athlon64) K8, F10h, F11h"
-	depends on EDAC_MM_EDAC && K8_NB && X86_64 && PCI
+	depends on EDAC_MM_EDAC && K8_NB && X86_64 && PCI && CPU_SUP_AMD
 	help
 	  Support for error detection and correction on the AMD 64
 	  Families of Memory Controllers (K8, F10h and F11h)
-- 
1.6.3.3


