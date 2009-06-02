Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbZFBBqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbZFBBqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 21:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbZFBBqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 21:46:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:56240 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756216AbZFBBqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 21:46:09 -0400
Date: Tue, 2 Jun 2009 01:45:34 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Add string.[ch]
Message-ID: <tip-ea5cc87c63b49c133d15ec2911bb2e49e8124516@git.kernel.org>
Git-Commit-ID: ea5cc87c63b49c133d15ec2911bb2e49e8124516
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 01:45:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea5cc87c63b49c133d15ec2911bb2e49e8124516
Gitweb:     http://git.kernel.org/tip/ea5cc87c63b49c133d15ec2911bb2e49e8124516
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 1 Jun 2009 22:31:03 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 03:40:42 +0200

perf_counter tools: Add string.[ch]

Add hex conversion libraries. We are going to replace sscanf()
uses with them.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/util/string.c |   34 ++++++++++++++++++++++++++++++
 Documentation/perf_counter/util/string.h |    8 +++++++
 2 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/Documentation/perf_counter/util/string.c b/Documentation/perf_counter/util/string.c
new file mode 100644
index 0000000..ec33c0c
--- /dev/null
+++ b/Documentation/perf_counter/util/string.c
@@ -0,0 +1,34 @@
+#include "string.h"
+
+static int hex(char ch)
+{
+	if ((ch >= '0') && (ch <= '9'))
+		return ch - '0';
+	if ((ch >= 'a') && (ch <= 'f'))
+		return ch - 'a' + 10;
+	if ((ch >= 'A') && (ch <= 'F'))
+		return ch - 'A' + 10;
+	return -1;
+}
+
+/*
+ * While we find nice hex chars, build a long_val.
+ * Return number of chars processed.
+ */
+int hex2u64(const char *ptr, __u64 *long_val)
+{
+	const char *p = ptr;
+	*long_val = 0;
+
+	while (*p) {
+		const int hex_val = hex(*p);
+
+		if (hex_val < 0)
+			break;
+
+		*long_val = (*long_val << 4) | hex_val;
+		p++;
+	}
+
+	return p - ptr;
+}
diff --git a/Documentation/perf_counter/util/string.h b/Documentation/perf_counter/util/string.h
new file mode 100644
index 0000000..72812c1
--- /dev/null
+++ b/Documentation/perf_counter/util/string.h
@@ -0,0 +1,8 @@
+#ifndef _PERF_STRING_H_
+#define _PERF_STRING_H_
+
+#include <linux/types.h>
+
+int hex2u64(const char *ptr, __u64 *val);
+
+#endif
