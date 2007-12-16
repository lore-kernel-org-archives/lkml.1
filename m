Return-Path: <linux-kernel-owner+w=401wt.eu-S1761101AbXLPVbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761101AbXLPVbZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 16:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758909AbXLPVbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 16:31:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49185 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758868AbXLPVbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 16:31:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] 2.6.24-rc5: Fix build with make O= if the top level Makefile is not present
Date: Sun, 16 Dec 2007 22:50:17 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712162250.18291.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

IMHO, something like the patch below is needed to fix builds with "make O=",
since after commit 18c32dac75b187d1a4e858f3cfdf03e844129f5e
"kbuild: fix building with O=.. options" the top-level Makefile is no longer
created automatically if it's not present at all.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>

Make the build system create the top-level Makefile for builds with "make O="
if it is not present already.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 scripts/mkmakefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/scripts/mkmakefile
===================================================================
--- linux-2.6.orig/scripts/mkmakefile
+++ linux-2.6/scripts/mkmakefile
@@ -13,7 +13,7 @@
 test ! -r $2/Makefile -o -O $2/Makefile || exit 0
 # Only overwrite automatically generated Makefiles
 # (so we do not overwrite kernel Makefile)
-if ! grep -q Automatically $2/Makefile
+if (test -f $2/Makefile) && !(grep -q Automatically $2/Makefile)
 then
 	exit 0
 fi
