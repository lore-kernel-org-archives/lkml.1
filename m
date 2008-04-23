Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbYDWJ7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbYDWJ7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756229AbYDWJxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:53:01 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36963 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756218AbYDWJxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:53:00 -0400
Date: Wed, 23 Apr 2008 12:52:21 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make sched_feat_{names,open} static
Message-ID: <20080423095221.GH28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global code in kernel/sched.c  
static:
- sched_feat_names[]
- sched_feat_open()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 kernel/sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

2a1e54c660bb9c574133bda95468b1ea28239e95 diff --git a/kernel/sched.c b/kernel/sched.c
index 57ba7ea..19df986 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -757,14 +757,14 @@ const_debug unsigned int sysctl_sched_features =
 #define SCHED_FEAT(name, enabled)	\
 	#name ,
 
-__read_mostly char *sched_feat_names[] = {
+static __read_mostly char *sched_feat_names[] = {
 #include "sched_features.h"
 	NULL
 };
 
 #undef SCHED_FEAT
 
-int sched_feat_open(struct inode *inode, struct file *filp)
+static int sched_feat_open(struct inode *inode, struct file *filp)
 {
 	filp->private_data = inode->i_private;
 	return 0;

