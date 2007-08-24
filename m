Return-Path: <linux-kernel-owner+w=401wt.eu-S1763480AbXHXVGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763480AbXHXVGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758160AbXHXVGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:06:15 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60121 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759432AbXHXVGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:06:14 -0400
Date: Fri, 24 Aug 2007 23:04:56 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Ram Pai <linuxram@us.ibm.com>,
       Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] call export_report from the Makefile
Message-ID: <20070824210456.GF30705@stusta.de>
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

This patch has been sent on:
- 14 Aug 2007

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
 

