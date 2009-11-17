Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbZKQMHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbZKQMHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbZKQMHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:07:40 -0500
Received: from gir.skynet.ie ([193.1.99.77]:35933 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755872AbZKQMHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:07:37 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 1/4] powerpc: Add Kconfig dependency for PCI_MSI as needed by XICS
Date: Tue, 17 Nov 2009 12:07:36 +0000
Message-Id: <1258459659-11770-2-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1258459659-11770-1-git-send-email-mel@csn.ul.ie>
References: <1258459659-11770-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible to set CONFIG_XICS without CONFIG_PCI_MSI. When that
happens, the kernel fails to build with

arch/powerpc/platforms/built-in.o: In function `.xics_startup':
xics.c:(.text+0x12f60): undefined reference to `.unmask_msi_irq'
make: *** [.tmp_vmlinux1] Error 1

This patch adds the dependency in KConfig.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 arch/powerpc/platforms/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index 04a8061..21a1fa1 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -52,7 +52,7 @@ config PPC_UDBG_BEAT
 	default n
 
 config XICS
-	depends on PPC_PSERIES
+	depends on PPC_PSERIES && PCI_MSI
 	bool
 	default y
 
-- 
1.6.5

