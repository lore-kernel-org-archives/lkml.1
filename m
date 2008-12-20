Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbYLTOiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbYLTOiz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 09:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbYLTOay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 09:30:54 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:41319 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbYLTOaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 09:30:07 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 19/26] kbuild: fix make tags/cscope
Date: Sat, 20 Dec 2008 15:31:30 +0100
Message-Id: <1229783497-19550-19-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081220142518.GA19390@uranus.ravnborg.org>
References: <20081220142518.GA19390@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

- fix combining O=... and tags
- don't allow * expansion during sh function calls

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
[sam: use KBUILD_SRC to check if we use O=...]
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/tags.sh |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 47274dc..3c814ba 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -18,28 +18,28 @@ ignore="( -name SCCS -o -name BitKeeper -o -name .svn -o \
           -prune -o"
 
 # Do not use full path is we do not use O=.. builds
-if [ ${src} == ${obj} ]; then
+if [ "${KBUILD_SRC}" == "" ]; then
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
1.6.0.2.GIT

