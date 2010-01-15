Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0AOBpp (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191Ab0AOBpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:45:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55576 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab0AOBpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:45:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/4] perf symbols: Use dso->long_name in dsos__find()
Date: Thu, 14 Jan 2010 23:45:27 -0200
Message-Id: <1263519930-22803-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

If not we end up duplicating the module DSOs because first we insert
them using the short name found in /proc/modules, then, when processing
synthesized MMAP events we add them again.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index ae61e9f..4267138 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1679,7 +1679,7 @@ static struct dso *dsos__find(struct list_head *head, const char *name)
 	struct dso *pos;
 
 	list_for_each_entry(pos, head, node)
-		if (strcmp(pos->name, name) == 0)
+		if (strcmp(pos->long_name, name) == 0)
 			return pos;
 	return NULL;
 }
-- 
1.6.2.5

