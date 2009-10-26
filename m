Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbZJZT3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbZJZT3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbZJZT3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:29:38 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:64266 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269AbZJZT3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:29:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=dclX+6PzFc0QE3BtyjwpEYq5hiTAA5lDVjWesiQXepMjmW/mChbslric4KGu0g3DmR
         B9Bo1WRyHkBAunwpAjdOREVddhNA7MRiE1hLZKTUPxhvNPRg9aKK4pxzWvhrL1ykaBVS
         NiNFJrpfIqM2lev2Lb8LiJZ8g5IxL0/w0GPl0=
Date: Mon, 26 Oct 2009 22:24:14 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] sched: Use root_task_group_empty only with
	FAIR_GROUP_SCHED
Message-ID: <20091026192414.GB5321@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please review. Perhaps there some usage planned in future?

	-- Cyrill
---
root_task_group_empty is used only with
FAIR_GROUP_SCHED so if we use other scheduler
we get

kernel/sched.c:314: warning: ‘root_task_group_empty’ defined but not used

So move CONFIG_FAIR_GROUP_SCHED up that it cover
root_task_group_empty.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 kernel/sched.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.git/kernel/sched.c
=====================================================================
--- linux-2.6.git.orig/kernel/sched.c
+++ linux-2.6.git/kernel/sched.c
@@ -309,6 +309,8 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(str
  */
 static DEFINE_SPINLOCK(task_group_lock);
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+
 #ifdef CONFIG_SMP
 static int root_task_group_empty(void)
 {
@@ -316,7 +318,6 @@ static int root_task_group_empty(void)
 }
 #endif
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_USER_SCHED
 # define INIT_TASK_GROUP_LOAD	(2*NICE_0_LOAD)
 #else /* !CONFIG_USER_SCHED */
