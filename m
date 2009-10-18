Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbZJRILY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbZJRILY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 04:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbZJRILW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 04:11:22 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:50902 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbZJRILS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 04:11:18 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 03/14] kbuild: move bounds.h to include/generated
Date: Sun, 18 Oct 2009 10:15:12 +0200
Message-Id: <1255853723-477-3-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <20091018080635.GA13767@merkur.ravnborg.org>
References: <20091018080635.GA13767@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 .gitignore                 |    1 -
 Kbuild                     |    2 +-
 Makefile                   |    2 +-
 include/linux/mmzone.h     |    2 +-
 include/linux/page-flags.h |    2 +-
 kernel/bounds.c            |    2 +-
 6 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/.gitignore b/.gitignore
index b93fb7e..32855c6 100644
--- a/.gitignore
+++ b/.gitignore
@@ -51,7 +51,6 @@ include/linux/autoconf.h
 include/linux/compile.h
 include/linux/version.h
 include/linux/utsrelease.h
-include/linux/bounds.h
 include/generated
 
 # stgit generated dirs
diff --git a/Kbuild b/Kbuild
index f056b4f..1165d7a 100644
--- a/Kbuild
+++ b/Kbuild
@@ -8,7 +8,7 @@
 #####
 # 1) Generate bounds.h
 
-bounds-file := include/linux/bounds.h
+bounds-file := include/generated/bounds.h
 
 always  := $(bounds-file)
 targets := $(bounds-file) kernel/bounds.s
diff --git a/Makefile b/Makefile
index a805f5c..9aaa4e1 100644
--- a/Makefile
+++ b/Makefile
@@ -1196,7 +1196,7 @@ MRPROPER_DIRS  += include/config include2 usr/include include/generated
 MRPROPER_FILES += .config .config.old include/asm .version .old_version \
                   include/linux/autoconf.h include/linux/version.h      \
                   include/linux/utsrelease.h                            \
-                  include/linux/bounds.h include/asm*/asm-offsets.h     \
+                  include/asm*/asm-offsets.h                            \
 		  Module.symvers Module.markers tags TAGS cscope*
 
 # clean - Delete most, but leave enough to build external modules
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6f75617..30fe668 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -15,7 +15,7 @@
 #include <linux/seqlock.h>
 #include <linux/nodemask.h>
 #include <linux/pageblock-flags.h>
-#include <linux/bounds.h>
+#include <generated/bounds.h>
 #include <asm/atomic.h>
 #include <asm/page.h>
 
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 6b202b1..ef36725 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -8,7 +8,7 @@
 #include <linux/types.h>
 #ifndef __GENERATING_BOUNDS_H
 #include <linux/mm_types.h>
-#include <linux/bounds.h>
+#include <generated/bounds.h>
 #endif /* !__GENERATING_BOUNDS_H */
 
 /*
diff --git a/kernel/bounds.c b/kernel/bounds.c
index 3c53013..98a51f2 100644
--- a/kernel/bounds.c
+++ b/kernel/bounds.c
@@ -12,7 +12,7 @@
 
 void foo(void)
 {
-	/* The enum constants to put into include/linux/bounds.h */
+	/* The enum constants to put into include/generated/bounds.h */
 	DEFINE(NR_PAGEFLAGS, __NR_PAGEFLAGS);
 	DEFINE(MAX_NR_ZONES, __MAX_NR_ZONES);
 	/* End of constants */
-- 
1.6.2.5

