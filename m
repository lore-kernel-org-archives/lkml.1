Return-Path: <linux-kernel-owner+w=401wt.eu-S1757668AbZCXJOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668AbZCXJOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 05:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbZCXJNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 05:13:54 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38121 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbZCXJNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 05:13:53 -0400
Subject: [PATCH 2/2] kmemtrace: fix build breakage in
	lib/decompress_inflate.c
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Mar 2009 11:13:50 +0200
Message-Id: <1237886030.25315.47.camel@penberg-laptop>
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

    CC      lib/decompress_inflate.o
  lib/decompress_inflate.c: In function ‘gunzip’:
  lib/decompress_inflate.c:45: error: implicit declaration of function ‘kmalloc’
  lib/decompress_inflate.c:45: warning: assignment makes pointer from integer without a cast
  lib/decompress_inflate.c:57: warning: assignment makes pointer from integer without a cast
  lib/decompress_inflate.c:65: warning: assignment makes pointer from integer without a cast
  lib/decompress_inflate.c:71: warning: assignment makes pointer from integer without a cast
  lib/decompress_inflate.c:154: error: implicit declaration of function ‘kfree’
  make[1]: *** [lib/decompress_inflate.o] Error 1
  make: *** [lib/] Error 2

Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 lib/decompress_inflate.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/decompress_inflate.c b/lib/decompress_inflate.c
index 839a329..e36b296 100644
--- a/lib/decompress_inflate.c
+++ b/lib/decompress_inflate.c
@@ -23,6 +23,7 @@
 #endif /* STATIC */
 
 #include <linux/decompress/mm.h>
+#include <linux/slab.h>
 
 #define INBUF_LEN (16*1024)
 
-- 
1.5.4.3



