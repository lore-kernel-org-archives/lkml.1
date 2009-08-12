Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbZHLRpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbZHLRpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 13:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbZHLRpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 13:45:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42773 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912AbZHLRpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 13:45:13 -0400
Date: Wed, 12 Aug 2009 14:44:59 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 1/1] perf list: use the pager
Message-ID: <20090812174459.GB3495@ghostprotocols.net>
References: <20090811192211.GG18061@ghostprotocols.net> <20090811200436.GA3478@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811200436.GA3478@ghostprotocols.net>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When /sys/kernel/debug is mounted the list is imense, so use the pager
like the other tools.

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

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
