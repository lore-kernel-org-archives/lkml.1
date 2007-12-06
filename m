Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbXLFQIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbXLFQIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 11:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755128AbXLFQIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 11:08:10 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:1307 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074AbXLFQIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 11:08:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=L+mKLL1z+UtVaRMqixg4H5pNXgzh0KdoKfesOMfQGWlI51vEOZyHU04XhM+yCPS44ii/Z+WcMQj3mRDzrhfUTWOVvYaqHz6F3j3nktcTTNEaBqv94JT6Iq91RXJXYOd3R7P7R9dmphlD4eWz39JvDakhTCCtGc0Z2HHe8OasQEw=
From: Denis Cheng <crquan@gmail.com>
To: linux-x25@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 16/20] net/x25/: use LIST_HEAD instead of LIST_HEAD_INIT
Date: Fri,  7 Dec 2007 00:07:19 +0800
Message-Id: <1196957239-5728-2-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1196957239-5728-1-git-send-email-crquan@gmail.com>
References: <
 <1196957239-5728-1-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

single list_head variable initialized with LIST_HEAD_INIT could almost
always can be replaced with LIST_HEAD declaration, this shrinks the code
and looks better.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 net/x25/x25_forward.c |    2 +-
 net/x25/x25_link.c    |    2 +-
 net/x25/x25_route.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/x25/x25_forward.c b/net/x25/x25_forward.c
index 8738ec7..4dd8ff7 100644
--- a/net/x25/x25_forward.c
+++ b/net/x25/x25_forward.c
@@ -12,7 +12,7 @@
 #include <linux/init.h>
 #include <net/x25.h>
 
-struct list_head x25_forward_list = LIST_HEAD_INIT(x25_forward_list);
+LIST_HEAD(x25_forward_list);
 DEFINE_RWLOCK(x25_forward_list_lock);
 
 int x25_forward_call(struct x25_address *dest_addr, struct x25_neigh *from,
diff --git a/net/x25/x25_link.c b/net/x25/x25_link.c
index 741ce95..4a3602e 100644
--- a/net/x25/x25_link.c
+++ b/net/x25/x25_link.c
@@ -30,7 +30,7 @@
 #include <linux/init.h>
 #include <net/x25.h>
 
-static struct list_head x25_neigh_list = LIST_HEAD_INIT(x25_neigh_list);
+static LIST_HEAD(x25_neigh_list);
 static DEFINE_RWLOCK(x25_neigh_list_lock);
 
 static void x25_t20timer_expiry(unsigned long);
diff --git a/net/x25/x25_route.c b/net/x25/x25_route.c
index 86b5b4d..2c999cc 100644
--- a/net/x25/x25_route.c
+++ b/net/x25/x25_route.c
@@ -21,7 +21,7 @@
 #include <linux/init.h>
 #include <net/x25.h>
 
-struct list_head x25_route_list = LIST_HEAD_INIT(x25_route_list);
+LIST_HEAD(x25_route_list);
 DEFINE_RWLOCK(x25_route_list_lock);
 
 /*
-- 
1.5.3.4

