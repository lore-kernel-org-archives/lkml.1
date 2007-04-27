Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbXD0ONL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbXD0ONL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbXD0OGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:06:51 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:14920 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877AbXD0OE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:04:59 -0400
Message-Id: <20070427140517.205443955@de.ibm.com>
References: <20070427140503.087958775@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Apr 2007 16:05:26 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 23/38] Improved kernel stack overflow checking.
Content-Disposition: inline; filename=126-stack-overflow.diff
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

Index: quilt-2.6/arch/s390/Makefile
===================================================================
--- quilt-2.6.orig/arch/s390/Makefile	2007-04-27 16:01:49.000000000 +0200
+++ quilt-2.6/arch/s390/Makefile	2007-04-27 16:04:58.000000000 +0200
@@ -67,8 +67,10 @@
 
 ifeq ($(call cc-option-yn,-mstack-size=8192 -mstack-guard=128),y)
 cflags-$(CONFIG_CHECK_STACK) += -mstack-size=$(STACK_SIZE)
+ifneq ($(call cc-option-yn,-mstack-size=8192),y)
 cflags-$(CONFIG_CHECK_STACK) += -mstack-guard=$(CONFIG_STACK_GUARD)
 endif
+endif
 
 ifeq ($(call cc-option-yn,-mwarn-dynamicstack),y)
 cflags-$(CONFIG_WARN_STACK) += -mwarn-dynamicstack

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

