Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbZIWJip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbZIWJip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 05:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbZIWJio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 05:38:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbZIWJio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 05:38:44 -0400
Date: Wed, 23 Sep 2009 05:38:01 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Amerigo Wang <amwang@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>
Message-Id: <20090923094034.23512.90809.sendpatchset@localhost.localdomain>
Subject: [RFC Patch] kbuild: remove -Wdeclaration-after-statement
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I got lots of "ISO C90 forbids mixed declarations and code" warnings
during compile today's kernel.

I think we can remove the gcc option '-Wdeclaration-after-statement'
now, since we already have C99 for 10 years. :)

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>

---
diff --git a/Makefile b/Makefile
index 433493a..038bda2 100644
--- a/Makefile
+++ b/Makefile
@@ -559,9 +559,6 @@ endif
 NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
 CHECKFLAGS     += $(NOSTDINC_FLAGS)
 
-# warn about C99 declaration after statement
-KBUILD_CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)
-
 # disable pointer signed / unsigned warnings in gcc 4.0
 KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)
 
