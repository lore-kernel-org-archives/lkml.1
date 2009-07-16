Return-Path: <linux-kernel-owner+w=401wt.eu-S1756948AbZGPBe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbZGPBe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 21:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756861AbZGPBeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 21:34:25 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4819 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824AbZGPBeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 21:34:25 -0400
Subject: [PATCH] kernel.h: Verify that arguments to swap() are the same type
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 18:34:21 -0700
Message-Id: <1247708061.15087.13.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d6320a3..72878a5 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -637,8 +637,13 @@ static inline void ftrace_dump(void) { }
 /*
  * swap - swap value of @a and @b
  */
-#define swap(a, b) \
-	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
+#define swap(a, b)				\
+do {						\
+	typeof(a) __tmp = (a);			\
+	BUILD_BUG_ON(!__same_type(__tmp, (b)));	\
+	(a) = (b);				\
+	(b) = __tmp;				\
+} while (0)
 
 /**
  * container_of - cast a member of a structure out to the containing structure


