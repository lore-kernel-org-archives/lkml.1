Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbXLFQCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbXLFQCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 11:02:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbXLFQBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 11:01:55 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:53057 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbXLFQBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 11:01:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YlaeFA73vdclJFy+lTZQn9C8GV42kK+2fxYJK9Kb6OTbxYbAs35TsVFUQMwbWJpzFVlrgfhadhMJCulwukYQn/0L00cgCFXNQaZW371PGtlEjN+jDCLibmqzoNhdx8LgEX/GibwLE32i0+CmDpVbVy0f7kVsnF32zRSfYj1stQk=
From: Denis Cheng <crquan@gmail.com>
To: netdev@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 13/20] net/core/dev.c: use LIST_HEAD instead of LIST_HEAD_INIT
Date: Fri,  7 Dec 2007 00:01:26 +0800
Message-Id: <1196956886-5681-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

single list_head variable initialized with LIST_HEAD_INIT could almost
always can be replaced with LIST_HEAD declaration, this shrinks the code
and looks better.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 net/core/dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 86d6261..7626db4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3501,7 +3501,7 @@ static int dev_new_index(struct net *net)
 
 /* Delayed registration/unregisteration */
 static DEFINE_SPINLOCK(net_todo_list_lock);
-static struct list_head net_todo_list = LIST_HEAD_INIT(net_todo_list);
+static LIST_HEAD(net_todo_list);
 
 static void net_set_todo(struct net_device *dev)
 {
-- 
1.5.3.4

