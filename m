Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbYLJMKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbYLJMKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 07:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYLJMKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 07:10:25 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:60486 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbYLJMKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 07:10:23 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: sam@ravnborg.org
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] makesystem: revive cscope target
Date: Wed, 10 Dec 2008 13:10:13 +0100
Message-Id: <1228911013-25641-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- export src and obj, so that we can check them in tags.sh
- don't allow * expansion during sh function calls

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile        |    2 +-
 scripts/tags.sh |   22 +++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Makefile b/Makefile
index 8f4f626..a094d74 100644
--- a/Makefile
+++ b/Makefile
@@ -156,7 +156,7 @@ obj		:= $(objtree)
 
 VPATH		:= $(srctree)$(if $(KBUILD_EXTMOD),:$(KBUILD_EXTMOD))
 
-export srctree objtree VPATH TOPDIR
+export src obj srctree objtree VPATH TOPDIR
 
 
 # SUBARCH tells the usermode build what the underlying arch is.  That is set
diff --git a/scripts/tags.sh b/scripts/tags.sh
index 47274dc..3b7225c 100644
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -21,25 +21,25 @@ ignore="( -name SCCS -o -name BitKeeper -o -name .svn -o \
 if [ ${src} == ${obj} ]; then
 	tree=
 else
-	tree=${srctree}
+	tree=${srctree}/
 fi
 
 # find sources in arch/$ARCH
 find_arch_sources()
 {
-	find ${tree}arch/$1 $ignore -name $2 -print;
+	find ${tree}arch/$1 $ignore -name "$2" -print;
 }
 
 # find sources in arch/$1/include
 find_arch_include_sources()
 {
-	find ${tree}arch/$1/include $ignore -name $2 -print;
+	find ${tree}arch/$1/include $ignore -name "$2" -print;
 }
 
 # find sources in include/
 find_include_sources()
 {
-	find ${tree}include $ignore -name config -prune -o -name $1 -print;
+	find ${tree}include $ignore -name config -prune -o -name "$1" -print;
 }
 
 # find sources in rest of tree
@@ -48,27 +48,27 @@ find_other_sources()
 {
 	find ${tree}* $ignore \
 	     \( -name include -o -name arch -o -name '.tmp_*' \) -prune -o \
-	       -name $1 -print;
+	       -name "$1" -print;
 }
 
 find_sources()
 {
-	find_arch_sources $1 $2
-	find_include_sources $2
-	find_other_sources $2
+	find_arch_sources $1 "$2"
+	find_include_sources "$2"
+	find_other_sources "$2"
 }
 
 all_sources()
 {
-	find_sources $SRCARCH *.[chS]
+	find_sources $SRCARCH '*.[chS]'
 	if [ ! -z "$archinclude" ]; then
-		find_arch_include_sources $archinclude *.[chS]
+		find_arch_include_sources $archinclude '*.[chS]'
 	fi
 }
 
 all_kconfigs()
 {
-	find_sources $SRCARCH "Kconfig*"
+	find_sources $SRCARCH 'Kconfig*'
 }
 
 all_defconfigs()
-- 
1.6.0.5

