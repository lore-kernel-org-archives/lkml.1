Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbZKOHN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbZKOHN5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 02:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbZKOHN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 02:13:56 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:40952 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZKOHNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 02:13:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=vKTUP48KkFJaS2HPGnpu9JDXzSyMsSs/CuM5kH2+bPGdOTjdSwACxWtaeUZIfcYygO
         vFb8gHS11MNKoYP4Sh6ZBhgu+GiLMV0grJu6L1JD8GT9tevTdMW3mtkewbZuS5pI9YQJ
         sOp/0SJrz68KP9+4n+NRVLXXzC4UVSyQn38jo=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: "linux list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH v5 02/12] vsprintf: pre-calculate final string length for later use
Date: Sat, 14 Nov 2009 05:11:50 -0200
Message-Id: <5687c764e200cd3a1c0a1ca7704265921e1362fb.1258181837.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e.dirty
In-Reply-To: <cover.1258181836.git.andre.goddard@gmail.com>
References: <cover.1258181836.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 lib/vsprintf.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index fe56825..1e08b0d 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1443,13 +1443,14 @@ do {									\
 		case FORMAT_TYPE_STR: {
 			const char *save_str = va_arg(args, char *);
 			size_t len;
+
 			if ((unsigned long)save_str > (unsigned long)-PAGE_SIZE
 					|| (unsigned long)save_str < PAGE_SIZE)
 				save_str = "(null)";
-			len = strlen(save_str);
-			if (str + len + 1 < end)
-				memcpy(str, save_str, len + 1);
-			str += len + 1;
+			len = strlen(save_str) + 1;
+			if (str + len < end)
+				memcpy(str, save_str, len);
+			str += len;
 			break;
 		}
 
-- 
1.6.5.2.180.gc5b3e.dirty

