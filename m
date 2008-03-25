Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbYCYAsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbYCYAsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 20:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754383AbYCYAr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 20:47:57 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4662 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbYCYAr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 20:47:56 -0400
Subject: [PATCH] scripts/Lindent - support gnu indent v2.2.10
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Matthew Wilcox <matthew@wil.cx>, eblennerhassett@audioscience.com
Content-Type: text/plain
Date: Mon, 24 Mar 2008 17:47:34 -0700
Message-Id: <1206406054.4845.59.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new version of indent supports positioning labels in column 1
using "-il0"

http://www.nabble.com/Release-2.2.10-of-GNU-Indent-td15990700.html

Add "-il0" if indent version >= 2.2.10

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/scripts/Lindent b/scripts/Lindent
index 9468ec7..9c4b3e2 100755
--- a/scripts/Lindent
+++ b/scripts/Lindent
@@ -1,2 +1,18 @@
 #!/bin/sh
-indent -npro -kr -i8 -ts8 -sob -l80 -ss -ncs -cp1 "$@"
+PARAM="-npro -kr -i8 -ts8 -sob -l80 -ss -ncs -cp1"
+RES=`indent --version`
+V1=`echo $RES | cut -d' ' -f3 | cut -d'.' -f1`
+V2=`echo $RES | cut -d' ' -f3 | cut -d'.' -f2`
+V3=`echo $RES | cut -d' ' -f3 | cut -d'.' -f3`
+if [ $V1 -gt 2 ]; then
+  PARAM="$PARAM -il0"
+elif [ $V1 -eq 2 ]; then
+  if [ $V2 -gt 2 ]; then
+    PARAM="$PARAM -il0";
+  elif [ $V2 -eq 2 ]; then
+    if [ $V3 -ge 10 ]; then
+      PARAM="$PARAM -il0"
+    fi
+  fi
+fi
+indent $PARAM "$@"


