Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbYLMXM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbYLMXM5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 18:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbYLMXMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 18:12:45 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:55865 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbYLMXMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 18:12:33 -0500
Date: Sun, 14 Dec 2008 00:13:59 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] makesystem: revive cscope target
Message-ID: <20081213231359.GA32331@uranus.ravnborg.org>
References: <1228911013-25641-1-git-send-email-jirislaby@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228911013-25641-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 01:10:13PM +0100, Jiri Slaby wrote:
> - export src and obj, so that we can check them in tags.sh
> - don't allow * expansion during sh function calls
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>

I have applied a slightly modifed version.
See below.

	Sam

>From 6d97189e6862970911ec74cfeaadc3d9ed3e295a Mon Sep 17 00:00:00 2001
From: Jiri Slaby <jirislaby@gmail.com>
Date: Wed, 10 Dec 2008 13:10:13 +0100
Subject: [PATCH] kbuild fix make tags/cscope

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
1.5.6.GIT

