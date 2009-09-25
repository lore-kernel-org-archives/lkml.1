Return-Path: <linux-kernel-owner+w=401wt.eu-S1752846AbZIYOUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbZIYOUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 10:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbZIYOUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 10:20:13 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:52527 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbZIYOUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 10:20:12 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] lib/checksum.c: Fix another endianess bug
Date: Fri, 25 Sep 2009 15:20:40 +0100
Message-Id: <1253888440-14111-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.6.4.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matthew.fleming@imgtec.com>

This fix allows the generic checksum code to work on my little endian
system. The previous fix was not enough, as "buff" is a big-endian
value. Without this patch I see malformed TCP packets.

Signed-off-by: Matt Fleming <matthew.fleming@imgtec.com>
---
 lib/checksum.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/checksum.c b/lib/checksum.c
index b2e2fd4..c34f030 100644
--- a/lib/checksum.c
+++ b/lib/checksum.c
@@ -55,10 +55,10 @@ static unsigned int do_csum(const unsigned char *buff, int len)
 		goto out;
 	odd = 1 & (unsigned long) buff;
 	if (odd) {
-#ifdef __LITTLE_ENDIAN
+#ifdef __BIG_ENDIAN
 		result = *buff;
 #else
-		result += (*buff << 8);
+		result = (*buff << 8);
 #endif
 		len--;
 		buff++;
-- 
1.6.3.GIT

