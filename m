Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbZGFJxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbZGFJxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 05:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbZGFJxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 05:53:04 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:58978 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbZGFJxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 05:53:04 -0400
Subject: [PATCH] kmemcheck: fix sparse warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 06 Jul 2009 11:53:03 +0200
Message-Id: <1246873983.20908.0.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whether or not the sparse warning

warning: do-while statement is not a compound statement

is justified or not in this case, it is annoying and
trivial to fix.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/kmemcheck.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/include/linux/kmemcheck.h	2009-07-06 11:41:16.000000000 +0200
+++ wireless-testing/include/linux/kmemcheck.h	2009-07-06 11:41:30.000000000 +0200
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


