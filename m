Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215Ab0ANDDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab0ANDDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 22:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700Ab0ANDDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 22:03:47 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60624 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab0ANDDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 22:03:46 -0500
Message-ID: <4B4E8993.5080404@cn.fujitsu.com>
Date: Thu, 14 Jan 2010 11:03:47 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf probe: Fix build failure
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

builtin-probe.c:121: error: 'opt_show_lines' defined but not used

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 tools/perf/builtin-probe.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 1d3a99e..9be8063 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -118,6 +118,7 @@ static int opt_del_probe_event(const struct option *opt __used,
 	return 0;
 }
 
+#ifndef NO_LIBDWARF
 static int opt_show_lines(const struct option *opt __used,
 			  const char *str, int unset __used)
 {
@@ -127,6 +128,8 @@ static int opt_show_lines(const struct option *opt __used,
 	session.show_lines = true;
 	return 0;
 }
+#endif
+
 /* Currently just checking function name from symbol map */
 static void evaluate_probe_point(struct probe_point *pp)
 {
-- 
1.6.3
