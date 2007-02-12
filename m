Return-Path: <linux-kernel-owner+w=401wt.eu-S965010AbXBLQ7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965010AbXBLQ7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:59:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965008AbXBLQ5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:57:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964991AbXBLQvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:37 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <20070212551.664370000@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>, Andi Kleen <ak@suse.de>,
       Christoph Hellwig <hch@infradead.org>,
       Segher Boessenkool <segher@kernel.crashing.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [1/29] i386: avoid gcc extension
Date: Mon, 12 Feb 2007 17:51:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Randy Dunlap <randy.dunlap@oracle.com>

setcc() in math-emu is written as a gcc extension statement expression
macro that returns a value.  However, it's not used that way and it's not
needed like that, so just make it a do-while non-extension macro so that we
don't use an extension when it's not needed.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/math-emu/status_w.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux/arch/i386/math-emu/status_w.h
===================================================================
--- linux.orig/arch/i386/math-emu/status_w.h
+++ linux/arch/i386/math-emu/status_w.h
@@ -48,9 +48,11 @@
 
 #define status_word() \
   ((partial_status & ~SW_Top & 0xffff) | ((top << SW_Top_Shift) & SW_Top))
-#define setcc(cc) ({ \
-  partial_status &= ~(SW_C0|SW_C1|SW_C2|SW_C3); \
-  partial_status |= (cc) & (SW_C0|SW_C1|SW_C2|SW_C3); })
+static inline void setcc(int cc)
+{
+	partial_status &= ~(SW_C0|SW_C1|SW_C2|SW_C3);
+	partial_status |= (cc) & (SW_C0|SW_C1|SW_C2|SW_C3);
+}
 
 #ifdef PECULIAR_486
    /* Default, this conveys no information, but an 80486 does it. */
