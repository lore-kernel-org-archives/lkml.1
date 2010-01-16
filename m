Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729Ab0AQVAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab0AQVAU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 16:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713Ab0AQVAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 16:00:01 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:48733 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab0AQU77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 15:59:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=oAuO5IG8TTNM8VhvFbdpVblEndvrgYwdO0QTJcsBEsd5rhLw77E5iX0GtrmkFWt37b
         3ecrnLH2oZyVZfEfHxcDKBTrxWOz3Jz2d1/d8SUMd0FoE8grbAleLvunWwQeENtuDMD0
         fOsIUKO+QDfpCK3MpBYvO8yf1Pv9OuZbVoljU=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Alex Riesen <raa.lkml@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] string: teach strnstr() to not search past NUL-terminator
Date: Sat, 16 Jan 2010 18:57:01 -0200
Message-Id: <30e5fd087ee6fbe992cde8f09d945ed160b0c117.1263675077.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.6.201.g56119
In-Reply-To: <cover.1263675077.git.andre.goddard@gmail.com>
References: <cover.1263675077.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As noticed by Alex Riesen at:
http://marc.info/?l=linux-kernel&m=126364040821071&w=2

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
cc: Li Zefan <lizf@cn.fujitsu.com>
cc: Alex Riesen <raa.lkml@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>
---
 lib/string.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/lib/string.c b/lib/string.c
index 0f86245..94bad34 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -689,11 +689,13 @@ EXPORT_SYMBOL(strstr);
  */
 char *strnstr(const char *s1, const char *s2, size_t len)
 {
-	size_t l1 = len, l2;
+	size_t l1, l2;
 
 	l2 = strlen(s2);
 	if (!l2)
 		return (char *)s1;
+	l1 = strlen(s1);
+	l1 = (l1 <= len) ? l1 : len;
 	while (l1 >= l2) {
 		l1--;
 		if (!memcmp(s1, s2, l2))
-- 
1.6.6.201.g56119

