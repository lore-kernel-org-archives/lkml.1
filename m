Return-Path: <linux-kernel-owner+w=401wt.eu-S933783AbZHWSe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783AbZHWSe0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 14:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933658AbZHWSeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 14:34:25 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:64135 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933475AbZHWSeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 14:34:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=L5mmajFacoAeEFdKWhMN9PRwpcj/bfvMsWH0nr/RUFi/2cjUJPqNx9cVnx++xz/klc
         56+fLuOb7jH95bzEYWNGZtsXKH6fNHAcBTo9k9UMOGayJVoulsa7nf1+ofq686nIJDiB
         VU/tbwTnuK4Fmf5q7ymxe50KxBQNIxVqCsxRI=
Message-ID: <4A918BAF.8020600@gmail.com>
Date: Sun, 23 Aug 2009 20:34:23 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org
Subject: [PATCH] doc/rbtree: fix inserting example
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rb_link_node and rb_insert_color take pointer to struct rb_node
as a first parameter, but example code passes plain struct rb_node.
Fix it.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Rob Landley <rob@landley.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 Documentation/rbtree.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/rbtree.txt b/Documentation/rbtree.txt
index 7224459..b67a87e 100644
--- a/Documentation/rbtree.txt
+++ b/Documentation/rbtree.txt
@@ -131,8 +131,8 @@ Example:
   	}
 
   	/* Add new node and rebalance tree. */
-  	rb_link_node(data->node, parent, new);
-  	rb_insert_color(data->node, root);
+  	rb_link_node(&data->node, parent, new);
+  	rb_insert_color(&data->node, root);
 
 	return TRUE;
   }
-- 
1.6.3.3

