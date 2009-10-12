Return-Path: <linux-kernel-owner+w=401wt.eu-S932284AbZJLUob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbZJLUob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 16:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758151AbZJLUoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 16:44:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:48188 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758142AbZJLUo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 16:44:29 -0400
Date: Mon, 12 Oct 2009 20:43:24 GMT
From: tip-bot for Ashwin Chaugule <ashwinc@quicinc.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       arjan@linux.intel.com, tglx@linutronix.de, ashwinc@quicinc.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, tglx@linutronix.de, ashwinc@quicinc.com,
       mingo@elte.hu
In-Reply-To: <a751bdc6978478de6d10440e587a2cc7.squirrel@www.codeaurora.org>
References: <a751bdc6978478de6d10440e587a2cc7.squirrel@www.codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Remove static debugfs path from parse-events
Message-ID: <tip-63c9e01e1a0dcecc982137d527d44b5ac808b607@git.kernel.org>
Git-Commit-ID: 63c9e01e1a0dcecc982137d527d44b5ac808b607
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 12 Oct 2009 20:43:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63c9e01e1a0dcecc982137d527d44b5ac808b607
Gitweb:     http://git.kernel.org/tip/63c9e01e1a0dcecc982137d527d44b5ac808b607
Author:     Ashwin Chaugule <ashwinc@quicinc.com>
AuthorDate: Sun, 4 Oct 2009 15:49:34 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Oct 2009 22:41:05 +0200

perf tools: Remove static debugfs path from parse-events

Timechart doesn't work if debugfs is not in /sys/kernel/debug/.
Fixed by using global debugfs_path which is filled in by perf.

Signed-off-by: Ashwin Chaugule <ashwinc@quicinc.com>
Cc: "Arjan van de Ven" <arjan@linux.intel.com>
LKML-Reference: <a751bdc6978478de6d10440e587a2cc7.squirrel@www.codeaurora.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/parse-events.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 87c424d..8cfb48c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -691,7 +691,10 @@ static void store_event_type(const char *orgname)
 	FILE *file;
 	int id;
 
-	sprintf(filename, "/sys/kernel/debug/tracing/events/%s/id", orgname);
+	sprintf(filename, "%s/", debugfs_path);
+	strncat(filename, orgname, strlen(orgname));
+	strcat(filename, "/id");
+
 	c = strchr(filename, ':');
 	if (c)
 		*c = '/';
