Return-Path: <linux-kernel-owner+w=401wt.eu-S932676AbXHNVhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676AbXHNVhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbXHNVXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:23:36 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38449 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756689AbXHNVXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:23:30 -0400
Date: Tue, 14 Aug 2007 23:23:14 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ram Pai <linuxram@us.ibm.com>, Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] call export_report from the Makefile
Message-ID: <20070814212314.GM18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The main feature is that export_report now automatically works
for O= builds.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
83d0ea7d67407f80df2ba9c95e050ecd1f03a8fe 
diff --git a/Makefile b/Makefile
index cb2e057..b6aa2b5 100644
--- a/Makefile
+++ b/Makefile
@@ -1153,6 +1153,7 @@ help:
 	@echo  'Static analysers'
 	@echo  '  checkstack      - Generate a list of stack hogs'
 	@echo  '  namespacecheck  - Name space analysis on compiled kernel'
+	@echo  '  export_report   - List the usages of all exported symbols'
 	@if [ -r $(srctree)/include/asm-$(ARCH)/Kbuild ]; then \
 	 echo  '  headers_check   - Sanity check on exported headers'; \
 	 fi
@@ -1412,6 +1413,9 @@ versioncheck:
 namespacecheck:
 	$(PERL) $(srctree)/scripts/namespace.pl
 
+export_report:
+	$(PERL) $(srctree)/scripts/export_report.pl
+
 endif #ifeq ($(config-targets),1)
 endif #ifeq ($(mixed-targets),1)
 

