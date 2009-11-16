Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbZKPXGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbZKPXGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbZKPXGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:06:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602AbZKPXGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:06:42 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -next 3/3] x86: insn decoder test shows build warning
To: linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Randy Dunlap <rdunlap@xenotime.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Date: Mon, 16 Nov 2009 18:06:31 -0500
Message-ID: <20091116230631.5250.41579.stgit@harusame>
In-Reply-To: <20091116230611.5250.86656.stgit@harusame>
References: <20091116230611.5250.86656.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since some instructions are not decoded correctly by objdump, it
may cause false positive error in insn decoder posttest. This
changes build error of insn decoder test to build warning.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
