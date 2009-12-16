Return-Path: <linux-kernel-owner+w=401wt.eu-S1762417AbZLPRIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762417AbZLPRIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762330AbZLPRGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:06:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36123 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762280AbZLPRGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:06:17 -0500
Message-Id: <20091216170517.653578430@chello.nl>
References: <20091216170430.073353839@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 16 Dec 2009 18:04:34 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 04/12] sched: select_task_rq_fair() must honour SD_LOAD_BALANCE
Content-Disposition: inline; filename=foo7.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should skip !SD_LOAD_BALANCE domains.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: stable@kernel.org
---
 kernel/sched_fair.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1429,6 +1429,9 @@ static int select_task_rq_fair(struct ta
 	}
 
 	for_each_domain(cpu, tmp) {
+		if (!(tmp->flags & SD_LOAD_BALANCE))
+			continue;
+
 		/*
 		 * If power savings logic is enabled for a domain, see if we
 		 * are not overloaded, if so, don't balance wider.

-- 

