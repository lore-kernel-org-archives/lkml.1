Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbYEZJR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbYEZJR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 05:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbYEZJRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 05:17:19 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59993 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbYEZJRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 05:17:18 -0400
Message-Id: <20080526091741.735792000@bull.net>
References: <20080526091716.087875000@bull.net>
User-Agent: quilt/0.45-1
Date: Mon, 26 May 2008 11:17:17 +0200
From: Nadia.Derbey@bull.net
To: akpm@linux-foundation.org
Cc: mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH] Restore MSGPOOL original value
Content-Disposition: inline; filename=restore_msgpool_original_value.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When posting:
[PATCH 1/8] Scaling msgmni to the amount of lowmem
(see http://article.gmane.org/gmane.linux.kernel/637849/), I have changed the
MSGPOOL value to make it fit what is said in the man pages (i.e. a size in
bytes).

But Michael Kerrisk rightly complained that this change could affect the ABI.
So I'm posting this patch to make MSGPOOL expressed back in Kbytes.
Michael, on his side, has fixed the man page.

This patch applies to 2.6.26-rc2-mm1.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 include/linux/msg.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.26-rc2-mm1/include/linux/msg.h
===================================================================
--- linux-2.6.26-rc2-mm1.orig/include/linux/msg.h	2008-05-26 11:06:53.000000000 +0200
+++ linux-2.6.26-rc2-mm1/include/linux/msg.h	2008-05-26 11:18:34.000000000 +0200
@@ -64,11 +64,11 @@ struct msginfo {
 #define MSGMNB 16384   /* <= INT_MAX */   /* default max size of a message queue */
 
 /* unused */
-#define MSGPOOL (MSGMNI * MSGMNB) /* size in bytes of message pool */
+#define MSGPOOL (MSGMNI * MSGMNB / 1024) /* size in kbytes of message pool */
 #define MSGTQL  MSGMNB            /* number of system message headers */
 #define MSGMAP  MSGMNB            /* number of entries in message map */
 #define MSGSSZ  16                /* message segment size */
-#define __MSGSEG (MSGPOOL / MSGSSZ) /* max no. of segments */
+#define __MSGSEG ((MSGPOOL * 1024) / MSGSSZ) /* max no. of segments */
 #define MSGSEG (__MSGSEG <= 0xffff ? __MSGSEG : 0xffff)
 
 #ifdef __KERNEL__

--
