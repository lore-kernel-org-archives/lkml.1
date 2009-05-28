Return-Path: <linux-kernel-owner+w=401wt.eu-S1763590AbZE1Qmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763590AbZE1Qmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 12:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763283AbZE1QmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 12:42:19 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:48443 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763450AbZE1QmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 12:42:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xN2DWmwNny1RZLpLutl58q8S7TnQnkMqYme7E5AnMtnkewMGprANntDkZn/d5fYi3g
         IVJEpHlytQtOWN5XdorZBVHQCegkB+HVsHvtcJO+8fAoCUrvw/ty+gQ5du3G2MxJRrzq
         0AtDKyGcxiLfs6Ke7TfCOH9GbN8ILGQAwmLgA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/3] tracing/stat: remember to free root node
Date: Thu, 28 May 2009 18:42:09 +0200
Message-Id: <1243528930-5318-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243528930-5318-1-git-send-email-fweisbec@gmail.com>
References: <1243528930-5318-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

When closing a trace_stat file, we destroy the rbtree constructed during
file open, but there is memory leak that the root node is not freed.

[ Impact: fix memory leak when closing a trace_stat file ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_stat.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 8b7420a..a80d947 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -60,8 +60,8 @@ static struct rb_node *release_next(struct rb_node *node)
 		return node->rb_right;
 	else {
 		if (!parent)
-			return NULL;
-		if (parent->rb_left == node)
+			;
+		else if (parent->rb_left == node)
 			parent->rb_left = NULL;
 		else
 			parent->rb_right = NULL;
-- 
1.6.2.3

