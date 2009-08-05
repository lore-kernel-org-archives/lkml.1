Return-Path: <linux-kernel-owner+w=401wt.eu-S1752806AbZHEVvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbZHEVvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 17:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZHEVvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 17:51:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42935 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbZHEVv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 17:51:29 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200908051151.557035535@firstfloor.org>
In-Reply-To: <200908051151.557035535@firstfloor.org>
To: sam@ravnborg.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [1/5] kbuild: Fix ld-option Makefile macro to really work
Message-Id: <20090805215127.B3FF8B15D8@basil.firstfloor.org>
Date: Wed,  5 Aug 2009 23:51:27 +0200 (CEST)
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
 
