Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbZKTFnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbZKTFnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 00:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbZKTFno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 00:43:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:35676 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbZKTFnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 00:43:43 -0500
Date: Fri, 20 Nov 2009 05:39:51 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkenisto@us.ibm.com, rdunlap@xenotime.net,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       sfr@canb.auug.org.au, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkenisto@us.ibm.com, rdunlap@xenotime.net,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       sfr@canb.auug.org.au, mhiramat@redhat.com, systemtap@sources.redhat.com,
       mingo@elte.hu
In-Reply-To: <20091116230631.5250.41579.stgit@harusame>
References: <20091116230631.5250.41579.stgit@harusame>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Instruction decoder test should generate build warning
Message-ID: <tip-ce64c62074d945fe5f8a7f01bdc30125f994ea67@git.kernel.org>
Git-Commit-ID: ce64c62074d945fe5f8a7f01bdc30125f994ea67
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce64c62074d945fe5f8a7f01bdc30125f994ea67
Gitweb:     http://git.kernel.org/tip/ce64c62074d945fe5f8a7f01bdc30125f994ea67
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 16 Nov 2009 18:06:31 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 19 Nov 2009 21:40:13 +0100

x86: Instruction decoder test should generate build warning

Since some instructions are not decoded correctly by older
versions of objdump, it may cause false positive error in insn
decoder posttest.

This changes build error of insn decoder test to build warning.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
LKML-Reference: <20091116230631.5250.41579.stgit@harusame>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/tools/test_get_len.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/tools/test_get_len.c b/arch/x86/tools/test_get_len.c
index af75e07..d8214dc 100644
--- a/arch/x86/tools/test_get_len.c
+++ b/arch/x86/tools/test_get_len.c
@@ -114,6 +114,7 @@ int main(int argc, char **argv)
 	unsigned char insn_buf[16];
 	struct insn insn;
 	int insns = 0, c;
+	int warnings = 0;
 
 	parse_args(argc, argv);
 
@@ -151,18 +152,22 @@ int main(int argc, char **argv)
 		insn_init(&insn, insn_buf, x86_64);
 		insn_get_length(&insn);
 		if (insn.length != nb) {
-			fprintf(stderr, "Error: %s found a difference at %s\n",
+			warnings++;
+			fprintf(stderr, "Warning: %s found difference at %s\n",
 				prog, sym);
-			fprintf(stderr, "Error: %s", line);
-			fprintf(stderr, "Error: objdump says %d bytes, but "
+			fprintf(stderr, "Warning: %s", line);
+			fprintf(stderr, "Warning: objdump says %d bytes, but "
 				"insn_get_length() says %d\n", nb,
 				insn.length);
 			if (verbose)
 				dump_insn(stderr, &insn);
-			exit(2);
 		}
 	}
-	fprintf(stderr, "Succeed: decoded and checked %d instructions\n",
-		insns);
+	if (warnings)
+		fprintf(stderr, "Warning: decoded and checked %d"
+			" instructions with %d warnings\n", insns, warnings);
+	else
+		fprintf(stderr, "Succeed: decoded and checked %d"
+			" instructions\n", insns);
 	return 0;
 }
