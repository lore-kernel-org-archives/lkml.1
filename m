Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbYGGTYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbYGGTYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 15:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbYGGTYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 15:24:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:11076 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886AbYGGTYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 15:24:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=W7SHWJyuF13vs5C/M3HMD+2gXCzqpvgoRUNduqnGsnCSas3DdjtRznHuwMQ9szi7Cb
         C6fKI8bmF7P+aWxmNe5PqAngVYuYZW9u0ShW9fij/OMlM8JvLDJHNgkjk0QEFQ5m8Ogv
         rWdst0j8XWj0M+Uw0UGs6XzUbZRpUqWSt+2cY=
Date: Mon, 7 Jul 2008 21:24:29 +0200
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] vsprintf: fix gcc warning
Message-ID: <20080707192429.GA17551@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi :)

Does this look correct? Please disregard this if it has already
been fixed. Thanks.


Vegard

From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Mon, 7 Jul 2008 21:08:57 +0200
Subject: [PATCH] vsprintf: fix gcc warning

The patch

commit bf4bb495e5dc8f1abba98bb6cb08b2d94446a662
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Jul 5 22:37:13 2008 -0700

    printk: add support for '%pS'

introduced a new build warning from GCC (4.1.2):

  CC      lib/vsprintf.o
lib/vsprintf.c: In function `pointer':
lib/vsprintf.c:560: warning: cast from pointer to integer of different size

Whether the warning is useful or not is a discussion on its own. But
we can at least fix this by casting to 'unsigned long' instead of
'unsigned long long'. 'unsigned long' can hold a pointer and will be
converted implicitly to the right type upon calling the function.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 lib/vsprintf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index f60c7c0..39b6172 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -557,7 +557,7 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int base,
 		precision = 2*sizeof(void *);
 		type |= ZEROPAD;
 	}
-	return number(buf, end, (unsigned long long) ptr, base, size, precision, type);
+	return number(buf, end, (unsigned long) ptr, base, size, precision, type);
 }
 
 /**
-- 
1.5.4.1

