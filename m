Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbYKFIbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbYKFIbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 03:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbYKFIbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 03:31:25 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:38341 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265AbYKFIbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 03:31:24 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [PATCH] scripts/mkcompile_h: kill output in silent mode
Date: Thu,  6 Nov 2008 03:31:22 -0500
Message-Id: <1225960282-30342-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mkcompile_h script does `echo` regardless of silent mode the make is
running at, so have it respect $quiet from kbuild and only echo when not in
silent mode.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 scripts/mkcompile_h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/mkcompile_h b/scripts/mkcompile_h
index a8740df..6a12dd9 100755
--- a/scripts/mkcompile_h
+++ b/scripts/mkcompile_h
@@ -4,6 +4,8 @@ SMP=$3
 PREEMPT=$4
 CC=$5
 
+vecho() { [ "${quiet}" = "silent_" ] || echo "$@" ; }
+
 # If compile.h exists already and we don't own autoconf.h
 # (i.e. we're not the same user who did make *config), don't
 # modify compile.h
@@ -11,7 +13,7 @@ CC=$5
 # do "compiled by root"
 
 if [ -r $TARGET -a ! -O include/linux/autoconf.h ]; then
-  echo "  SKIPPED $TARGET"
+  vecho "  SKIPPED $TARGET"
   exit 0
 fi
 
@@ -89,7 +91,7 @@ if [ -r $TARGET ] && \
       cmp -s .tmpver.1 .tmpver.2; then
    rm -f .tmpcompile
 else
-   echo "  UPD     $TARGET"
+   vecho "  UPD     $TARGET"
    mv -f .tmpcompile $TARGET
 fi
 rm -f .tmpver.1 .tmpver.2
-- 
1.6.0.3

