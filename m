Return-Path: <linux-kernel-owner+w=401wt.eu-S965063AbXHXDk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965063AbXHXDk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 23:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760105AbXHXDkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 23:40:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758140AbXHXDkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 23:40:13 -0400
Date: Fri, 24 Aug 2007 11:33:10 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: linux-kernel@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>, Arjan van de Ven <arjan@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] clean up exports in fs/{open,read_write}.c
Message-ID: <20070824033310.GA5662@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi-san fixed sound/isa/wavefront/wavefront_synth.c to use
request_firmware instead of sys_*. Since that is the last driver in the
kernel that uses sys_{read,close}, this patch kills these exports. sys_open
is left exported for sparc64 only.

Cc: Takashi Iwai <tiwai@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 fs/open.c       |    4 ++--
 fs/read_write.c |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 1d9e5e9..dc121ce 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1056,7 +1056,9 @@ asmlinkage long sys_open(const char __user *filename, int flags, int mode)
 	prevent_tail_call(ret);
 	return ret;
 }
+#ifdef CONFIG_SPARC64
 EXPORT_SYMBOL_GPL(sys_open);
+#endif
 
 asmlinkage long sys_openat(int dfd, const char __user *filename, int flags,
 			   int mode)
@@ -1148,8 +1150,6 @@ out_unlock:
 	return -EBADF;
 }
 
-EXPORT_SYMBOL(sys_close);
-
 /*
  * This routine simulates a hangup on the tty, to arrange that users
  * are given clean terminals at login time.
diff --git a/fs/read_write.c b/fs/read_write.c
index 507ddff..d913d1e 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -370,7 +370,6 @@ asmlinkage ssize_t sys_read(unsigned int fd, char __user * buf, size_t count)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(sys_read);
 
 asmlinkage ssize_t sys_write(unsigned int fd, const char __user * buf, size_t count)
 {

