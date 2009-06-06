Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbZFFNtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbZFFNtS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 09:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZFFNtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 09:49:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:47047 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbZFFNtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 09:49:05 -0400
Date: Sat, 6 Jun 2009 13:48:32 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Uniform help printouts
Message-ID: <tip-502fc5c72a886ff9d4d7a596e65ecc4dd5e4d458@git.kernel.org>
Git-Commit-ID: 502fc5c72a886ff9d4d7a596e65ecc4dd5e4d458
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 06 Jun 2009 13:48:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  502fc5c72a886ff9d4d7a596e65ecc4dd5e4d458
Gitweb:     http://git.kernel.org/tip/502fc5c72a886ff9d4d7a596e65ecc4dd5e4d458
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 13 Mar 2009 03:20:49 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 6 Jun 2009 14:41:49 +0200

perf_counter tools: Uniform help printouts

Also add perf list to command-list.txt.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-help.c       |   10 +++++-----
 Documentation/perf_counter/command-list.txt     |   14 ++++++++------
 Documentation/perf_counter/perf.c               |    4 ++--
 Documentation/perf_counter/util/parse-options.c |    2 +-
 Documentation/perf_counter/util/usage.c         |    2 +-
 5 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/Documentation/perf_counter/builtin-help.c b/Documentation/perf_counter/builtin-help.c
index a3894bf..0f32dc3 100644
--- a/Documentation/perf_counter/builtin-help.c
+++ b/Documentation/perf_counter/builtin-help.c
@@ -284,7 +284,7 @@ void list_common_cmds_help(void)
 			longest = strlen(common_cmds[i].name);
 	}
 
-	puts("The most commonly used perf commands are:");
+	puts(" The most commonly used perf commands are:");
 	for (i = 0; i < ARRAY_SIZE(common_cmds); i++) {
 		printf("   %s   ", common_cmds[i].name);
 		mput_char(' ', longest - strlen(common_cmds[i].name));
@@ -426,16 +426,16 @@ int cmd_help(int argc, const char **argv, const char *prefix)
 			builtin_help_usage, 0);
 
 	if (show_all) {
-		printf("usage: %s\n\n", perf_usage_string);
+		printf("\n usage: %s\n\n", perf_usage_string);
 		list_commands("perf commands", &main_cmds, &other_cmds);
-		printf("%s\n", perf_more_info_string);
+		printf(" %s\n\n", perf_more_info_string);
 		return 0;
 	}
 
 	if (!argv[0]) {
-		printf("usage: %s\n\n", perf_usage_string);
+		printf("\n usage: %s\n\n", perf_usage_string);
 		list_common_cmds_help();
-		printf("\n%s\n", perf_more_info_string);
+		printf("\n %s\n\n", perf_more_info_string);
 		return 0;
 	}
 
diff --git a/Documentation/perf_counter/command-list.txt b/Documentation/perf_counter/command-list.txt
index 4390292..f0b922c 100644
--- a/Documentation/perf_counter/command-list.txt
+++ b/Documentation/perf_counter/command-list.txt
@@ -1,7 +1,9 @@
+#
 # List of known perf commands.
-# command name				category [deprecated] [common]
-perf-record                             mainporcelain common
-perf-report                             mainporcelain common
-perf-stat                               mainporcelain common
-perf-top                                mainporcelain common
-
+# command name			category [deprecated] [common]
+#
+perf-record			mainporcelain common
+perf-report			mainporcelain common
+perf-stat			mainporcelain common
+perf-top			mainporcelain common
+perf-list			mainporcelain common
diff --git a/Documentation/perf_counter/perf.c b/Documentation/perf_counter/perf.c
index 9ac7565..161824f 100644
--- a/Documentation/perf_counter/perf.c
+++ b/Documentation/perf_counter/perf.c
@@ -384,9 +384,9 @@ int main(int argc, const char **argv)
 			argv[0] += 2;
 	} else {
 		/* The user didn't specify a command; give them help */
-		printf("usage: %s\n\n", perf_usage_string);
+		printf("\n usage: %s\n\n", perf_usage_string);
 		list_common_cmds_help();
-		printf("\n%s\n", perf_more_info_string);
+		printf("\n %s\n\n", perf_more_info_string);
 		exit(1);
 	}
 	cmd = argv[0];
diff --git a/Documentation/perf_counter/util/parse-options.c b/Documentation/perf_counter/util/parse-options.c
index 551b6bc..e4d3533 100644
--- a/Documentation/perf_counter/util/parse-options.c
+++ b/Documentation/perf_counter/util/parse-options.c
@@ -385,7 +385,7 @@ int usage_with_options_internal(const char * const *usagestr,
 	if (!usagestr)
 		return PARSE_OPT_HELP;
 
-	fprintf(stderr, "usage: %s\n", *usagestr++);
+	fprintf(stderr, "\n usage: %s\n", *usagestr++);
 	while (*usagestr && **usagestr)
 		fprintf(stderr, "   or: %s\n", *usagestr++);
 	while (*usagestr) {
diff --git a/Documentation/perf_counter/util/usage.c b/Documentation/perf_counter/util/usage.c
index 7a10421..2cad286 100644
--- a/Documentation/perf_counter/util/usage.c
+++ b/Documentation/perf_counter/util/usage.c
@@ -14,7 +14,7 @@ static void report(const char *prefix, const char *err, va_list params)
 
 static NORETURN void usage_builtin(const char *err)
 {
-	fprintf(stderr, "usage: %s\n", err);
+	fprintf(stderr, "\n usage: %s\n", err);
 	exit(129);
 }
 
