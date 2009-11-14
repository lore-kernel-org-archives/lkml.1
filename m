Return-Path: <linux-kernel-owner+w=401wt.eu-S1751993AbZKOHN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbZKOHN6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 02:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZKOHNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 02:13:55 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:40952 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbZKOHNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 02:13:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=Dw5hnOHd0WEh8T+wg8ZNLbZRkXUsd/Eb1zgOSxcx4kCPsRZE9PXNYmtlJoPBD3YO7c
         mZAJLKRGd0lHOAEcttLhZ4W/5c4DC37ER/Q9c2vE0vQFMmK+S5CGyGoapJL4VXqIZ7cL
         Bm3oU0097mddA2FSgWzIvYT37fI0PoTe1bG1Y=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: "linux list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH v5 01/12] vsprintf: factorize "(null)" string
Date: Sat, 14 Nov 2009 05:11:49 -0200
Message-Id: <3cc92c7a058e6c036759fa91bfab5cf0c3558a6f.1258181837.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e.dirty
In-Reply-To: <cover.1258181836.git.andre.goddard@gmail.com>
References: <cover.1258181836.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change "<NULL>" to "(null)", unifying 3 equal strings.
glibc also uses "(null)" for the same purpose.

It decreases code size by 7 bytes:
 text    data     bss     dec     hex filename
15765       0       8   15773    3d9d vsprintf.o (ex lib/lib.a-BEFORE)
15758       0       8   15766    3d96 vsprintf.o (ex lib/lib.a-AFTER)

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 lib/vsprintf.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 33bed5e..fe56825 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -546,12 +546,12 @@ static char *number(char *buf, char *end, unsigned long long num,
 	return buf;
 }
 
-static char *string(char *buf, char *end, char *s, struct printf_spec spec)
+static char *string(char *buf, char *end, const char *s, struct printf_spec spec)
 {
 	int len, i;
 
 	if ((unsigned long)s < PAGE_SIZE)
-		s = "<NULL>";
+		s = "(null)";
 
 	len = strnlen(s, spec.precision);
 
@@ -1445,7 +1445,7 @@ do {									\
 			size_t len;
 			if ((unsigned long)save_str > (unsigned long)-PAGE_SIZE
 					|| (unsigned long)save_str < PAGE_SIZE)
-				save_str = "<NULL>";
+				save_str = "(null)";
 			len = strlen(save_str);
 			if (str + len + 1 < end)
 				memcpy(str, save_str, len + 1);
-- 
1.6.5.2.180.gc5b3e.dirty

