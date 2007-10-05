Return-Path: <linux-kernel-owner+w=401wt.eu-S1760898AbXJEQ42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760898AbXJEQ42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 12:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757636AbXJEQ4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 12:56:21 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:55209 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbXJEQ4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 12:56:20 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: apw@shadowen.org, rdunlap@xenotime.net, jschopp@austin.ibm.com
Cc: linux-kernel@vger.kernel.org, Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 3/3] CHECKFILES: new small shell script to check multiple source files
Date: Fri,  5 Oct 2007 12:56:08 -0400
Message-Id: <11916033693587-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11916033681196-git-send-email-ezk@cs.sunysb.edu>
References: <11916033681196-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Examples:
	./scripts/checkfiles fs/foo/bar.c
	./scripts/checkfiles fs/foo/*.c
	./scripts/checkfiles fs/foo	# check all sources under fs/foo
	./scripts/checkfiles .		# check entire kernel

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 scripts/checkfiles |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)
 create mode 100644 scripts/checkfiles

diff --git a/scripts/checkfiles b/scripts/checkfiles
new file mode 100644
index 0000000..bd5d3f0
--- /dev/null
+++ b/scripts/checkfiles
@@ -0,0 +1,34 @@
+#!/bin/sh
+# (c) 2007, Erez Zadok <ezk@cs.sunysb.edu> (initial version)
+# Licensed under the terms of the GNU GPL License version 2
+#
+# Check source files for compliance with coding standards, using terse
+# output in the style that g/cc produces.  This output can be easily parsed
+# within text editors (e.g., emacs/vim) which can produce a split text
+# screen showing in one screen the error message, and in another screen the
+# corresponding source file, with the cursor placed on the offending line.
+# See for example the documentation for Emacs's "next-error" command, often
+# bound to M-x ` (ESC x back-tick).
+
+# Usage: checkfiles file [files...]
+#        if "file" is a directory, will check all *.[hc] files recursively
+
+# check usage
+usage() {
+	echo "Usage: checkfiles file [files...]"
+	echo "(if \"file\" is a directory, check recursively for all C sources/headers)"
+	exit 1
+}
+if test -z "$1" ; then
+	usage
+fi
+if ! test -f scripts/checkpatch.pl ; then
+	echo "checkfiles: must run from top level source tree"
+	exit 1
+fi
+
+# check coding-style compliance of each source file found, using terse output
+find "$@" -type f -name '*.[hc]' | \
+while read f ; do
+	diff -u /dev/null $f | perl scripts/checkpatch.pl -t -
+done
-- 
1.5.2.2

