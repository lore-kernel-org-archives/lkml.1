Return-Path: <linux-kernel-owner+w=401wt.eu-S1761486AbXIZQjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761486AbXIZQjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 12:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbXIZQiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 12:38:13 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:60420 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758731AbXIZQiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 12:38:11 -0400
X-IronPort-AV: E=Sophos;i="4.20,302,1186351200"; 
   d="scan'208";a="1526364"
From: Guillaume Chazarain <guichaz@yahoo.fr>
Subject: [PATCH 1/8] taskstats: fix indentation of long argument lists
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Guillaume Chazarain <guichaz@yahoo.fr>
Date: Wed, 26 Sep 2007 18:28:00 +0200
Message-ID: <20070926162800.29434.67786.stgit@cheypa.inria.fr>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Align with the opening parenthesis.

Changelog since V1 (http://lkml.org/lkml/2007/9/21/527):
- renamed fill_threadgroup() and add_tsk() to respectively
fill_threadgroup_stats() and add_tsk_stats() as suggested by Balbir Singh.
- added braces around do/while.
- added patch to unbreak binary compatibility between taskstats v5/v6.
- split further by preparing the bacct/xacct before the main patch.
- some indentation fixes.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Jonathan Lim <jlim@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
---

 kernel/taskstats.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 059431e..a42b6c0 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -69,7 +69,7 @@ enum actions {
 };
 
 static int prepare_reply(struct genl_info *info, u8 cmd, struct sk_buff **skbp,
-				size_t size)
+			 size_t size)
 {
 	struct sk_buff *skb;
 	void *reply;
@@ -119,7 +119,7 @@ static int send_reply(struct sk_buff *skb, pid_t pid)
  * Send taskstats data in @skb to listeners registered for @cpu's exit data
  */
 static void send_cpu_listeners(struct sk_buff *skb,
-					struct listener_list *listeners)
+			       struct listener_list *listeners)
 {
 	struct genlmsghdr *genlhdr = nlmsg_data(nlmsg_hdr(skb));
 	struct listener *s, *tmp;
@@ -168,8 +168,7 @@ static void send_cpu_listeners(struct sk_buff *skb,
 	up_write(&listeners->sem);
 }
 
-static int fill_pid(pid_t pid, struct task_struct *tsk,
-		struct taskstats *stats)
+static int fill_pid(pid_t pid, struct task_struct *tsk, struct taskstats *stats)
 {
 	int rc = 0;
 
@@ -210,7 +209,7 @@ static int fill_pid(pid_t pid, struct task_struct *tsk,
 }
 
 static int fill_tgid(pid_t tgid, struct task_struct *first,
-		struct taskstats *stats)
+		     struct taskstats *stats)
 {
 	struct task_struct *tsk;
 	unsigned long flags;
