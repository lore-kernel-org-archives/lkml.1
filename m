Return-Path: <linux-kernel-owner+w=401wt.eu-S933309AbYF3Vj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309AbYF3Vj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932873AbYF3Vep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:34:45 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:48245 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763158AbYF3Ved (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:34:33 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 13/24] kbuild: add arch/$ARCH/include to search path
Date: Mon, 30 Jun 2008 23:35:07 +0200
Message-Id: <1214861718-32626-13-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.1.93.gef98
In-Reply-To: <20080630213155.GA32479@uranus.ravnborg.org>
References: <20080630213155.GA32479@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch conclude the support for

   arch/$ARCH/include

Note: The individual architectures will most likely require
      a few minor patches to support locating header files in
      arch/$ARCH/include

Testing shows that it worked out-of-the-box for sparc.
x86 required a few trivial changes in the arch
specific Makefile and a few include paths had to be adjusted.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 339f6d3..4a1ed80 100644
--- a/Makefile
+++ b/Makefile
@@ -329,7 +329,8 @@ AFLAGS_KERNEL	=
 # Needed to be compatible with the O= option
 LINUXINCLUDE    := -Iinclude \
                    $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
-		   -include include/linux/autoconf.h
+                   -I$(srctree)/arch/$(hdr-arch)/include               \
+                   -include include/linux/autoconf.h
 
 KBUILD_CPPFLAGS := -D__KERNEL__ $(LINUXINCLUDE)
 
-- 
1.5.6.1.93.gef98

