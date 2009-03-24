Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbZCXJOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbZCXJOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 05:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbZCXJNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 05:13:55 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54124 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581AbZCXJNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 05:13:55 -0400
Subject: [PATCH 1/2] kmemtrace: fix build breakage in
	lib/decompress_bunzip2.c
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Mar 2009 11:13:52 +0200
Message-Id: <1237886032.25315.48.camel@penberg-laptop>
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

    CC      lib/decompress_bunzip2.o
  lib/decompress_bunzip2.c: In function ‘start_bunzip’:
  lib/decompress_bunzip2.c:636: error: implicit declaration of function ‘kmalloc’
  lib/decompress_bunzip2.c:636: warning: assignment makes pointer from integer without a cast
  lib/decompress_bunzip2.c: In function ‘bunzip2’:
  lib/decompress_bunzip2.c:682: warning: assignment makes pointer from integer without a cast
  lib/decompress_bunzip2.c:693: warning: assignment makes pointer from integer without a cast
  lib/decompress_bunzip2.c:726: error: implicit declaration of function ‘kfree’
  make[1]: *** [lib/decompress_bunzip2.o] Error 1
  make: *** [lib/] Error 2

Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 lib/decompress_bunzip2.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index 5d3ddb5..708e2a8 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -50,6 +50,7 @@
 #endif /* !STATIC */
 
 #include <linux/decompress/mm.h>
+#include <linux/slab.h>
 
 #ifndef INT_MAX
 #define INT_MAX 0x7fffffff
-- 
1.5.4.3



