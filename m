Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbXH2IXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbXH2IXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 04:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbXH2IXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 04:23:01 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58535 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbXH2IXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 04:23:00 -0400
X-Originating-Ip: 72.143.66.27
Date: Wed, 29 Aug 2007 04:12:19 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Add a "rounddown_pow_of_two" routine to log2.h.
Message-ID: <Pine.LNX.4.64.0708290409240.31605@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


To go along with the existing "roundup_pow_of_two" routine, add one
for rounding down since that operation appears to crop up on a regular
basis in the source tree.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  some brief tests indicate that these routines return the correct
answer.  i'm not sure if i've officially submitted this before or if
it's already been accepted in a tree somewhere.


diff --git a/include/linux/log2.h b/include/linux/log2.h
index 1b8a2c1..ff8835b 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -63,6 +63,15 @@ unsigned long __roundup_pow_of_two(unsigned long n)
 	return 1UL << fls_long(n - 1);
 }

+/*
+ * round down to nearest power of two
+ */
+static inline __attribute__((const))
+unsigned long __rounddown_pow_of_two(unsigned long n)
+{
+	return 1UL << (fls_long(n) - 1);
+}
+
 /**
  * ilog2 - log of base 2 of 32-bit or a 64-bit unsigned value
  * @n - parameter
@@ -165,4 +174,20 @@ unsigned long __roundup_pow_of_two(unsigned long n)
 	__roundup_pow_of_two(n)			\
  )

+/**
+ * rounddown_pow_of_two - round the given value down to nearest power of two
+ * @n - parameter
+ *
+ * round the given value down to the nearest power of two
+ * - the result is undefined when n == 0
+ * - this can be used to initialise global variables from constant data
+ */
+#define rounddown_pow_of_two(n)			\
+(						\
+	__builtin_constant_p(n) ? (		\
+		(n == 1) ? 0 :			\
+		(1UL << ilog2(n)) :		\
+	__rounddown_pow_of_two(n)		\
+ )
+
 #endif /* _LINUX_LOG2_H */
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
