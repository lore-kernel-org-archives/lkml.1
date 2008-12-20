Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbYLTOe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbYLTOe1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 09:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbYLTOaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 09:30:07 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:41292 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbYLTOaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 09:30:05 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Werner Almesberger <werner@openmoko.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 07/26] remove bashisms from scripts/extract-ikconfig
Date: Sat, 20 Dec 2008 15:31:18 +0100
Message-Id: <1229783497-19550-7-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081220142518.GA19390@uranus.ravnborg.org>
References: <20081220142518.GA19390@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Werner Almesberger <werner@openmoko.org>

unbashify-extract-ikconfig.patch

scripts/extract-ikconfig contains a lot of gratuituous bashisms,
which make it fail if /bin/sh isn't bash. This patch replaces them
with regular Bourne shell constructs.

Signed-off-by: Werner Almesberger <werner@openmoko.org>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com> # as file author
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/extract-ikconfig |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/scripts/extract-ikconfig b/scripts/extract-ikconfig
index 8187e6f..72997c3 100755
--- a/scripts/extract-ikconfig
+++ b/scripts/extract-ikconfig
@@ -8,8 +8,8 @@ test -e $binoffset || cc -o $binoffset ./scripts/binoffset.c || exit 1
 
 IKCFG_ST="0x49 0x4b 0x43 0x46 0x47 0x5f 0x53 0x54"
 IKCFG_ED="0x49 0x4b 0x43 0x46 0x47 0x5f 0x45 0x44"
-function dump_config {
-    typeset file="$1"
+dump_config() {
+    file="$1"
 
     start=`$binoffset $file $IKCFG_ST 2>/dev/null`
     [ "$?" != "0" ] && start="-1"
@@ -18,8 +18,8 @@ function dump_config {
     fi
     end=`$binoffset $file $IKCFG_ED 2>/dev/null`
 
-    let start="$start + 8"
-    let size="$end - $start"
+    start=`expr $start + 8`
+    size=`expr $end - $start`
 
     dd if="$file" ibs=1 skip="$start" count="$size" 2>/dev/null | zcat
 
-- 
1.6.0.2.GIT

