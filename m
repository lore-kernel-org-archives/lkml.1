Return-Path: <linux-kernel-owner+w=401wt.eu-S964807AbZLGQ54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964807AbZLGQ54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935481AbZLGQ5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:57:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935482AbZLGQ5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:57:51 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [BUGFIX PATCH -tip 2/5] perf probe: Fix strtailcmp() to compare s1[0]
	and s2[0]
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       "Juha Leppanen" <juha_motorsportcom@luukku.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Date: Mon, 07 Dec 2009 12:00:40 -0500
Message-ID: <20091207170040.19230.37464.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091207170027.19230.39491.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091207170027.19230.39491.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juha Leppanen <juha_motorsportcom@luukku.com>

Fix strtailcmp() to compare s1[0] and s2[0].
strtailcmp() returns 0 if "a" and "b" or "a" and "ab", it's
a wrong behavior. This patch fixes it.

Signed-off-by: "Juha Leppanen" <juha_motorsportcom@luukku.com>
Reported-by: "Juha Leppanen" <juha_motorsportcom@luukku.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
