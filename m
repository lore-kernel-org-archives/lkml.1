Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149Ab0A0I3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab0A0I3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 03:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995Ab0A0I3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 03:29:52 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:38170 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab0A0I2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 03:28:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qa/xy9kLFmBArrvEdoDoinWtaAuTFMYo62nUHIjY+dFWYKSvFzxCjQ44dPeIASqhFX
         MJjNDzfxAhN2tYzHF1VKs7vrcIVLqGxQG+25fclRtndRYQzCnqsG8vR/h6QXK3h8EnfB
         sBOFruNczmvaZrwO2mYEYa3VJJSKKlGknqZO4=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: [PATCH 05/12] perf trace/scripting: remove check-perf-trace from listed scripts
Date: Wed, 27 Jan 2010 02:27:56 -0600
Message-Id: <1264580883-15324-6-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
References: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check-perf-trace script only checks Perl functionality, and
doesn't really need to be listed as as user script anyway.

This only removes the '-report' shell script, so although it doesn't
appear in the listing, the '-record' shell script and the check perf
trace perl script itself is still available and can still be run
manually as such:

$ libexec/perf-core/scripts/perl/bin/check-perf-trace-record
$ perf trace -s libexec/perf-core/scripts/perl/check-perf-trace.pl

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 .../perf/scripts/perl/bin/check-perf-trace-record  |    7 +------
 .../perf/scripts/perl/bin/check-perf-trace-report  |    6 ------
 2 files changed, 1 insertions(+), 12 deletions(-)
 delete mode 100644 tools/perf/scripts/perl/bin/check-perf-trace-report

diff --git a/tools/perf/scripts/perl/bin/check-perf-trace-record b/tools/perf/scripts/perl/bin/check-perf-trace-record
index c7ec5de..f439cc3 100644
--- a/tools/perf/scripts/perl/bin/check-perf-trace-record
+++ b/tools/perf/scripts/perl/bin/check-perf-trace-record
@@ -1,7 +1,2 @@
 #!/bin/bash
-perf record -c 1 -f -a -M -R -e kmem:kmalloc -e irq:softirq_entry
-
-
-
-
-
+perf record -c 1 -f -a -M -R -e kmem:kmalloc -e irq:softirq_entry -e kmem:kmalloc
diff --git a/tools/perf/scripts/perl/bin/check-perf-trace-report b/tools/perf/scripts/perl/bin/check-perf-trace-report
deleted file mode 100644
index 7fc4a03..0000000
--- a/tools/perf/scripts/perl/bin/check-perf-trace-report
+++ /dev/null
@@ -1,6 +0,0 @@
-#!/bin/bash
-# description: useless but exhaustive test script
-perf trace -s ~/libexec/perf-core/scripts/perl/check-perf-trace.pl
-
-
-
-- 
1.6.4.GIT

