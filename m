Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbZIYU2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbZIYU2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 16:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZIYU2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 16:28:09 -0400
Received: from relais.videotron.ca ([24.201.245.36]:56064 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbZIYU2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 16:28:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 25 Sep 2009 16:28:02 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frans Pop <elendil@planet.nl>, lkml <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org,
       Lennert Buytenhek <buytenh@marvell.com>
Subject: [PATCH] make Linux bootable on ARM again
In-reply-to: <200909252039.19789.elendil@planet.nl>
Message-id: <alpine.LFD.2.00.0909251613240.4997@xanadu.home>
References: <200909252039.19789.elendil@planet.nl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 200b812d00 "Clear the exclusive monitor when returning from an 
exception" broke the vast majority of ARM systems in the wild which are 
still pre ARMv6.  The kernel is crashing on the first occurrence of an 
exception due to the removal of the actual return instruction for them.  
Let's add it back.

Signed-off-by: Nicolas Pitre <nico@marvell.com>
---

diff --git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.S
index e17e3c3..ac34c0d 100644
--- a/arch/arm/kernel/entry-header.S
+++ b/arch/arm/kernel/entry-header.S
@@ -83,6 +83,8 @@
 	ldr	r0, [sp]
 	strex	r1, r2, [sp]			@ clear the exclusive monitor
 	ldmib	sp, {r1 - pc}^			@ load r1 - pc, cpsr
+#else
+	ldmia	sp, {r0 - pc}^			@ load r0 - pc, cpsr
 #endif
 	.endm
 
