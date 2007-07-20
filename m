Return-Path: <linux-kernel-owner+w=401wt.eu-S934659AbXGTPKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934659AbXGTPKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933882AbXGTPK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:10:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36136 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933665AbXGTPK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:10:28 -0400
Date: Fri, 20 Jul 2007 16:10:24 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: [PATCH] lguest misannotation
Message-ID: <20070720151024.GH21668@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	It's void __user *, not void * __user...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/lguest/io.c b/drivers/lguest/io.c
index 06bdba2..c8eb792 100644
--- a/drivers/lguest/io.c
+++ b/drivers/lguest/io.c
@@ -187,7 +187,7 @@ static u32 copy_data(struct lguest *srclg,
 		/* FIXME: This is not completely portable, since
 		   archs do different things for copy_to_user_page. */
 		if (copy_from_user(maddr + (dst->addr[di] + dstoff)%PAGE_SIZE,
-				   (void *__user)src->addr[si], len) != 0) {
+				   (void __user *)src->addr[si], len) != 0) {
 			kill_guest(srclg, "bad address in sending DMA");
 			totlen = 0;
 			break;
