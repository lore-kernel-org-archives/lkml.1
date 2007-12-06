Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbXLFQKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbXLFQKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 11:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbXLFQKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 11:10:08 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:6391 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbXLFQKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 11:10:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=n7v57jKDDUd1ej5tRFrr7nF31m8VVLP5ZrskbdY0LstHKl9aktd71GacKoj9qMS+DGhkUneUCpyLlkgeFgbzkqZH6Uk4mrjZDHu3eZTdxj4cnyKGq9zDd1QeBmzIz8tClpRWfhjjolO7iPmBGvCG1KnrOq+9EyfUmO9wrvD5gYc=
From: Denis Cheng <crquan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 17/20] net/xfrm/xfrm_state.c: use LIST_HEAD instead of LIST_HEAD_INIT
Date: Fri,  7 Dec 2007 00:09:43 +0800
Message-Id: <1196957383-5751-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

single list_head variable initialized with LIST_HEAD_INIT could almost
always can be replaced with LIST_HEAD declaration, this shrinks the code
and looks better.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 net/xfrm/xfrm_state.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index cf43c49..452d972 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1657,7 +1657,7 @@ void xfrm_replay_advance(struct xfrm_state *x, __be32 net_seq)
 }
 EXPORT_SYMBOL(xfrm_replay_advance);
 
-static struct list_head xfrm_km_list = LIST_HEAD_INIT(xfrm_km_list);
+static LIST_HEAD(xfrm_km_list);
 static DEFINE_RWLOCK(xfrm_km_lock);
 
 void km_policy_notify(struct xfrm_policy *xp, int dir, struct km_event *c)
-- 
1.5.3.4

