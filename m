Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbYIAN2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbYIAN2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 09:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYIAN2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 09:28:45 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:54327 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYIAN2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 09:28:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=Vn5hJoRD18pPGhpqgJCmospoqTtSkS44hWtiH2i9Mi5fHCeB0QkMB26Gkpc7R5jNuE
         MOUFTte+vpw7owu4RW7RfXhytE6k/CM36M4hMxudYR7QTDP+F3dzgLdGoyFw2PEWIccV
         vj4Wu47Vws70R3yniRj2dwPxva+1j4DUN+GgI=
Message-ID: <48BBEE04.30903@panasas.com>
Date: Mon, 01 Sep 2008 16:28:36 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       "David S. Miller" <davem@davemloft.net>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] debug: BUILD_BUG_ON: error on non-const expressions
References: <48BBE77D.7070007@panasas.com>
In-Reply-To: <48BBE77D.7070007@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Fix BUILD_BUG_ON to not silently drop non-compile-time
visible expressions.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Theodore Tso <tytso@mit.edu>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jan Beulich <jbeulich@novell.com>
CC: David S. Miller <davem@davemloft.net>
CC: Ivo van Doorn <IvDoorn@gmail.com>
CC: John W. Linville <linville@tuxdriver.com>
---
 include/linux/compiler.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 90fa975..f677ab9 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -195,7 +195,10 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
 
 /* Force a compilation error if condition is true */
-#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+#define BUILD_BUG_ON(condition)					  \
+do {									  \
+	static struct { char arr[1 - 2*!!(condition)]; } x __maybe_unused;\
+} while(0)
 
 /* Force a compilation error if condition is true, but also produce a
    result (of value 0 and type size_t), so the expression can be used
-- 
1.5.6.rc1.5.gadf6


