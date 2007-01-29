Return-Path: <linux-kernel-owner+w=401wt.eu-S1751298AbXA2MrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbXA2MrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 07:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbXA2MrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 07:47:09 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:62640 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751298AbXA2MrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 07:47:08 -0500
Date: Mon, 29 Jan 2007 13:47:01 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] `make help' in build tree doesn't show headers_* targets
Message-ID: <Pine.LNX.4.62.0701291346210.17426@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

`make help' in the build tree doesn't show the help texts about the
`headers_install' and `headers_check' targets because it looks for
include/asm-$(ARCH)/Kbuild in the wrong place.
Add the missing `$(srctree)' prefixes to fix this.
Also move the printing of the default install path for the headers inside the
`if/fi', where it belongs.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

--- ps3-linux-src-2.6.20-rc6.orig/Makefile
+++ ps3-linux-src-2.6.20-rc6/Makefile
@@ -1116,15 +1116,15 @@ help:
 	@echo  '  cscope	  - Generate cscope index'
 	@echo  '  kernelrelease	  - Output the release version string'
 	@echo  '  kernelversion	  - Output the version stored in Makefile'
-	@if [ -r include/asm-$(ARCH)/Kbuild ]; then \
+	@if [ -r $(srctree)/include/asm-$(ARCH)/Kbuild ]; then \
 	 echo  '  headers_install - Install sanitised kernel headers to INSTALL_HDR_PATH'; \
+	 echo  '                    (default: $(INSTALL_HDR_PATH))'; \
 	 fi
-	@echo  '                    (default: $(INSTALL_HDR_PATH))'
 	@echo  ''
 	@echo  'Static analysers'
 	@echo  '  checkstack      - Generate a list of stack hogs'
 	@echo  '  namespacecheck  - Name space analysis on compiled kernel'
-	@if [ -r include/asm-$(ARCH)/Kbuild ]; then \
+	@if [ -r $(srctree)/include/asm-$(ARCH)/Kbuild ]; then \
 	 echo  '  headers_check   - Sanity check on exported headers'; \
 	 fi
 	@echo  ''

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
