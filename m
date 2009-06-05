Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbZFEDyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbZFEDyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 23:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbZFEDyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 23:54:14 -0400
Received: from mga07.intel.com ([143.182.124.22]:51241 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751202AbZFEDyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 23:54:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,308,1241420400"; 
   d="scan'208";a="150932551"
Date: Fri, 5 Jun 2009 11:37:35 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -tip] perf_counter tools: fix incorrect printf formats
Message-ID: <20090605033735.GA20451@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise the code does not compile on 32-bit boxes.

builtin-report.c: In function 'map__fprintf':
builtin-report.c:240: error: format '%lx' expects type 'long unsigned int', but argument 3 has type 'uint64_t'
builtin-report.c:240: error: format '%lx' expects type 'long unsigned int', but argument 4 has type 'uint64_t'
builtin-report.c:240: error: format '%lx' expects type 'long unsigned int', but argument 5 has type 'uint64_t'

Signed-off-by: Yong Wang <yong.y.wang@intel.com>

---
 builtin-report.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
 
