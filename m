Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbXFITWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbXFITWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 15:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbXFITWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 15:22:09 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:56126 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453AbXFITWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 15:22:08 -0400
Date: Sat, 9 Jun 2007 21:22:00 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: dummy@foobar-g4
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove bashisms from scripts/extract-ikconfig
Message-ID: <alpine.DEB.0.99.0706092117580.8312@foobar-g4>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed that scripts/extract-ikconfig is using /bin/sh in its shebang 
but when /bin/sh is not a symlink to bash, it breaks with:

# scripts/extract-ikconfig /boot/vmlinux
scripts/extract-ikconfig: 11: function: not found
scripts/extract-ikconfig: 12: typeset: not found

The diff below seems to fix this.

Signed-off-by: Christian Kujau <lists@nerdbynature.de>

--- linux-2.6-dev/scripts/extract-ikconfig.orig	2007-06-01 22:53:49.000000000 +0200
+++ linux-2.6-dev/scripts/extract-ikconfig	2007-06-01 23:00:54.000000000 +0200
@@ -8,8 +8,8 @@ test -e $binoffset || cc -o $binoffset .

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
+    start="`expr $start + 8`"
+    size="`expr $end - $start`"

      dd if="$file" ibs=1 skip="$start" count="$size" 2>/dev/null | zcat


-- 
make bzImage, not war
