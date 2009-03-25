Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbZCYKs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbZCYKs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 06:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756885AbZCYKsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 06:48:17 -0400
Received: from mx1.emlix.com ([193.175.82.87]:59906 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbZCYKsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 06:48:16 -0400
From: Oskar Schirmer <os@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org,
       Oskar Schirmer <os@emlix.com>
Subject: [patch 4/4] xtensa: s6000 isef exception
Date: Wed, 25 Mar 2009 11:49:18 +0100
Message-Id: <1237978158-23603-4-git-send-email-os@emlix.com>
In-Reply-To: <1237978158-23603-1-git-send-email-os@emlix.com>
References: <1237978158-23603-1-git-send-email-os@emlix.com>
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the ISEF being used implicitly, loading functionality into its ALU
on demand through an exception handler.

Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 arch/xtensa/kernel/traps.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index 9f0b711..a26b367 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -66,6 +66,10 @@ extern void do_page_fault (struct pt_regs*, unsigned long);
 extern void do_debug (struct pt_regs*);
 extern void system_call (struct pt_regs*);
 
+#ifdef CONFIG_XTENSA_VARIANT_S6000
+extern void s6_isef_autoload(struct pt_regs*, unsigned long);
+#endif
+
 /*
  * The vector table must be preceded by a save area (which
  * implies it must be in RAM, unless one places RAM immediately
@@ -142,9 +146,13 @@ COPROCESSOR(5),
 #if XTENSA_HAVE_COPROCESSOR(6)
 COPROCESSOR(6),
 #endif
+#ifdef CONFIG_XTENSA_VARIANT_S6000
+{ EXCCAUSE_COPROCESSOR7_DISABLED, 0, s6_isef_autoload },
+#else
 #if XTENSA_HAVE_COPROCESSOR(7)
 COPROCESSOR(7),
 #endif
+#endif
 { EXCCAUSE_MAPPED_DEBUG,		0,		do_debug },
 { -1, -1, 0 }
 
-- 
1.6.2.107.ge47ee

