Return-Path: <linux-kernel-owner+w=401wt.eu-S1761150AbYBZDZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761150AbYBZDZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 22:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760674AbYBZDZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 22:25:15 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:32805 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755509AbYBZDZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 22:25:12 -0500
X-Sasl-enc: NMAuFYuQT50/bhgdPyb9aJlx2i/Mh2LKqq4weZQwD9sV 1203996311
Date: Tue, 26 Feb 2008 12:22:34 +0900 (WST)
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 1/4] autofs4 - check for invalid dentry in getpath
In-Reply-To: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
Message-ID: <Pine.LNX.4.64.0802261156490.8490@raven.themaw.net>
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
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
