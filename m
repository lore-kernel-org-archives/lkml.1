Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab0AOBth (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084Ab0AOBtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:49:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:6366 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab0AOBtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:49:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,278,1262592000"; 
   d="scan'208";a="764388955"
Message-Id: <20100115014422.267373147@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Jan 2010 09:39:55 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
CC: Nick Piggin <npiggin@suse.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: David Howells <dhowells@redhat.com>
CC: Jonathan Corbet <corbet@lwn.net>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 1/6] fanotify: fix FMODE_NONOTIFY bit number
References: <20100115013954.311049665@intel.com>
Content-Disposition: inline; filename=fanotify-bit-fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FMODE_NONOTIFY=0x800000 collides with __O_SYNC in sparc,
so change it to 0x1000000.

CC: Eric Paris <eparis@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/asm-generic/fcntl.h |    2 +-
 include/linux/fs.h          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux.orig/include/asm-generic/fcntl.h	2010-01-05 10:42:36.000000000 +0800
+++ linux/include/asm-generic/fcntl.h	2010-01-05 10:42:57.000000000 +0800
@@ -5,7 +5,7 @@
 
 /*
  * FMODE_EXEC is 0x20
- * FMODE_NONOTIFY is 0x800000
+ * FMODE_NONOTIFY is 0x1000000
  * These cannot be used by userspace O_* until internal and external open
  * flags are split.
  * -Eric Paris
--- linux.orig/include/linux/fs.h	2010-01-05 10:40:33.000000000 +0800
+++ linux/include/linux/fs.h	2010-01-05 10:42:07.000000000 +0800
@@ -88,7 +88,7 @@ struct inodes_stat_t {
 #define FMODE_NOCMTIME		((__force fmode_t)2048)
 
 /* File was opened by fanotify and shouldn't generate fanotify events */
-#define FMODE_NONOTIFY		((__force fmode_t)8388608)
+#define FMODE_NONOTIFY		((__force fmode_t)0x1000000)
 
 /*
  * The below are the various read and write types that we support. Some of


