Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbZCXIPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbZCXIPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbZCXIOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:14:36 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59343 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbZCXIOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:14:35 -0400
Subject: [PATCH 2/2] kmemtrace: fix build brekage in linux/fs.h
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Mar 2009 10:14:32 +0200
Message-Id: <1237882472.25315.32.camel@penberg-laptop>
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
headers, allow kmemtrace w/ tracepoints").

    CC      init/do_mounts_initrd.o
  In file included from init/do_mounts_initrd.c:3:
  include/linux/fs.h: In function ‘alloc_secdata’:
  include/linux/fs.h:2237: error: implicit declaration of function ‘get_zeroed_page’
  include/linux/fs.h:2237: error: ‘GFP_KERNEL’ undeclared (first use in this function)
  include/linux/fs.h:2237: error: (Each undeclared identifier is reported only once
  include/linux/fs.h:2237: error: for each function it appears in.)
  include/linux/fs.h: In function ‘free_secdata’:
  include/linux/fs.h:2242: error: implicit declaration of function ‘free_page’
  In file included from include/linux/slab.h:12,
                   from include/linux/percpu.h:5,
                   from include/linux/percpu_counter.h:13,
                   from include/linux/ext2_fs_sb.h:20,
                   from include/linux/ext2_fs.h:69,
                   from init/do_mounts_initrd.c:5:
  include/linux/gfp.h: At top level:
  include/linux/gfp.h:223: error: conflicting types for ‘get_zeroed_page’
  include/linux/fs.h:2237: error: previous implicit declaration of ‘get_zeroed_page’ was here
  make[1]: *** [init/do_mounts_initrd.o] Error 1
  make: *** [init] Error 2

Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/fs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 92734c0..add95da 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -8,6 +8,7 @@
 
 #include <linux/limits.h>
 #include <linux/ioctl.h>
+#include <linux/gfp.h>
 
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
-- 
1.5.4.3



