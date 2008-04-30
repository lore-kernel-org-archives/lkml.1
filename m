Return-Path: <linux-kernel-owner+w=401wt.eu-S933948AbYD3X6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948AbYD3X6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761278AbYD3X6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:58:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:44503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760877AbYD3X6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:58:08 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/11] klist: implement KLIST_INIT() and DEFINE_KLIST()
Date: Wed, 30 Apr 2008 16:57:41 -0700
Message-Id: <1209599870-22919-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080430235701.GA20981@suse.de>
References: <20080430235701.GA20981@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

klist is missing static initializers and definition helper.  Add them.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/klist.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/klist.h b/include/linux/klist.h
index 7407125..a119c0d 100644
--- a/include/linux/klist.h
+++ b/include/linux/klist.h
@@ -25,6 +25,14 @@ struct klist {
 	void			(*put)(struct klist_node *);
 };
 
+#define KLIST_INIT(_name, _get, _put)					\
+	{ .k_lock	= __SPIN_LOCK_UNLOCKED(_name.k_lock),		\
+	  .k_list	= LIST_HEAD_INIT(_name.k_list),			\
+	  .get		= _get,						\
+	  .put		= _put, }
+
+#define DEFINE_KLIST(_name, _get, _put)					\
+	struct klist _name = KLIST_INIT(_name, _get, _put)
 
 extern void klist_init(struct klist * k, void (*get)(struct klist_node *),
 		       void (*put)(struct klist_node *));
-- 
1.5.5.1

