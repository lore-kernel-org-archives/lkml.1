Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbZGAJHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbZGAJHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbZGAJHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:07:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:57629 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbZGAJHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:07:37 -0400
Date: Wed, 1 Jul 2009 08:46:17 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, anton@samba.org,
       paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, anton@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1246419315-9968-2-git-send-email-fweisbec@gmail.com>
References: <1246419315-9968-2-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/urgent] perf_counter tools: Fix storage size allocation of callchain list
Message-ID: <tip-9198aa77b69647d1d91207f8075763abe7dc0bf4@git.kernel.org>
Git-Commit-ID: 9198aa77b69647d1d91207f8075763abe7dc0bf4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Jul 2009 08:46:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9198aa77b69647d1d91207f8075763abe7dc0bf4
Gitweb:     http://git.kernel.org/tip/9198aa77b69647d1d91207f8075763abe7dc0bf4
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 1 Jul 2009 05:35:13 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 09:58:23 +0200

perf_counter tools: Fix storage size allocation of callchain list

Fix a confusion while giving the size of a callchain list
during its allocation. We are using the wrong structure size.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1246419315-9968-2-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/callchain.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index ad3c285..bbf7813 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -74,7 +74,7 @@ fill_node(struct callchain_node *node, struct ip_callchain *chain, int start)
 	for (i = start; i < chain->nr; i++) {
 		struct callchain_list *call;
 
-		call = malloc(sizeof(*chain));
+		call = malloc(sizeof(*call));
 		if (!call) {
 			perror("not enough memory for the code path tree");
 			return;
