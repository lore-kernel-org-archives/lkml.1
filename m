Return-Path: <linux-kernel-owner+w=401wt.eu-S1030640AbXBHDa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030640AbXBHDa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 22:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030656AbXBHDa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 22:30:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030640AbXBHDa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 22:30:58 -0500
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix cc-option-yn whitespace
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20070208033046.44D39180055@magilla.sf.frob.com>
Date: Wed,  7 Feb 2007 19:30:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This change:

	commit 5de043f4bd11a9e0a3e8daec7d1905da575a76b7
	Author: Oleg Verych <olecom@flower.upol.cz>
	Date:   Tue Feb 6 02:18:21 2007 +0100

	    [PATCH] kbuild: improve option checking, Kbuild.include cleanup

introduced leading whitespace in the results of cc-option-yn and such.
This breaks some of their uses, like HAS_MTUNE in arch/i386/Makefile.cpu.

This patch fixes the regression.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 scripts/Kbuild.include |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 96926eb..931d52f 100644  
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -60,6 +60,7 @@ endef
 # Usage: option = $(call checker-shell, $(CC)...-o $$OUT, option-ok, otherwise)
 # Exit code chooses option. $$OUT is safe location for needless output.
 define checker-shell
+$(strip \
   $(shell set -e; \
     DIR=$(KBUILD_EXTMOD); \
     cd $${DIR:-$(objtree)}; \
@@ -70,7 +71,7 @@ define checker-shell
       then echo "$(2)"; \
       else echo "$(3)"; \
     fi; \
-    rm -f $$OUT)
+    rm -f $$OUT))
 endef
 
 # as-option
