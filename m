Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbZFEXqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbZFEXqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027AbZFEXlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:46 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36434 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621AbZFEXlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:13 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: dann frazier <dannf@debian.org>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 37/39] Remove bashisms from scripts
Date: Sat,  6 Jun 2009 01:42:55 +0200
Message-Id: <1244245377-17441-37-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: dann frazier <dannf@debian.org>

The '-e' option to echo and brace expansion are not guaranteed to be supported
by a POSIX-compliant /bin/sh (e.g. dash)

Signed-off-by: dann frazier <dannf@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/gcc-version.sh |    2 +-
 scripts/ver_linux      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/gcc-version.sh b/scripts/gcc-version.sh
index cc767b3..debecb5 100644
--- a/scripts/gcc-version.sh
+++ b/scripts/gcc-version.sh
@@ -18,7 +18,7 @@ compiler="$*"
 
 if [ ${#compiler} -eq 0 ]; then
 	echo "Error: No compiler specified."
-	echo -e "Usage:\n\t$0 <gcc-command>"
+	printf "Usage:\n\t$0 <gcc-command>\n"
 	exit 1
 fi
 
diff --git a/scripts/ver_linux b/scripts/ver_linux
index dbb3037..7de36df 100755
--- a/scripts/ver_linux
+++ b/scripts/ver_linux
@@ -65,7 +65,7 @@ sed -n -e '/^.*\/libc-\([^/]*\)\.so$/{s//\1/;p;q}' < /proc/self/maps
 ldd -v > /dev/null 2>&1 && ldd -v || ldd --version |head -n 1 | awk \
 'NR==1{print "Dynamic linker (ldd)  ", $NF}'
 
-ls -l /usr/lib/lib{g,stdc}++.so  2>/dev/null | awk -F. \
+ls -l /usr/lib/libg++.so /usr/lib/libstdc++.so  2>/dev/null | awk -F. \
        '{print "Linux C++ Library      " $4"."$5"."$6}'
 
 ps --version 2>&1 | grep version | awk \
-- 
1.6.3.rc3.40.g75b44

