Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab0CMM1Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 07:27:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:37857 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036Ab0CMM1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 07:27:13 -0500
Date: Sat, 13 Mar 2010 12:26:17 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com, mingo@elte.hu
In-Reply-To: <20100312232224.2017.54550.stgit@localhost6.localdomain6>
References: <20100312232224.2017.54550.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Fix need_dwarf flag if lazy matching is used
Message-ID: <tip-fc6ceea045031658d0b59af562369eae980b4370@git.kernel.org>
Git-Commit-ID: fc6ceea045031658d0b59af562369eae980b4370
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 13 Mar 2010 12:26:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc6ceea045031658d0b59af562369eae980b4370
Gitweb:     http://git.kernel.org/tip/fc6ceea045031658d0b59af562369eae980b4370
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 12 Mar 2010 18:22:24 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 13 Mar 2010 08:32:22 +0100

perf probe: Fix need_dwarf flag if lazy matching is used

Set need_dwarf if lazy matching pattern is specified, because
lazy matching requires real source path for which we must use
debuginfo.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
LKML-Reference: <20100312232224.2017.54550.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 53181db..7c004b6 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -242,7 +242,7 @@ void parse_perf_probe_event(const char *str, struct probe_point *pp,
 
 	/* Parse probe point */
 	parse_perf_probe_probepoint(argv[0], pp);
-	if (pp->file || pp->line)
+	if (pp->file || pp->line || pp->lazy_line)
 		*need_dwarf = true;
 
 	/* Copy arguments and ensure return probe has no C argument */
