Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbYKXUy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbYKXUy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 15:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbYKXUxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 15:53:35 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:36284 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbYKXUxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 15:53:32 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>, kbuild <linux-kbuild@vger.kernel.org>
Cc: Werner Almesberger <werner@openmoko.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 6/8] remove bashisms from scripts/extract-ikconfig
Date: Mon, 24 Nov 2008 21:54:53 +0100
Message-Id: <1227560095-32597-6-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.GIT
In-Reply-To: <20081124205150.GA32497@uranus.ravnborg.org>
References: <20081124205150.GA32497@uranus.ravnborg.org>
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
1.5.6.GIT

