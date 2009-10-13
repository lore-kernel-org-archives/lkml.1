Return-Path: <linux-kernel-owner+w=401wt.eu-S933780AbZJMIOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780AbZJMIOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 04:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933770AbZJMIOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 04:14:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:56569 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933769AbZJMIOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 04:14:21 -0400
Subject: [PATCH] fcntl: rename F_OWNER_GID to F_OWNER_PGRP
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       torvalds@linux-foundation.org, eranian@googlemail.com, hch@lst.de,
       oleg@redhat.com, roland@redhat.com, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org, Ulrich Drepper <drepper@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Oct 2009 10:13:23 +0200
Message-Id: <1255421603.8392.87.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed this patch never quite made it to LKML..

---
Subject: fcntl: rename F_OWNER_GID to F_OWNER_PGRP
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 05 Oct 2009 14:44:47 +0200

On Sat, 2009-10-03 at 14:09 +0200, Michael Kerrisk wrote:
> Please, could you change F_OWNER_GID to F_OWNER_PGRP.
>
> This is for consistency with various ioctl() operations that include
> the suffix "PGRP" in their names, and also for consistency with
> PRIO_PGRP, used with setpriority() and getpriority(). Also, using PGRP
> instead of GID avoids confusion with the common abbreviation of "group
> ID".

I'm fine with anything that makes it more consistent, and if PGRP is
what is the predominant abbreviation then I see no need to further
confuse matters by adding a third one.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
---
 fs/fcntl.c                  |    4 ++--
 include/asm-generic/fcntl.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/fs/fcntl.c
===================================================================
--- linux-2.6.orig/fs/fcntl.c
+++ linux-2.6/fs/fcntl.c
@@ -284,7 +284,7 @@ static int f_setown_ex(struct file *filp
 		type = PIDTYPE_PID;
 		break;
 
-	case F_OWNER_GID:
+	case F_OWNER_PGRP:
 		type = PIDTYPE_PGID;
 		break;
 
@@ -321,7 +321,7 @@ static int f_getown_ex(struct file *filp
 		break;
 
 	case PIDTYPE_PGID:
-		owner.type = F_OWNER_GID;
+		owner.type = F_OWNER_PGRP;
 		break;
 
 	default:
Index: linux-2.6/include/asm-generic/fcntl.h
===================================================================
--- linux-2.6.orig/include/asm-generic/fcntl.h
+++ linux-2.6/include/asm-generic/fcntl.h
@@ -80,7 +80,7 @@
 
 #define F_OWNER_TID	0
 #define F_OWNER_PID	1
-#define F_OWNER_GID	2
+#define F_OWNER_PGRP	2
 
 struct f_owner_ex {
 	int	type;

