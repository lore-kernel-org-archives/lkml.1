Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbZCJNDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbZCJNDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbZCJNDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:03:18 -0400
Received: from cmpxchg.org ([85.214.51.133]:38756 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676AbZCJNDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:03:17 -0400
Message-Id: <20090310120631.160251771@emlix.com>
References: <20090310115643.653120649@emlix.com>
User-Agent: quilt/0.46-1
Date: Tue, 10 Mar 2009 12:56:45 +0100
From: Johannes Weiner <jw@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: Oskar Schirmer <os@emlix.com>, Daniel Gloeckner <dg@emlix.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 2/8] xtensa: variant-specific code
Content-Disposition: inline; filename=0002-xtensa-variant-specific-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the variant to provide own code.  Add empty dummy Makefiles for
the existing variants.

The s6000 has circuits that require own drivers.  Allow these to live
in the variant-specific directory.

Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 arch/xtensa/Makefile                 |    3 +++
 arch/xtensa/variants/dc232b/Makefile |    1 +
 arch/xtensa/variants/fsf/Makefile    |    1 +
 3 files changed, 5 insertions(+)
 create mode 100644 arch/xtensa/variants/dc232b/Makefile
 create mode 100644 arch/xtensa/variants/fsf/Makefile

--- a/arch/xtensa/Makefile
+++ b/arch/xtensa/Makefile
@@ -68,6 +68,9 @@ LIBGCC := $(shell $(CC) $(KBUILD_CFLAGS)
 
 head-y		:= arch/xtensa/kernel/head.o
 core-y		+= arch/xtensa/kernel/ arch/xtensa/mm/
+ifneq ($(VARIANT),)
+core-y		+= arch/xtensa/variants/$(VARIANT)/
+endif
 ifneq ($(PLATFORM),)
 core-y		+= arch/xtensa/platforms/$(PLATFORM)/
 endif
--- /dev/null
+++ b/arch/xtensa/variants/dc232b/Makefile
@@ -0,0 +1 @@
+# dc232b Makefile
--- /dev/null
+++ b/arch/xtensa/variants/fsf/Makefile
@@ -0,0 +1 @@
+# fsf Makefile

-- 

