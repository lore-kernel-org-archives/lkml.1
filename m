Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594Ab0A0NRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab0A0NRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 08:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333Ab0A0NRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 08:17:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:60549 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290Ab0A0NRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 08:17:34 -0500
Date: Wed, 27 Jan 2010 13:16:59 GMT
From: tip-bot for Yong Wang <yong.y.wang@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       yong.y.wang@intel.com, fweisbec@gmail.com, yong.y.wang@linux.intel.com,
       austin.zhang@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       yong.y.wang@intel.com, fweisbec@gmail.com, yong.y.wang@linux.intel.com,
       austin.zhang@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100122014750.GA4111@ywang-moblin2.bj.intel.com>
References: <20100122014750.GA4111@ywang-moblin2.bj.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf report: Fix segmentation fault when running with '-g none'
Message-ID: <tip-b7ae11b34bf042cfb4dbaa3b63b2d5d6d33d4cc4@git.kernel.org>
Git-Commit-ID: b7ae11b34bf042cfb4dbaa3b63b2d5d6d33d4cc4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Jan 2010 13:16:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7ae11b34bf042cfb4dbaa3b63b2d5d6d33d4cc4
Gitweb:     http://git.kernel.org/tip/b7ae11b34bf042cfb4dbaa3b63b2d5d6d33d4cc4
Author:     Yong Wang <yong.y.wang@linux.intel.com>
AuthorDate: Fri, 22 Jan 2010 09:47:50 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 Jan 2010 11:01:43 +0100

perf report: Fix segmentation fault when running with '-g none'

Segmentation fault occurs when running perf report with '-g
none'.

Reported-by: Austin Zhang <austin.zhang@intel.com>
Signed-off-by: Yong Wang <yong.y.wang@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100122014750.GA4111@ywang-moblin2.bj.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-report.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index db10c0e..860f1ee 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -269,7 +269,7 @@ parse_callchain_opt(const struct option *opt __used, const char *arg,
 
 	else if (!strncmp(tok, "none", strlen(arg))) {
 		callchain_param.mode = CHAIN_NONE;
-		symbol_conf.use_callchain = true;
+		symbol_conf.use_callchain = false;
 
 		return 0;
 	}
