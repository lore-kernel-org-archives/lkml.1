Return-Path: <linux-kernel-owner+w=401wt.eu-S1764270AbYF3VfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764270AbYF3VfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932161AbYF3Vee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:34:34 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51653 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762963AbYF3Vec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:34:32 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 05/24] kbuild: error out early in make headers_install
Date: Mon, 30 Jun 2008 23:34:59 +0200
Message-Id: <1214861718-32626-5-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.1.93.gef98
In-Reply-To: <20080630213155.GA32479@uranus.ravnborg.org>
References: <20080630213155.GA32479@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the a.out.h case by setting SRCARCH and error
out early in case of an error.
The a.out.h case failed with the *_all targets.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index c65fe4f..d676c39 100644
--- a/Makefile
+++ b/Makefile
@@ -1012,8 +1012,9 @@ __headers: include/linux/version.h scripts_basic FORCE
 
 PHONY += headers_install_all
 headers_install_all: __headers
-	$(Q)for arch in $(hdr-archs); do \
-	 $(MAKE) ARCH=$$arch $(hdr-inst)=include BIASMDIR=-bi-$$arch ;\
+	$(Q)set -e; for arch in $(hdr-archs); do \
+	 $(MAKE) ARCH=$$arch SRCARCH=$$arch $(hdr-inst)=include \
+	         BIASMDIR=-bi-$$arch ;\
 	 done
 
 PHONY += headers_install
@@ -1026,8 +1027,9 @@ headers_install: __headers
 
 PHONY += headers_check_all
 headers_check_all: headers_install_all
-	$(Q)for arch in $(hdr-archs); do \
-	 $(MAKE) ARCH=$$arch $(hdr-inst)=include BIASMDIR=-bi-$$arch HDRCHECK=1 ;\
+	$(Q)set -e; for arch in $(hdr-archs); do \
+	 $(MAKE) ARCH=$$arch SRCARCH=$$arch $(hdr-inst)=include \
+	         BIASMDIR=-bi-$$arch HDRCHECK=1 ;\
 	 done
 
 PHONY += headers_check
-- 
1.5.6.1.93.gef98

