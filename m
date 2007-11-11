Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbXKKD4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbXKKD4f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 22:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbXKKD4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 22:56:22 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:42837 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbXKKD4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 22:56:21 -0500
Date: Sat, 10 Nov 2007 22:53:36 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] log2.h: Define order_base_2() macro for convenience.
Message-ID: <Pine.LNX.4.64.0711102249110.7449@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Given a number of places in the tree that need to calculate this value
explicitly, might as well just create a macro for it.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  run-time tested for the first several values.  note that this macro
is defined strictly in terms of rounding *up* -- i've seen no places
in the tree that require this expression to be rounded down, so i'm
not drawing that distinction.

diff --git a/include/linux/log2.h b/include/linux/log2.h
index c8cf5e8..ed121c0 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -190,4 +190,20 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
 	__rounddown_pow_of_two(n)		\
  )

+/**
+ * order_base_2 - calculate the (rounded up) base 2 order of the argument
+ * @n - parameter
+ *
+ * The first few values calculated by this routine:
+ *  ob2(0) = 0
+ *  ob2(1) = 0
+ *  ob2(2) = 1
+ *  ob2(3) = 2
+ *  ob2(4) = 2
+ *  ob2(5) = 3
+ *  ... and so on.
+ */
+
+#define order_base_2(n) ilog2(roundup_pow_of_two(n))
+
 #endif /* _LINUX_LOG2_H */

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
