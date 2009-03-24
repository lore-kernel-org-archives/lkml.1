Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbZCXIy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbZCXIy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbZCXIyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:54:49 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53006 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbZCXIys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:54:48 -0400
Subject: [PATCH] kmemtrace: fix build breakage in linux/key.h
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Mar 2009 10:54:46 +0200
Message-Id: <1237884886.25315.39.camel@penberg-laptop>
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

    CC [M]  fs/cifs/cifs_spnego.o
  In file included from include/keys/user-type.h:15,
                   from fs/cifs/cifs_spnego.c:24:
  include/linux/key.h:128: error: field ‘sem’ has incomplete type
  make[2]: *** [fs/cifs/cifs_spnego.o] Error 1
  make[1]: *** [fs/cifs] Error 2
  make: *** [fs] Error 2

Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/key.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/key.h b/include/linux/key.h
index 21d32a1..e544f46 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -20,6 +20,7 @@
 #include <linux/rbtree.h>
 #include <linux/rcupdate.h>
 #include <linux/sysctl.h>
+#include <linux/rwsem.h>
 #include <asm/atomic.h>
 
 #ifdef __KERNEL__
-- 
1.5.4.3



