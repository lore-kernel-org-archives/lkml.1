Return-Path: <linux-kernel-owner+w=401wt.eu-S933554AbZINUUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933554AbZINUUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933502AbZINUUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:20:44 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54047 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933515AbZINUIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:32 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 24/72] Blackfin: unify duplicated SMP checks in L2 cache kconfig
Date: Mon, 14 Sep 2009 16:07:28 -0400
Message-Id: <1252958896-25150-25-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 7faa2f5..8d04ed9 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -987,7 +987,7 @@ endchoice
 config BFIN_L2_DCACHEABLE
 	bool "Enable DCACHE for L2 SRAM"
 	depends on BFIN_DCACHE
-	depends on BF54x || BF561
+	depends on (BF54x || BF561) && !SMP
 	default n
 choice
 	prompt "L2 SRAM DCACHE policy"
@@ -995,11 +995,9 @@ choice
 	default BFIN_L2_WRITEBACK
 config BFIN_L2_WRITEBACK
 	bool "Write back"
-	depends on !SMP
 
 config BFIN_L2_WRITETHROUGH
 	bool "Write through"
-	depends on !SMP
 endchoice
 
 
-- 
1.6.4.2

