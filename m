Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbZKBR0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbZKBR0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756366AbZKBR0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:26:35 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:43316 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358AbZKBR0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:26:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=JCfIJfU7TYVHquqXP1b9PrsvSuA+n+b493djH/NcuUXxrOunjc5SrJW/7tAEpiC7fK
         VSyj/oarPWtyEHJu3dDbRbSKIDY/DGbJsia4yP0gnvRWy4JKGa4p5SgklTy8rND67P5z
         NAuUtqNG7RSpAJvPaicyQ8zLcLO5LQ1iFJdzs=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Mon, 2 Nov 2009 15:26:18 -0200
Message-ID: <b8bf37780911020926n35e36536w2de68ba80c87e669@mail.gmail.com>
Subject: [PATCH v2 2/7] vsprintf: pre-calculate final string length
To: Frederic Weisbecker <fweisbec@gmail.com>, laijs@cn.fujitsu.com,
       mingo@elte.hu, davem@davemloft.net, akpm@linux-foundation.org,
       harvey.harrison@gmail.com, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ad7ae7336da94fd87f8a2ef48ded02849d8f2e90 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Sun, 1 Nov 2009 12:21:50 -0200
Subject: [PATCH v2 2/7] vsprintf: pre-calculate final string length
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
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
1.6.5.2.140.g5f809
