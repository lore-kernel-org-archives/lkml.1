Return-Path: <linux-kernel-owner+w=401wt.eu-S933382AbXGKTZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382AbXGKTZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762659AbXGKTTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:19:40 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38281 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411AbXGKTTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:19:31 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 13/33] Header file to produce 16-bit code with gcc
Date: Wed, 11 Jul 2007 12:18:38 -0700
Message-Id: <1184181540369-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841815401013-git-send-email-hpa@zytor.com>
References: <1184181538674-git-send-email-hpa@zytor.com>
 <118418153862-git-send-email-hpa@zytor.com>
 <11841815382283-git-send-email-hpa@zytor.com>
 <11841815392122-git-send-email-hpa@zytor.com>
 <11841815393975-git-send-email-hpa@zytor.com>
 <11841815393014-git-send-email-hpa@zytor.com>
 <1184181539416-git-send-email-hpa@zytor.com>
 <118418153972-git-send-email-hpa@zytor.com>
 <11841815391923-git-send-email-hpa@zytor.com>
 <11841815403678-git-send-email-hpa@zytor.com>
 <11841815403041-git-send-email-hpa@zytor.com>
 <11841815402349-git-send-email-hpa@zytor.com>
 <11841815401013-git-send-email-hpa@zytor.com>
Message-Id: <ab1907cf095c021d5e721b9df84d7c4e6de82e66.1184181208.git.hpa@zytor.com>
In-Reply-To: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
References: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

gcc for i386 can be used with the assembly prefix ".code16gcc" to generate
16-bit (real-mode) code.  This header file provides the assembly prefix.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/boot/code16gcc.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)
 create mode 100644 arch/i386/boot/code16gcc.h

diff --git a/arch/i386/boot/code16gcc.h b/arch/i386/boot/code16gcc.h
new file mode 100644
index 0000000..3bd8480
--- /dev/null
+++ b/arch/i386/boot/code16gcc.h
@@ -0,0 +1,15 @@
+/*
+ * code16gcc.h
+ *
+ * This file is -include'd when compiling 16-bit C code.
+ * Note: this asm() needs to be emitted before gcc omits any code.
+ * Depending on gcc version, this requires -fno-unit-at-a-time or
+ * -fno-toplevel-reorder.
+ *
+ * Hopefully gcc will eventually have a real -m16 option so we can
+ * drop this hack long term.
+ */
+
+#ifndef __ASSEMBLY__
+asm(".code16gcc");
+#endif
-- 
1.5.2.2

