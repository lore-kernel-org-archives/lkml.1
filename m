Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbZLOJke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbZLOJke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 04:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbZLOJk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 04:40:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:59177 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755921AbZLOJkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 04:40:24 -0500
Date: Tue, 15 Dec 2009 09:40:01 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1260867220-15699-4-git-send-email-tzanussi@gmail.com>
References: <1260867220-15699-4-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace/scripting: Check return val of perl_run()
Message-ID: <tip-8f11d85a0e7e9025acea7493e6864089c8b52f42@git.kernel.org>
Git-Commit-ID: 8f11d85a0e7e9025acea7493e6864089c8b52f42
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f11d85a0e7e9025acea7493e6864089c8b52f42
Gitweb:     http://git.kernel.org/tip/8f11d85a0e7e9025acea7493e6864089c8b52f42
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Tue, 15 Dec 2009 02:53:37 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Dec 2009 10:31:32 +0100

perf trace/scripting: Check return val of perl_run()

The return value from perl_run() is currently ignored, but it
should be checked and used to exit perf if there are problems
loading the script.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
LKML-Reference: <1260867220-15699-4-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/trace-event-perl.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/trace-event-perl.c b/tools/perf/util/trace-event-perl.c
index 6f10e76..6d6d76b 100644
--- a/tools/perf/util/trace-event-perl.c
+++ b/tools/perf/util/trace-event-perl.c
@@ -379,7 +379,11 @@ static int perl_start_script(const char *script, int argc, const char **argv)
 		goto error;
 	}
 
-	perl_run(my_perl);
+	if (perl_run(my_perl)) {
+		err = -1;
+		goto error;
+	}
+
 	if (SvTRUE(ERRSV)) {
 		err = -1;
 		goto error;
