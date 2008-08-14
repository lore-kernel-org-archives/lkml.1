Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbYHNJTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbYHNJTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 05:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbYHNJTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 05:19:42 -0400
Received: from mail.free-electrons.com ([88.191.46.45]:57699 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbYHNJTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 05:19:41 -0400
Date: Thu, 14 Aug 2008 11:19:34 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       swhiteho@redhat.com, cluster-devel@redhat.com,
       "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH -mm] fs.h: fix build error with !CONFIG_FILE_LOCKING
Message-ID: <20080814111934.6d68fa23@surf>
In-Reply-To: <20080808223228.GC5093@orion>
References: <20080808223228.GC5093@orion>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Sat, 9 Aug 2008 02:32:28 +0400,
Alexander Beregalov <a.beregalov@gmail.com> a écrit :

> I am not sure it is a right way to fix it, please review.
> Commit 4a70917f881a38ae688c98be9396f0a38f559094
> (configure-out-file-locking-features) changed behaviour.

I must admit that I'm quite confused by the commit you're referring to.
In which tree is it ?

Anyway, this problem has already been fixed in the latest version of
the patch I sent to LKML on August, 4th:
http://marc.info/?l=linux-kernel&m=121802891417797&w=2

However, I just sent another fixup patch to LKML, required to get NFS
server to compile with CONFIG_FILE_LOCKING=n. For reference, I copy it
below.

Sincerly,

Thomas

---

Fixup configure out fs locks support

This patch adds a few more stubs required to get NFS server to compile
properly with CONFIG_FILE_LOCKING=n.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

---
 include/linux/fs.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linuxdev/include/linux/fs.h
===================================================================
--- linuxdev.orig/include/linux/fs.h
+++ linuxdev/include/linux/fs.h
@@ -1050,6 +1050,8 @@
 #define __break_lease(a, b) ({ 0; })
 #define lease_get_mtime(a, b) ({ })
 #define generic_setlease(a, b, c) ({ -EINVAL; })
+#define vfs_setlease(a, b, c) ({ -EINVAL; })
+#define lease_modify(a, b) ({ -EINVAL; })
 #define lock_may_read(a, b, c) ({ 1; })
 #define lock_may_write(a, b, c) ({ 1; })
 #endif /* !CONFIG_FILE_LOCKING */


-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
