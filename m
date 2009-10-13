Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbZJMKg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbZJMKg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756952AbZJMKg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:36:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:44180 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756510AbZJMKg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:36:27 -0400
Date: Tue, 13 Oct 2009 10:35:18 GMT
From: tip-bot for Vincent Legoll <vincent.legoll@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@osdl.org, vincent.legoll@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       vincent.legoll@gmail.com, torvalds@osdl.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4727185d0910130118m5387058dndb02ac9b384af9f0@mail.gmail.com>
References: <4727185d0910130118m5387058dndb02ac9b384af9f0@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Do not manually count string lengths
Message-ID: <tip-cfed95a693e1ea5d08b9c9019bc30e448437ee2f@git.kernel.org>
Git-Commit-ID: cfed95a693e1ea5d08b9c9019bc30e448437ee2f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Oct 2009 10:35:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cfed95a693e1ea5d08b9c9019bc30e448437ee2f
Gitweb:     http://git.kernel.org/tip/cfed95a693e1ea5d08b9c9019bc30e448437ee2f
Author:     Vincent Legoll <vincent.legoll@gmail.com>
AuthorDate: Tue, 13 Oct 2009 10:18:16 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 13 Oct 2009 11:55:31 +0200

perf tools: Do not manually count string lengths

Use strlen & macros instead of manually counting string lengths as
this is error prone and may lend to bugs.

Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>
Cc: Linus Torvalds <torvalds@osdl.org>
LKML-Reference: <4727185d0910130118m5387058dndb02ac9b384af9f0@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/perf.c       |   16 ++++++++--------
 tools/perf/util/cache.h |    5 +++++
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 19fc7fe..624e62d 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -89,8 +89,8 @@ static int handle_options(const char*** argv, int* argc, int* envchanged)
 		/*
 		 * Check remaining flags.
 		 */
-		if (!prefixcmp(cmd, "--exec-path")) {
-			cmd += 11;
+		if (!prefixcmp(cmd, CMD_EXEC_PATH)) {
+			cmd += strlen(CMD_EXEC_PATH);
 			if (*cmd == '=')
 				perf_set_argv_exec_path(cmd + 1);
 			else {
@@ -117,8 +117,8 @@ static int handle_options(const char*** argv, int* argc, int* envchanged)
 			(*argv)++;
 			(*argc)--;
 			handled++;
-		} else if (!prefixcmp(cmd, "--perf-dir=")) {
-			setenv(PERF_DIR_ENVIRONMENT, cmd + 10, 1);
+		} else if (!prefixcmp(cmd, CMD_PERF_DIR)) {
+			setenv(PERF_DIR_ENVIRONMENT, cmd + strlen(CMD_PERF_DIR), 1);
 			if (envchanged)
 				*envchanged = 1;
 		} else if (!strcmp(cmd, "--work-tree")) {
@@ -131,8 +131,8 @@ static int handle_options(const char*** argv, int* argc, int* envchanged)
 				*envchanged = 1;
 			(*argv)++;
 			(*argc)--;
-		} else if (!prefixcmp(cmd, "--work-tree=")) {
-			setenv(PERF_WORK_TREE_ENVIRONMENT, cmd + 12, 1);
+		} else if (!prefixcmp(cmd, CMD_WORK_TREE)) {
+			setenv(PERF_WORK_TREE_ENVIRONMENT, cmd + strlen(CMD_WORK_TREE), 1);
 			if (envchanged)
 				*envchanged = 1;
 		} else if (!strcmp(cmd, "--debugfs-dir")) {
@@ -146,8 +146,8 @@ static int handle_options(const char*** argv, int* argc, int* envchanged)
 				*envchanged = 1;
 			(*argv)++;
 			(*argc)--;
-		} else if (!prefixcmp(cmd, "--debugfs-dir=")) {
-			strncpy(debugfs_mntpt, cmd + 14, MAXPATHLEN);
+		} else if (!prefixcmp(cmd, CMD_DEBUGFS_DIR)) {
+			strncpy(debugfs_mntpt, cmd + strlen(CMD_DEBUGFS_DIR), MAXPATHLEN);
 			debugfs_mntpt[MAXPATHLEN - 1] = '\0';
 			if (envchanged)
 				*envchanged = 1;
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index f26172c..918eb37 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -5,6 +5,11 @@
 #include "strbuf.h"
 #include "../perf.h"
 
+#define CMD_EXEC_PATH "--exec-path"
+#define CMD_PERF_DIR "--perf-dir="
+#define CMD_WORK_TREE "--work-tree="
+#define CMD_DEBUGFS_DIR "--debugfs-dir="
+
 #define PERF_DIR_ENVIRONMENT "PERF_DIR"
 #define PERF_WORK_TREE_ENVIRONMENT "PERF_WORK_TREE"
 #define DEFAULT_PERF_DIR_ENVIRONMENT ".perf"
