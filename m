Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbZHDLic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbZHDLic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 07:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbZHDLib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 07:38:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:44882 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbZHDLia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 07:38:30 -0400
Date: Tue, 4 Aug 2009 11:37:19 GMT
From: tip-bot for Roel Kluin <roel.kluin@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, roel.kluin@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, roel.kluin@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A757BCF.40101@gmail.com>
References: <4A757BCF.40101@gmail.com>
Subject: [tip:perfcounters/urgent] perf: Fix read buffer overflow
Message-ID: <tip-7e030655dda5b5efc4305e2a8f46c4967d32eb3d@git.kernel.org>
Git-Commit-ID: 7e030655dda5b5efc4305e2a8f46c4967d32eb3d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 11:37:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e030655dda5b5efc4305e2a8f46c4967d32eb3d
Gitweb:     http://git.kernel.org/tip/7e030655dda5b5efc4305e2a8f46c4967d32eb3d
Author:     Roel Kluin <roel.kluin@gmail.com>
AuthorDate: Sun, 2 Aug 2009 13:43:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Aug 2009 11:09:56 +0200

perf: Fix read buffer overflow

Check whether index is within bounds before testing the element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: a.p.zijlstra@chello.nl
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <4A757BCF.40101@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |    2 +-
 tools/perf/util/quote.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 95fd06c..ce4f286 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -253,7 +253,7 @@ static int strcommon(const char *pathname)
 {
 	int n = 0;
 
-	while (pathname[n] == cwd[n] && n < cwdlen)
+	while (n < cwdlen && pathname[n] == cwd[n])
 		++n;
 
 	return n;
diff --git a/tools/perf/util/quote.c b/tools/perf/util/quote.c
index c6e5dc0..2726fe4 100644
--- a/tools/perf/util/quote.c
+++ b/tools/perf/util/quote.c
@@ -318,7 +318,7 @@ char *quote_path_relative(const char *in, int len,
 		strbuf_addch(out, '"');
 	if (prefix) {
 		int off = 0;
-		while (prefix[off] && off < len && prefix[off] == in[off])
+		while (off < len && prefix[off] && prefix[off] == in[off])
 			if (prefix[off] == '/') {
 				prefix += off + 1;
 				in += off + 1;
