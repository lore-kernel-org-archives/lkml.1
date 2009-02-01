Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbZBATsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbZBATsn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 14:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZBATsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 14:48:35 -0500
Received: from relay4.ptmail.sapo.pt ([212.55.154.24]:34160 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751571AbZBATse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 14:48:34 -0500
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Sun, 1 Feb 2009 19:47:19 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -rt] Trivial changes to mm/page_alloc.c in -rt git tree
Message-ID: <20090201194719.GA5383@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some trivial changes in function drain_zone_pages, in -rt tree.

Invocations to functions get_cpu_lock_cpu_irqsave/restore in function
drain_zone_pages missing the ';' character.

---
 mm/page_alloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 238e192..3b18a12 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -889,14 +889,14 @@ void drain_zone_pages(int cpu, struct zone *zone, struct per_cpu_pages *pcp)
 	unsigned long flags;
 	int to_drain;
 
-	get_cpu_lock_cpu_irqsave(zone, cpu, flags)
+	get_cpu_lock_cpu_irqsave(zone, cpu, flags);
 	if (pcp->count >= pcp->batch)
 		to_drain = pcp->batch;
 	else
 		to_drain = pcp->count;
 	free_pages_bulk(zone, to_drain, &pcp->list, 0);
 	pcp->count -= to_drain;
-	put_cpu_lock_irqrestore(zone, cpu, flags)
+	put_cpu_lock_irqrestore(zone, cpu, flags);
 }
 #endif
 
-- 
1.5.6.5

