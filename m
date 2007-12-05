Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbXLEWuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbXLEWuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 17:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbXLEWt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 17:49:58 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:45264
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751943AbXLEWt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 17:49:58 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH] sched: update root-domain spans upon departure
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org, ghaskins@novell.com
Date: Wed, 05 Dec 2007 17:27:41 -0500
Message-ID: <20071205222619.4463.63899.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
  This patch should have been rolled into the series I dropped on you
  yesterday, but was an oversight.  Please apply to sched-devel at your
  earliest convenience.

-Greg

-----------------------

sched: update root-domain spans upon departure

We shouldnt leave cpus enabled in the spans if that RQ has left the domain.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 05a9a81..33f8b0c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5845,6 +5845,10 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 
 		if (atomic_dec_and_test(&old_rd->refcount))
 			kfree(old_rd);
+		else {
+			cpu_clear(rq->cpu, old_rd->span);
+			cpu_clear(rq->cpu, old_rd->online);
+		}
 	}
 
 	atomic_inc(&rd->refcount);

