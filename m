Return-Path: <linux-kernel-owner+w=401wt.eu-S935510AbZLGRin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935510AbZLGRin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935496AbZLGRij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:38:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:41682 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964861AbZLGRig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:38:36 -0500
Date: Mon, 7 Dec 2009 17:36:50 GMT
From: tip-bot for Juha Leppanen <juha_motorsportcom@luukku.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       juha_motorsportcom@luukku.com, dle-develop@lists.sourceforge.net,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       juha_motorsportcom@luukku.com, dle-develop@lists.sourceforge.net,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu, systemtap@sources.redhat.com
In-Reply-To: <20091207170040.19230.37464.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091207170040.19230.37464.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Fix strtailcmp() to compare s1and s2[0]
Message-ID: <tip-d56728b8d7fb3e1e5e5f97b88fdf6b43a35b4f5e@git.kernel.org>
Git-Commit-ID: d56728b8d7fb3e1e5e5f97b88fdf6b43a35b4f5e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d56728b8d7fb3e1e5e5f97b88fdf6b43a35b4f5e
Gitweb:     http://git.kernel.org/tip/d56728b8d7fb3e1e5e5f97b88fdf6b43a35b4f5e
Author:     Juha Leppanen <juha_motorsportcom@luukku.com>
AuthorDate: Mon, 7 Dec 2009 12:00:40 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 7 Dec 2009 18:33:20 +0100

perf probe: Fix strtailcmp() to compare s1and s2[0]

Fix strtailcmp() to compare s1[0] and s2[0]. strtailcmp() returns 0
if "a" and "b" or "a" and "ab", it's a wrong behavior. This patch
fixes it.

Signed-off-by: "Juha Leppanen" <juha_motorsportcom@luukku.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Juha Leppanen <juha_motorsportcom@luukku.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091207170040.19230.37464.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-finder.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 293cdfc..4585f1d 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -106,7 +106,7 @@ static int strtailcmp(const char *s1, const char *s2)
 {
 	int i1 = strlen(s1);
 	int i2 = strlen(s2);
-	while (--i1 > 0 && --i2 > 0) {
+	while (--i1 >= 0 && --i2 >= 0) {
 		if (s1[i1] != s2[i2])
 			return s1[i1] - s2[i2];
 	}
