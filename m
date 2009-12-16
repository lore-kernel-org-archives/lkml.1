Return-Path: <linux-kernel-owner+w=401wt.eu-S934708AbZLPIJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934708AbZLPIJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761751AbZLPIJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:09:20 -0500
Received: from mail.perches.com ([173.55.12.10]:1204 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761748AbZLPIJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:09:16 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/14] kernel.h: Move NIPQUAD and NIPQUAD_FMT to in.h
Date: Wed, 16 Dec 2009 00:09:06 -0800
Message-Id: <757a6b34dce3b030726c8c1d06123ec187114b28.1260949674.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1260949674.git.joe@perches.com>
References: <cover.1260949674.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the #defines to where they're actually useful.
All the current uses of NIPQUAD still compile successfully.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/in.h     |   11 +++++++++++
 include/linux/kernel.h |   11 -----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/in.h b/include/linux/in.h
index b615649..4e0f177 100644
--- a/include/linux/in.h
+++ b/include/linux/in.h
@@ -247,6 +247,17 @@ struct sockaddr_in {
 
 #ifdef __KERNEL__
 
+/*
+ *      Display an IP address in readable format.
+ */
+
+#define NIPQUAD(addr) \
+	((unsigned char *)&addr)[0], \
+	((unsigned char *)&addr)[1], \
+	((unsigned char *)&addr)[2], \
+	((unsigned char *)&addr)[3]
+#define NIPQUAD_FMT "%u.%u.%u.%u"
+
 static inline bool ipv4_is_loopback(__be32 addr)
 {
 	return (addr & htonl(0xff000000)) == htonl(0x7f000000);
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index f7144b1..1764d2d 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -240,17 +240,6 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 }
 
 /*
- *      Display an IP address in readable format.
- */
-
-#define NIPQUAD(addr) \
-	((unsigned char *)&addr)[0], \
-	((unsigned char *)&addr)[1], \
-	((unsigned char *)&addr)[2], \
-	((unsigned char *)&addr)[3]
-#define NIPQUAD_FMT "%u.%u.%u.%u"
-
-/*
  * min()/max()/clamp() macros that also do
  * strict type-checking.. See the
  * "unnecessary" pointer comparison.
-- 
1.6.6.rc0.57.gad7a

