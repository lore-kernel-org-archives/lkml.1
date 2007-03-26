Return-Path: <linux-kernel-owner+w=401wt.eu-S932706AbXCZV1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706AbXCZV1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 17:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932697AbXCZV0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 17:26:44 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:5285 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488AbXCZV0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 17:26:39 -0400
Message-Id: <20070326212637.082960257@de.ibm.com>
References: <20070326212459.711271424@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 26 Mar 2007 23:25:02 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 3/8] Improved kernel stack overflow checking.
Content-Disposition: inline; filename=111-stack-overflow.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Recent cvs versions of gcc have support for an improved stack overflow
checking that calculates the size of the guard size for each function.
If the compiler accepts -mstack-size without -mstack-guard then the
new stack check is available. We always want to use the new stack
checker.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 arch/s390/Makefile |    2 ++
 1 files changed, 2 insertions(+)

Index: linux-2.6/arch/s390/Makefile
===================================================================
--- linux-2.6.orig/arch/s390/Makefile
+++ linux-2.6/arch/s390/Makefile
@@ -67,8 +67,10 @@ endif
 
 ifeq ($(call cc-option-yn,-mstack-size=8192 -mstack-guard=128),y)
 cflags-$(CONFIG_CHECK_STACK) += -mstack-size=$(STACK_SIZE)
+ifneq ($(call cc-option-yn,-mstack-size=8192),y)
 cflags-$(CONFIG_CHECK_STACK) += -mstack-guard=$(CONFIG_STACK_GUARD)
 endif
+endif
 
 ifeq ($(call cc-option-yn,-mwarn-dynamicstack),y)
 cflags-$(CONFIG_WARN_STACK) += -mwarn-dynamicstack

-- 
