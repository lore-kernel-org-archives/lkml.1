Return-Path: <linux-kernel-owner+w=401wt.eu-S1761516AbZCQAXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761516AbZCQAXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbZCQAWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:22:54 -0400
Received: from gw.goop.org ([64.81.55.164]:57086 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbZCQAWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:22:53 -0400
Message-ID: <49BEED59.4060700@goop.org>
Date: Mon, 16 Mar 2009 17:22:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: non-paravirt systems always have PSE and PGE
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A paravirtualized system may not have PSE or PGE available to
guests, to they are not required features.  However, without
paravirt we can assume that any x86-64 implementation will have
them available.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/include/asm/required-features.h b/arch/x86/include/asm/required-features.h
index d5cd6c5..64cf2d2 100644
--- a/arch/x86/include/asm/required-features.h
+++ b/arch/x86/include/asm/required-features.h
@@ -48,9 +48,15 @@
 #endif
 
 #ifdef CONFIG_X86_64
+#ifdef CONFIG_PARAVIRT
+/* Paravirtualized systems may not have PSE or PGE available */
 #define NEED_PSE	0
+#define NEED_PGE	0
+#else
+#define NEED_PSE	(1<<(X86_FEATURE_PSE) & 31)
+#define NEED_PGE	(1<<(X86_FEATURE_PGE) & 31)
+#endif
 #define NEED_MSR	(1<<(X86_FEATURE_MSR & 31))
-#define NEED_PGE	(1<<(X86_FEATURE_PGE & 31))
 #define NEED_FXSR	(1<<(X86_FEATURE_FXSR & 31))
 #define NEED_XMM	(1<<(X86_FEATURE_XMM & 31))
 #define NEED_XMM2	(1<<(X86_FEATURE_XMM2 & 31))


