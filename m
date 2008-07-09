Return-Path: <linux-kernel-owner+w=401wt.eu-S1757783AbYGIMuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783AbYGIMuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 08:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbYGIMu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 08:50:27 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:33159 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbYGIMu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 08:50:27 -0400
Message-Id: <20080709082903.421351000@sipsolutions.net>
References: <20080709082834.942992000@sipsolutions.net>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 10:28:39 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH -next 05/11] remove CONFIG_KMOD from sparc64
Content-Disposition: inline; filename=007-config-kmod-remove-sparc64.patch
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One place is just a comment, the other a conditional, unused
inclusion of linux/kmod.h.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: David S. Miller <davem@davemloft.net>
---
 arch/sparc64/kernel/process.c |    6 +++---
 arch/sparc64/kernel/traps.c   |    3 ---
 2 files changed, 3 insertions(+), 6 deletions(-)

--- everything.orig/arch/sparc64/kernel/traps.c	2008-07-08 21:53:12.000000000 +0200
+++ everything/arch/sparc64/kernel/traps.c	2008-07-08 22:00:28.000000000 +0200
@@ -37,9 +37,6 @@
 #include <asm/processor.h>
 #include <asm/timer.h>
 #include <asm/head.h>
-#ifdef CONFIG_KMOD
-#include <linux/kmod.h>
-#endif
 #include <asm/prom.h>
 
 #include "entry.h"
--- everything.orig/arch/sparc64/kernel/process.c	2008-07-08 21:53:11.000000000 +0200
+++ everything/arch/sparc64/kernel/process.c	2008-07-08 22:00:28.000000000 +0200
@@ -691,9 +691,9 @@ int copy_thread(int nr, unsigned long cl
 		  ((unsigned long) child_sf) - STACK_BIAS;
 
 		/* Special case, if we are spawning a kernel thread from
-		 * a userspace task (via KMOD, NFS, or similar) we must
-		 * disable performance counters in the child because the
-		 * address space and protection realm are changing.
+		 * a userspace task (usermode helper, NFS or similar), we
+		 * must disable performance counters in the child because
+		 * the address space and protection realm are changing.
 		 */
 		if (t->flags & _TIF_PERFCTR) {
 			t->user_cntd0 = t->user_cntd1 = NULL;

-- 
