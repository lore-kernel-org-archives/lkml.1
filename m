Return-Path: <linux-kernel-owner+w=401wt.eu-S1760504AbXKIXUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760504AbXKIXUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbXKIXTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:19:16 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:51341 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313AbXKIXTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:19:07 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 11/11] kbuild: sanity check the specified arch
Date: Sat, 10 Nov 2007 00:20:45 +0100
Message-Id: <11946504463364-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <20071109230812.GA5176@uranus.ravnborg.org>
References: <20071109230812.GA5176@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If the ARCH used does not exist print out the following:
Makefile:203: *** "ERROR: ARCH (i386) does not exist (for i386 and x86_64 use ARCH=x86)".  Stop.
This check is highly relevant now i386 and x86_64 are gone.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Christoph Hellwig <hch@infradead.org>
---
 Makefile |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index afeeef8..902082b 100644
--- a/Makefile
+++ b/Makefile
@@ -198,6 +198,11 @@ CROSS_COMPILE	?=
 UTS_MACHINE 	:= $(ARCH)
 SRCARCH 	:= $(ARCH)
 
+# Sanity check the specified ARCH
+ifeq ($(wildcard $(srctree)/arch/$(ARCH)/Kconfig),)
+        $(error "ERROR: ARCH ($(ARCH)) does not exist (for i386 and x86_64 use ARCH=x86)")
+endif
+
 KCONFIG_CONFIG	?= .config
 
 # SHELL used by kbuild
-- 
1.5.3.4.1157.g0e74-dirty

