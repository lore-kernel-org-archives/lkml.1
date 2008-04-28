Return-Path: <linux-kernel-owner+w=401wt.eu-S1765537AbYD1GWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765537AbYD1GWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbYD1GWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:22:12 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:34317 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177AbYD1GWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:22:10 -0400
X-Sasl-enc: Tpv9DVpr4K4mwTk2S7CdgDWuHAavXk5JcqvoB2n6fwqp 1209363729
Date: Mon, 28 Apr 2008 14:21:21 +0800 (WST)
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH] autofs4 - check for invalid dentry in getpath
Message-ID: <Pine.LNX.4.64.0804281419430.10684@raven.themaw.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

Patch to catch invalid dentry when calculating it's path.

Signed-off-by: Ian Kent <raven@themaw.net>

Ian

---
diff -up linux-2.6.25-rc2-mm1/fs/autofs4/waitq.c.getpath-check-valid-dentry linux-2.6.25-rc2-mm1/fs/autofs4/waitq.c
--- linux-2.6.25-rc2-mm1/fs/autofs4/waitq.c.getpath-check-valid-dentry	2008-02-20 12:55:39.000000000 +0900
+++ linux-2.6.25-rc2-mm1/fs/autofs4/waitq.c	2008-02-20 12:54:46.000000000 +0900
@@ -171,7 +171,7 @@ static int autofs4_getpath(struct autofs
 	for (tmp = dentry ; tmp != root ; tmp = tmp->d_parent)
 		len += tmp->d_name.len + 1;
 
-	if (--len > NAME_MAX) {
+	if (!len || --len > NAME_MAX) {
 		spin_unlock(&dcache_lock);
 		return 0;
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
