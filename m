Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbXLDVO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbXLDVO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbXLDVIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:08:09 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53506
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754928AbXLDVIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:08:07 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 20/23] Subject: SCHED - balance RT tasks no new wake up
To: mingo@elte.hu
Cc: rostedt@goodmis.org, ghaskins@novell.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2007 15:46:07 -0500
Message-ID: <20071204204606.3567.49460.stgit@novell1.haskins.net>
In-Reply-To: <20071204204236.3567.65491.stgit@novell1.haskins.net>
References: <20071204204236.3567.65491.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Run the RT balancing code on wake up to an RT task.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ed031bd..ba9eadb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1656,6 +1656,7 @@ void fastcall wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 		inc_nr_running(p, rq);
 	}
 	check_preempt_curr(rq, p);
+	wakeup_balance_rt(rq, p);
 	task_rq_unlock(rq, &flags);
 }
 

