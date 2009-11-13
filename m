Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbZKMHG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbZKMHG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 02:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbZKMHGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 02:06:55 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:54709 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbZKMHGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 02:06:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=i9xs4h5mrq7203dyZjBp5cGOkUT37whd9gYFSln+2WRNZaYBLHJir0sj0YuOszutiM
         fBLdH6daeLuIGHrqxhlD2ODrjbYireP1ynz8J5Wqxva6pTqfgKCJ7Xg/0nT5W+bwSgeG
         ZY8WnyNOKRSIV0bAf8iJZZJsFfa9ZhzWbEbww=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Anders Larsen <al@alarsen.net>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] qnx4: Use hweight8
Date: Fri, 13 Nov 2009 16:06:18 +0900
Message-Id: <1258095978-13380-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use hweight8 instead of counting for each bit

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Anders Larsen <al@alarsen.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/qnx4/bitmap.c |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/fs/qnx4/bitmap.c b/fs/qnx4/bitmap.c
index 0afba06..b913e3d 100644
--- a/fs/qnx4/bitmap.c
+++ b/fs/qnx4/bitmap.c
@@ -35,22 +35,7 @@ static void count_bits(register const char *bmPart, register int size,
 	}
 	do {
 		b = *bmPart++;
-		if ((b & 1) == 0)
-			tot++;
-		if ((b & 2) == 0)
-			tot++;
-		if ((b & 4) == 0)
-			tot++;
-		if ((b & 8) == 0)
-			tot++;
-		if ((b & 16) == 0)
-			tot++;
-		if ((b & 32) == 0)
-			tot++;
-		if ((b & 64) == 0)
-			tot++;
-		if ((b & 128) == 0)
-			tot++;
+		tot += hweight8(b);
 		size--;
 	} while (size != 0);
 	*tf = tot;
-- 
1.6.5.1

