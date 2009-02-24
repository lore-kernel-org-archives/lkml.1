Return-Path: <linux-kernel-owner+w=401wt.eu-S1760383AbZBXRb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383AbZBXRb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759989AbZBXR3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:29:10 -0500
Received: from host64.cybernetics.com ([98.174.209.230]:3976 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759448AbZBXR3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:29:09 -0500
Message-ID: <49A42E62.3090003@cybernetics.com>
Date: Tue, 24 Feb 2009 12:29:06 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] [-mm] epoll: use real type instead of void *
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eventpoll.c uses void * in one place for no obvious reason; change
it to use the real type instead.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

This patch is against the current -mm tree, and might not apply
to 2.6.29.  Since this patch probably won't go into 2.6.29, you may
apply this version of the patch after the other patches in -mm.

--- a/fs/eventpoll.c	2009-02-23 13:32:00.000000000 -0500
+++ b/fs/eventpoll.c	2009-02-23 13:32:57.000000000 -0500
@@ -192,7 +192,7 @@ struct eppoll_entry {
 	struct list_head llink;
 
 	/* The "base" pointer is set to the container "struct epitem" */
-	void *base;
+	struct epitem *base;
 
 	/*
 	 * Wait queue item that will be linked to the target file wait

