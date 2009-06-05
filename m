Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbZFEG0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbZFEG0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 02:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbZFEG0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 02:26:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:49797 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbZFEG0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 02:26:13 -0400
Date: Fri, 5 Jun 2009 06:24:58 GMT
From: tip-bot for Yong Wang <yong.y.wang@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, yong.y.wang@linux.intel.com, yong.y.wang@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, yong.y.wang@linux.intel.com,
       yong.y.wang@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090605033735.GA20451@ywang-moblin2.bj.intel.com>
References: <20090605033735.GA20451@ywang-moblin2.bj.intel.com>
Subject: [tip:perfcounters/core] perf_counter tools: Fix incorrect printf formats
Message-ID: <tip-ee7b31fe5c5da8a038b96e54ae9fbd5dcab3b1da@git.kernel.org>
Git-Commit-ID: ee7b31fe5c5da8a038b96e54ae9fbd5dcab3b1da
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 05 Jun 2009 06:24:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee7b31fe5c5da8a038b96e54ae9fbd5dcab3b1da
Gitweb:     http://git.kernel.org/tip/ee7b31fe5c5da8a038b96e54ae9fbd5dcab3b1da
Author:     Yong Wang <yong.y.wang@linux.intel.com>
AuthorDate: Fri, 5 Jun 2009 11:37:35 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 5 Jun 2009 08:22:27 +0200

perf_counter tools: Fix incorrect printf formats

Otherwise the code does not compile on 32-bit boxes.

builtin-report.c: In function 'map__fprintf':
builtin-report.c:240: error: format '%lx' expects type 'long unsigned int', but argument 3 has type 'uint64_t'
builtin-report.c:240: error: format '%lx' expects type 'long unsigned int', but argument 4 has type 'uint64_t'
builtin-report.c:240: error: format '%lx' expects type 'long unsigned int', but argument 5 has type 'uint64_t'

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20090605033735.GA20451@ywang-moblin2.bj.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 1a1028d..eb5424f 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -236,7 +236,7 @@ static int map__overlap(struct map *l, struct map *r)
 
 static size_t map__fprintf(struct map *self, FILE *fp)
 {
-	return fprintf(fp, " %lx-%lx %lx %s\n",
+	return fprintf(fp, " %"PRIx64"-%"PRIx64" %"PRIx64" %s\n",
 		       self->start, self->end, self->pgoff, self->dso->name);
 }
 
