Return-Path: <linux-kernel-owner+w=401wt.eu-S1756286AbZCXIoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbZCXIoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbZCXIny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:43:54 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37379 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbZCXIny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:43:54 -0400
Subject: [PATCH] kmemtrace: fix build breakage in befs
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Mar 2009 10:43:50 +0200
Message-Id: <1237884230.25315.33.camel@penberg-laptop>
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

    CC      fs/befs/debug.o
  fs/befs/debug.c: In function ‘befs_error’:
  fs/befs/debug.c:31: error: implicit declaration of function ‘kmalloc’
  fs/befs/debug.c:31: warning: initialization makes pointer from integer without a cast
  fs/befs/debug.c:42: error: implicit declaration of function ‘kfree’
  fs/befs/debug.c: In function ‘befs_warning’:
  fs/befs/debug.c:49: warning: initialization makes pointer from integer without a cast
  fs/befs/debug.c: In function ‘befs_debug’:
  fs/befs/debug.c:73: warning: assignment makes pointer from integer without a cast
  make[1]: *** [fs/befs/debug.o] Error 1
  make: *** [fs/befs/] Error 2

Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/befs/debug.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/befs/debug.c b/fs/befs/debug.c
index b8e304a..622e737 100644
--- a/fs/befs/debug.c
+++ b/fs/befs/debug.c
@@ -17,6 +17,7 @@
 #include <linux/spinlock.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
+#include <linux/slab.h>
 
 #endif				/* __KERNEL__ */
 
-- 
1.5.4.3



