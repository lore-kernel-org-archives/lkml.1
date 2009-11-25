Return-Path: <linux-kernel-owner+w=401wt.eu-S934842AbZKYVjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934842AbZKYVjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 16:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932900AbZKYVjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 16:39:14 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:58048 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759513AbZKYVjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 16:39:08 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] Blackfin: check for anomaly 05000475
Date: Wed, 25 Nov 2009 16:39:04 -0500
Message-Id: <1259185147-31999-6-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259185147-31999-1-git-send-email-vapier@gentoo.org>
References: <1259185147-31999-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parts that have on-chip L2 SRAM cannot safely utilize writeback caching
mode, so reject any attempts to use it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-common/arch_checks.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-common/arch_checks.c b/arch/blackfin/mach-common/arch_checks.c
index 9dbafcd..f2ca211 100644
--- a/arch/blackfin/mach-common/arch_checks.c
+++ b/arch/blackfin/mach-common/arch_checks.c
@@ -57,3 +57,8 @@
 	 (!defined(CONFIG_BFIN_EXTMEM_DCACHEABLE) && defined(CONFIG_BFIN_L2_WRITEBACK)))
 # error You are exposing Anomaly 220 in this config, either config L2 as Write Through, or make External Memory WB.
 #endif
+
+#if ANOMALY_05000475 && \
+	(defined(CONFIG_BFIN_EXTMEM_WRITEBACK) || defined(CONFIG_BFIN_L2_WRITEBACK))
+# error "Anomaly 475 does not allow you to use Write Back cache with L2 or External Memory"
+#endif
-- 
1.6.5.3

