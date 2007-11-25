Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbXKYV7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbXKYV7R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 16:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756012AbXKYV7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 16:59:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943AbXKYV7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 16:59:05 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 02/27] x86: segment selector macros
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20071125215831.409C726F8C5@magilla.localdomain>
Date: Sun, 25 Nov 2007 13:58:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This copies into asm-x86/segment_64.h some macros from asm-x86/segment_32.h
for dissecting segment selectors.  This lets other code use these macros
uniformly on 32/64-bit rather than duplicating the constants elsewhere.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/asm-x86/segment_64.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/segment_64.h b/include/asm-x86/segment_64.h
index 04b8ab2..dce7421 100644
--- a/include/asm-x86/segment_64.h
+++ b/include/asm-x86/segment_64.h
@@ -50,4 +50,15 @@
 #define GDT_SIZE (GDT_ENTRIES * 8)
 #define TLS_SIZE (GDT_ENTRY_TLS_ENTRIES * 8) 
 
+/* Bottom two bits of selector give the ring privilege level */
+#define SEGMENT_RPL_MASK	0x3
+/* Bit 2 is table indicator (LDT/GDT) */
+#define SEGMENT_TI_MASK		0x4
+
+/* User mode is privilege level 3 */
+#define USER_RPL		0x3
+/* LDT segment has TI set, GDT has it cleared */
+#define SEGMENT_LDT		0x4
+#define SEGMENT_GDT		0x0
+
 #endif
