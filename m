Return-Path: <linux-kernel-owner+w=401wt.eu-S1760016AbZIPUhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016AbZIPUhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 16:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759987AbZIPUgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 16:36:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57600 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759984AbZIPUgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 16:36:52 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200909161036.346507799@firstfloor.org>
In-Reply-To: <200909161036.346507799@firstfloor.org>
To: sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/2] kbuild: Add a really-ld-option macro
Message-Id: <20090916203654.6AF88B1755@basil.firstfloor.org>
Date: Wed, 16 Sep 2009 22:36:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Different from the existing ld macro by checking $(LD)

Needed for the next patch

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 scripts/Kbuild.include |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6.31-ak/scripts/Kbuild.include
===================================================================
--- linux-2.6.31-ak.orig/scripts/Kbuild.include
+++ linux-2.6.31-ak/scripts/Kbuild.include
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
@@ -135,6 +136,12 @@ cc-ifversion = $(shell [ $(call cc-versi
 ld-option = $(call try-run,\
 	$(CC) $(1) -nostdlib -xc /dev/null -o "$$TMP",$(1),$(2))
 
+# really-ld-option
+# checks $(LD) unlike ld-option
+# Usage: LDFLAGS += $(call really-ld-option, -X)
+really-ld-option = $(call try-run,\
+	$(CC) /dev/null -c -o "$$TMPO" ; $(LD) $(1) "$$TMPO" -o "$$TMP",$(1),$(2))
+
 ######
 
 ###
