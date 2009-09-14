Return-Path: <linux-kernel-owner+w=401wt.eu-S933589AbZINUSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589AbZINUSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933576AbZINUSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:18:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42012 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123AbZINUSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:18:06 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200909141018.915641783@firstfloor.org>
In-Reply-To: <200909141018.915641783@firstfloor.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, sam@ravnborg.org
Subject: [PATCH] [1/5] kbuild: Fix ld-option Makefile macro to really work
Message-Id: <20090914201806.EE6A0B1757@basil.firstfloor.org>
Date: Mon, 14 Sep 2009 22:18:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Needed for the next patch

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 scripts/Kbuild.include |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.31-rc1-ak/scripts/Kbuild.include
===================================================================
--- linux-2.6.31-rc1-ak.orig/scripts/Kbuild.include
+++ linux-2.6.31-rc1-ak/scripts/Kbuild.include
@@ -83,11 +83,12 @@ TMPOUT := $(if $(KBUILD_EXTMOD),$(firstw
 # is automatically cleaned up.
 try-run = $(shell set -e;		\
 	TMP="$(TMPOUT).$$$$.tmp";	\
+	TMPO="$(TMPOUT).$$$$.o";	\
 	if ($(1)) >/dev/null 2>&1;	\
 	then echo "$(2)";		\
 	else echo "$(3)";		\
 	fi;				\
-	rm -f "$$TMP")
+	rm -f "$$TMP" "$$TMPO")
 
 # as-option
 # Usage: cflags-y += $(call as-option,-Wa$(comma)-isa=foo,)
@@ -133,7 +134,7 @@ cc-ifversion = $(shell [ $(call cc-versi
 # ld-option
 # Usage: ldflags += $(call ld-option, -Wl$(comma)--hash-style=both)
 ld-option = $(call try-run,\
-	$(CC) $(1) -nostdlib -xc /dev/null -o "$$TMP",$(1),$(2))
+	$(CC) /dev/null -c -o "$$TMPO" ; $(LD) $(1) "$$TMPO" -o "$$TMP",$(1),$(2))
 
 ######
 
