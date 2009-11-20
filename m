Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbZKTWwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbZKTWwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 17:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbZKTWvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 17:51:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58656 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbZKTWvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 17:51:32 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/6] perf symbols: Introduce dso__build_id_equal
Date: Fri, 20 Nov 2009 20:51:26 -0200
Message-Id: <1258757489-5978-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258757489-5978-2-git-send-email-acme@infradead.org>
References: <1258757489-5978-1-git-send-email-acme@infradead.org>
 <1258757489-5978-2-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Will be used in more places.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index d220308..c324bdf 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -884,6 +884,11 @@ out_close:
 	return err;
 }
 
+static bool dso__build_id_equal(const struct dso *self, u8 *build_id)
+{
+	return memcmp(self->build_id, build_id, sizeof(self->build_id)) == 0;
+}
+
 bool dsos__read_build_ids(void)
 {
 	bool have_build_id = false;
@@ -1099,8 +1104,7 @@ more:
 						    sizeof(build_id)) < 0)
 				goto more;
 compare_build_id:
-			if (memcmp(build_id, self->build_id,
-				   sizeof(self->build_id)) != 0)
+			if (!dso__build_id_equal(self, build_id))
 				goto more;
 		}
 
-- 
1.6.2.5

