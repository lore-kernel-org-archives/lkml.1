Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbZCXI46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbZCXI46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbZCXI4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:56:43 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38866 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbZCXI4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:56:42 -0400
Subject: [PATCH] kmemtrace: fix build breakage in squasfs
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Mar 2009 10:56:39 +0200
Message-Id: <1237884999.25315.41.camel@penberg-laptop>
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

    CC      fs/squashfs/export.o
  fs/squashfs/export.c: In function ‘squashfs_read_inode_lookup_table’:
  fs/squashfs/export.c:133: error: implicit declaration of function ‘kmalloc’
  fs/squashfs/export.c:133: warning: assignment makes pointer from integer without a cast
  fs/squashfs/export.c:143: error: implicit declaration of function ‘kfree’
  make[1]: *** [fs/squashfs/export.o] Error 1
  make: *** [fs/squashfs/] Error 2

Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/squashfs/export.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/squashfs/export.c b/fs/squashfs/export.c
index 69e971d..2b1b8fe 100644
--- a/fs/squashfs/export.c
+++ b/fs/squashfs/export.c
@@ -40,6 +40,7 @@
 #include <linux/dcache.h>
 #include <linux/exportfs.h>
 #include <linux/zlib.h>
+#include <linux/slab.h>
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
-- 
1.5.4.3



