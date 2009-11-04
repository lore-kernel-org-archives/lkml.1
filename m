Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbZKDOsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbZKDOsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 09:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756679AbZKDOsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 09:48:35 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:46847 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681AbZKDOse convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 09:48:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=qQ5AHwB8jQrl9t0RCyLOiCUlsHZiS8z0+D8BUHqgFfBKIjkLzDFZQbm9BExDzV3i3V
         4JWH3MgQGYCUkT3YhTRmLnO54C/9DUiwfUi41y8Cn33KfQ5jmNhbWcy3ZAbe/xN4wBwF
         uOcdFJhUXhUW5NXLBWt/Khrv0y6zM1L5oZ8pA=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Wed, 4 Nov 2009 12:48:19 -0200
Message-ID: <b8bf37780911040648q1e4a2dc5xf83ea35794f6d01e@mail.gmail.com>
Subject: [PATCH v3 2/7] vsprintf: pre-calculate final string length for later 
	use
To: Frederic Weisbecker <fweisbec@gmail.com>, laijs@cn.fujitsu.com,
       mingo@elte.hu, davem@davemloft.net, akpm@linux-foundation.org,
       harvey.harrison@gmail.com, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: André Goddard Rosa <andre.goddard@gmail.com>
Date: Tue, 3 Nov 2009 10:45:53 -0200
Subject: [PATCH v3 2/7] vsprintf: pre-calculate final string length
for later use
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 lib/vsprintf.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 002f462..403e835 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1445,13 +1445,15 @@ do {									\
 		case FORMAT_TYPE_STR: {
 			const char *save_str = va_arg(args, char *);
 			size_t len;
+
 			if ((unsigned long)save_str > (unsigned long)-PAGE_SIZE
 					|| (unsigned long)save_str < PAGE_SIZE)
 				save_str = null_str;
-			len = strlen(save_str);
-			if (str + len + 1 < end)
-				memcpy(str, save_str, len + 1);
-			str += len + 1;
+			len = strlen(save_str) + 1;
+			if (str + len < end)
+				memcpy(str, save_str, len);
+			str += len;
+
 			break;
 		}

-- 
1.6.5.2.143.g8cc62.dirty
