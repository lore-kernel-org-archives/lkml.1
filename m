Return-Path: <linux-kernel-owner+w=401wt.eu-S1750879AbXCFUFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750879AbXCFUFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbXCFUFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:05:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbXCFUFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:05:53 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Use CONFIG_ARCH_HAS_ILOG2_xxx in __get_order() not
	ARCH_HAS_ILOG2_xxx
To: torvalds@osdl.org, akpm@osdl.org, adobriyan@gmail.com
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
Date: Tue, 06 Mar 2007 20:05:08 +0000
Message-ID: <20070306200508.23249.27096.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Use CONFIG_ARCH_HAS_ILOG2_xxx in __get_order() not ARCH_HAS_ILOG2_xxx as the
former is the right thing to use.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 include/asm-generic/page.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/page.h b/include/asm-generic/page.h
index c79dc23..3a22a76 100644
--- a/include/asm-generic/page.h
+++ b/include/asm-generic/page.h
@@ -16,12 +16,12 @@
 static inline __attribute__((const))
 int __get_order(unsigned long size, int page_shift)
 {
-#if BITS_PER_LONG == 32 && defined(ARCH_HAS_ILOG2_U32)
+#if BITS_PER_LONG == 32 && defined(CONFIG_ARCH_HAS_ILOG2_U32)
 	if (size <= (1UL << page_shift))
 		return 0;
 	else
 		return __ilog2_u32(size - 1) + 1 - page_shift;
-#elif BITS_PER_LONG == 64 && defined(ARCH_HAS_ILOG2_U64)
+#elif BITS_PER_LONG == 64 && defined(CONFIG_ARCH_HAS_ILOG2_U64)
 	if (size <= (1UL << page_shift))
 		return 0;
 	else

