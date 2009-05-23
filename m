Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbZEWRPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbZEWRPa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 13:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbZEWRPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 13:15:23 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:47912 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbZEWRPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 13:15:22 -0400
Date: Sat, 23 May 2009 11:15:22 -0600
From: dann frazier <dannf@debian.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove bashisms from scripts
Message-ID: <20090523171521.GA20612@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The '-e' option to echo and brace expansion are not guaranteed to be supported
by a POSIX-compliant /bin/sh (e.g. dash)

Signed-off-by: dann frazier <dannf@debian.org>
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
1.6.3.1

