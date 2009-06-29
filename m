Return-Path: <linux-kernel-owner+w=401wt.eu-S1758883AbZF2Tzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbZF2Tzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 15:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZF2Tzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 15:55:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:37074 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbZF2Tzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 15:55:38 -0400
Date: Mon, 29 Jun 2009 19:54:52 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       jaswinder@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       jaswinder@kernel.org, efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf stat: Use percentages for scaling output
Message-ID: <tip-210ad39fb7ef0bc0494483f517f42524f16bb2a7@git.kernel.org>
Git-Commit-ID: 210ad39fb7ef0bc0494483f517f42524f16bb2a7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 29 Jun 2009 19:54:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  210ad39fb7ef0bc0494483f517f42524f16bb2a7
Gitweb:     http://git.kernel.org/tip/210ad39fb7ef0bc0494483f517f42524f16bb2a7
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 29 Jun 2009 21:50:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 29 Jun 2009 21:50:54 +0200

perf stat: Use percentages for scaling output

Peter expressed a strong preference for percentage based
display of scaled values - so revert to that from the
recently introduced multiplication-factor unit.

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-stat.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 3e5ea4e..c5a2907 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -307,7 +307,8 @@ static void print_counter(int counter)
 		abs_printout(counter, count, noise);
 
 	if (scaled)
-		fprintf(stderr, "  (%7.2fx scaled)", (double)count[1]/count[2]);
+		fprintf(stderr, "  (scaled from %.2f%%)",
+			(double) count[2] / count[1] * 100);
 
 	fprintf(stderr, "\n");
 }
