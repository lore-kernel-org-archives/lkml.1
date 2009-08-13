Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbZHMH2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbZHMH2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 03:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZHMH2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 03:28:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:37216 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbZHMH2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 03:28:31 -0400
Date: Thu, 13 Aug 2009 07:28:01 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090812174459.GB3495@ghostprotocols.net>
References: <20090812174459.GB3495@ghostprotocols.net>
Subject: [tip:perfcounters/urgent] perf list: Fix large list output by using the pager
Message-ID: <tip-8f7a0dc51674ad0dd06155291b0aed60d655943c@git.kernel.org>
Git-Commit-ID: 8f7a0dc51674ad0dd06155291b0aed60d655943c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 13 Aug 2009 07:28:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f7a0dc51674ad0dd06155291b0aed60d655943c
Gitweb:     http://git.kernel.org/tip/8f7a0dc51674ad0dd06155291b0aed60d655943c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 12 Aug 2009 14:44:59 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 13 Aug 2009 09:05:48 +0200

perf list: Fix large list output by using the pager

When /sys/kernel/debug is mounted the list can be imense, so
use the pager like the other tools.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20090812174459.GB3495@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-list.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index f990fa8..d88c696 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -10,11 +10,12 @@
 
 #include "perf.h"
 
-#include "util/parse-options.h"
 #include "util/parse-events.h"
+#include "util/cache.h"
 
 int cmd_list(int argc __used, const char **argv __used, const char *prefix __used)
 {
+	setup_pager();
 	print_events();
 	return 0;
 }
