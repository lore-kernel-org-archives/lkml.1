Return-Path: <linux-kernel-owner+w=401wt.eu-S1764624AbXEUKQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764624AbXEUKQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbXEUKJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:39 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:4457 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761425AbXEUKJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:19 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="39510272:sNHT54795370"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Aubrey Li <aubrey.li@analog.com>, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 03/32] Blackfin arch: ISP1761 doesn't work for USB flash disk
Date: Mon, 21 May 2007 18:09:11 +0800
Message-Id: <11797421821691-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aubrey Li <aubrey.li@analog.com>

ZONE_DMA is required for some drivers subsystem, such as USB/SCSI.

Signed-off-by: Aubrey Li <aubrey.li@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/Kconfig   |    4 ++++
 arch/blackfin/mm/init.c |    3 ++-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index d80e5b1..35b33a4 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -25,6 +25,10 @@ config BLACKFIN
 	bool
 	default y
 
+config ZONE_DMA
+	bool
+	default y
+
 config BFIN
 	bool
 	default y
diff --git a/arch/blackfin/mm/init.c b/arch/blackfin/mm/init.c
index 73f72ab..d6cf105 100644
--- a/arch/blackfin/mm/init.c
+++ b/arch/blackfin/mm/init.c
@@ -116,7 +116,8 @@ void paging_init(void)
 	{
 		unsigned long zones_size[MAX_NR_ZONES] = { 0, };
 
-		zones_size[ZONE_NORMAL] = (end_mem - PAGE_OFFSET) >> PAGE_SHIFT;
+		zones_size[ZONE_DMA] = (end_mem - PAGE_OFFSET) >> PAGE_SHIFT;
+		zones_size[ZONE_NORMAL] = 0;
 #ifdef CONFIG_HIGHMEM
 		zones_size[ZONE_HIGHMEM] = 0;
 #endif
-- 
1.5.1.2
