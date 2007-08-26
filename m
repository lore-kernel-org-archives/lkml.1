Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbXHZOIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbXHZOIr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 10:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbXHZOIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 10:08:39 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:36618 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbXHZOIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 10:08:38 -0400
Message-id: <880710657292153543@pripojeni.net>
Subject: [PATCH 1/1] remove BITS_TO_TYPE macro
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 26 Aug 2007 10:08:38 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

remove BITS_TO_TYPE macro

I realized, that it is actually the same as DIV_ROUND_UP, use it instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit c1b003cd9e5befbc3d915a9e37f46585127f9d1f
tree d800859baebde3f7fcb001801d32c528c4240250
parent 5a28a23f3c53993aaf6e7ef6c392e5f4c20d4a3b
author Jiri Slaby <jirislaby@gmail.com> Sun, 26 Aug 2007 15:50:39 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sun, 26 Aug 2007 15:50:39 +0200

 include/linux/bitops.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index a57b81f..8b5ecf8 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -6,8 +6,7 @@
 #define BIT(nr)			(1UL << (nr))
 #define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
 #define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
-#define BITS_TO_TYPE(nr, t)	(((nr)+(t)-1)/(t))
-#define BITS_TO_LONGS(nr)	BITS_TO_TYPE(nr, BITS_PER_LONG)
+#define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_LONG)
 #define BITS_PER_BYTE		8
 #endif
 
