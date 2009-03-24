Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbZCXJWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbZCXJWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 05:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756154AbZCXJWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 05:22:07 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:32890 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbZCXJWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 05:22:04 -0400
Subject: [PATCH] kmemtrace: fix build breakage in lib/decompress_unlzma.c
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Mar 2009 11:22:01 +0200
Message-Id: <1237886521.25315.58.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Impact: fix build

This patch fixes up the following build breakage caused by commit
e251ea2fa52321009940fad02238ef1c369531ae ("rcu: don't include unnecessary
headers, allow kmemtrace w/ tracepoints"):

    CC      lib/decompress_unlzma.o
  lib/decompress_unlzma.c: In function ‘rc_free’:
  lib/decompress_unlzma.c:122: error: implicit declaration of function ‘kfree’
  lib/decompress_unlzma.c: In function ‘unlzma’:
  lib/decompress_unlzma.c:551: error: implicit declaration of function ‘kmalloc’
  lib/decompress_unlzma.c:551: warning: assignment makes pointer from integer without a cast
  make[1]: *** [lib/decompress_unlzma.o] Error 1
  make: *** [lib/] Error 2

Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 lib/decompress_unlzma.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/decompress_unlzma.c b/lib/decompress_unlzma.c
index 546f2f4..32123a1 100644
--- a/lib/decompress_unlzma.c
+++ b/lib/decompress_unlzma.c
@@ -34,6 +34,7 @@
 #endif /* STATIC */
 
 #include <linux/decompress/mm.h>
+#include <linux/slab.h>
 
 #define	MIN(a, b) (((a) < (b)) ? (a) : (b))
 
-- 
1.5.4.3



