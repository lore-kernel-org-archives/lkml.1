Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbZKMJ6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbZKMJ6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbZKMJ6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:58:46 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:50169 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780AbZKMJ6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:58:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SCIeFt+t+TZ3zIIUPnf1s0otSZqw0ODiPc4PrmPmYej5wEWqpcHylrKxGQUp9ANFED
         dQytnCh0DdsEwLkqimq0lPh2Mboz/1+YgsVmdH3mHbaeGA0m6PeeONKZ6DyfCEwl+iUt
         iiuvc8btTLwvAlNotRjpuJzyGOwH8JTr4OqcM=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Anders Larsen <al@alarsen.net>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v2] qnx4: Use hweight8
Date: Fri, 13 Nov 2009 18:57:45 +0900
Message-Id: <1258106265-18181-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1258104305l.9440l.0l@i-dmzi_al.realan.de>
References: <1258104305l.9440l.0l@i-dmzi_al.realan.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The original code counted the number of zeroes whereas hweight8() counts ones, so
>
> NAK
>
> (hint: "tot += 8 - hweight8(b)" should do the trick)

Oops,

Subject: [PATCH v2] qnx4: Use hweight8

Use hweight8 instead of counting for each bit

[ v2: count_bit() counts zero bits in the bitmap]

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Anders Larsen <al@alarsen.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/qnx4/bitmap.c |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/fs/qnx4/bitmap.c b/fs/qnx4/bitmap.c
index 0afba06..cbaae72 100644
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
+		tot += 8 - hweight8(b);
 		size--;
 	} while (size != 0);
 	*tf = tot;
-- 
1.6.5.1

