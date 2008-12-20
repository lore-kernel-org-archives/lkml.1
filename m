Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbYLTOhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbYLTOhe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 09:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbYLTOas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 09:30:48 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:56398 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbYLTOaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 09:30:09 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 20/26] kbuild: fix string equality testing in tags.sh
Date: Sat, 20 Dec 2008 15:31:31 +0100
Message-Id: <1229783497-19550-20-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081220142518.GA19390@uranus.ravnborg.org>
References: <20081220142518.GA19390@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Test of string equality in shells is =, not C-like ==.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/tags.sh |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 3c814ba..4e75472 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -7,7 +7,7 @@
 # Uses the following environment variables:
 # ARCH, SUBARCH, srctree, src, obj
 
-if [ $KBUILD_VERBOSE == 1 ]; then
+if [ "$KBUILD_VERBOSE" = "1" ]; then
 	set -x
 fi
 
@@ -18,7 +18,7 @@ ignore="( -name SCCS -o -name BitKeeper -o -name .svn -o \
           -prune -o"
 
 # Do not use full path is we do not use O=.. builds
-if [ "${KBUILD_SRC}" == "" ]; then
+if [ "${KBUILD_SRC}" = "" ]; then
 	tree=
 else
 	tree=${srctree}/
@@ -135,10 +135,10 @@ xtags()
 
 
 # Support um (which uses SUBARCH)
-if [ ${ARCH} == um ]; then
-	if [ $SUBARCH == i386 ]; then
+if [ "${ARCH}" = "um" ]; then
+	if [ "$SUBARCH" = "i386" ]; then
 		archinclude=x86
-	elif [ $SUBARCH == x86_64 ]; then
+	elif [ "$SUBARCH" = "x86_64" ]; then
 		archinclude=x86
 	else
 		archinclude=${SUBARCH}
-- 
1.6.0.2.GIT

