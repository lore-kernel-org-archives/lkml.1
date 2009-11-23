Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbZKWKmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbZKWKmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 05:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756993AbZKWKmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 05:42:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:53252 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956AbZKWKk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 05:40:56 -0500
Message-Id: <20091123103819.689055515@chello.nl>
References: <20091123103722.140831906@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 23 Nov 2009 11:37:25 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/8] perf: disable events when we detach them
Content-Disposition: inline; filename=perf-foo-4.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we leave the event in STATE_INACTIVE, any read of the event after
the detach will increase the running count but not the enabled count
and cause funny scaling artefacts.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -294,6 +294,8 @@ list_del_event(struct perf_event *event,
 	if (event->group_leader != event)
 		event->group_leader->nr_siblings--;
 
+	event->state = PERF_EVENT_STATE_OFF;
+
 	/*
 	 * If this was a group event with sibling events then
 	 * upgrade the siblings to singleton events by adding them

-- 

