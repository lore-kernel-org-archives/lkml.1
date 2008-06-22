Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbYFVWIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbYFVWIo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 18:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbYFVWID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 18:08:03 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60315 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409AbYFVWH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 18:07:59 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 3/5] kbuild: support arch/$ARCH/include for tags, cscope
Date: Mon, 23 Jun 2008 00:08:42 +0200
Message-Id: <1214172524-9043-3-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080622220508.GA8957@uranus.ravnborg.org>
References: <20080622220508.GA8957@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index ef30745..115eb48 100644
--- a/Makefile
+++ b/Makefile
@@ -1399,7 +1399,11 @@ define find-sources
 	       \( -name config -o -name 'asm-*' \) -prune \
 	       -o -name $1 -print; \
 	  for arch in $(ALLINCLUDE_ARCHS) ; do \
-	       find $(__srctree)include/asm-$${arch} $(RCS_FIND_IGNORE) \
+	       test -e $(__srctree)include/asm-$${arch} && \
+                 find $(__srctree)include/asm-$${arch} $(RCS_FIND_IGNORE) \
+	            -name $1 -print; \
+	       test -e $(__srctree)arch/$${arch}/include/asm && \
+	         find $(__srctree)arch/$${arch}/include/asm $(RCS_FIND_IGNORE) \
 	            -name $1 -print; \
 	  done ; \
 	  find $(__srctree)include/asm-generic $(RCS_FIND_IGNORE) \
-- 
1.5.4.1.143.ge7e51

