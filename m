Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbZIZM2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbZIZM2G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 08:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZIZM2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 08:28:05 -0400
Received: from jester.euphonynet.be ([212.87.96.13]:47081 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbZIZM2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 08:28:04 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Sep 2009 08:28:04 EDT
From: Bart Van Assche <bart.vanassche@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.31.1] include/linux/kmemcheck.h: fix a sparse warning
Date: Sat, 26 Sep 2009 14:28:06 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.30.4-scst-debug; KDE/4.3.1; x86_64; ; )
Cc: Vegard Nossum <vegardno@ifi.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909261428.06802.bart.vanassche@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking a 2.6.31.1 kernel configured with allyesconfig/allmodconfig
with sparse (make C=2) triggers a sparse warning on code that uses the
kmemcheck_annotate_bitfield() macro. An example of such a warning:

include/net/inet_sock.h:208:17: warning: do-while statement is not a compound statement

Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Vegard Nossum <vegardno@ifi.uio.no>
Cc: Andrew Morton <akpm@linux-foundation.org>

--- linux-2.6.31.1/include/linux/kmemcheck-orig.h	2009-09-26 13:53:44.000000000 +0200
+++ linux-2.6.31.1/include/linux/kmemcheck.h	2009-09-26 13:53:56.000000000 +0200
@@ -137,13 +137,13 @@ static inline void kmemcheck_mark_initia
 	int name##_end[0];
 
 #define kmemcheck_annotate_bitfield(ptr, name)				\
-	do if (ptr) {							\
+	do { if (ptr) {							\
 		int _n = (long) &((ptr)->name##_end)			\
 			- (long) &((ptr)->name##_begin);		\
 		BUILD_BUG_ON(_n < 0);					\
 									\
 		kmemcheck_mark_initialized(&((ptr)->name##_begin), _n);	\
-	} while (0)
+	} } while (0)
 
 #define kmemcheck_annotate_variable(var)				\
 	do {								\
