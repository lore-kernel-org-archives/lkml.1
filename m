Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbYKLTGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbYKLTGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 14:06:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbYKLTFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 14:05:55 -0500
Received: from mail.openmoko.org ([88.198.124.205]:42006 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbYKLTFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 14:05:54 -0500
X-Greylist: delayed 1562 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Nov 2008 14:05:54 EST
Date: Wed, 12 Nov 2008 16:39:35 -0200
From: Werner Almesberger <werner@openmoko.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] remove bashisms from scripts/extract-ikconfig
Message-ID: <20081112183935.GA8443@almesberger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unbashify-extract-ikconfig.patch

scripts/extract-ikconfig contains a lot of gratuituous bashisms,
which make it fail if /bin/sh isn't bash. This patch replaces them
with regular Bourne shell constructs.

Signed-off-by: Werner Almesberger <werner@openmoko.org>

---

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
 
