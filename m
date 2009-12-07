Return-Path: <linux-kernel-owner+w=401wt.eu-S1752009AbZLGFcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbZLGFcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 00:32:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbZLGFcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 00:32:05 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:51478 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbZLGFcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 00:32:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Vra/LhHGuyrLpiS5ZOJEBDFAGlpUVrWql2h9rZotd4VCwE9K9/2LAFEc9ncWc4WlLp
         rACiRXKqQeQaIKa+0yx1czqBiUmpjQVDdOkzSWNa1hTXq/xfggOcZirujL7L/vkuhl/Y
         kqyek5WpyBRZTbioGwf0b16Ttxui/glSvyOTA=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       acme@ghostprotocols.net
Subject: [PATCH 1/2] perf trace/scripting: Fix compile err when libperl not installed
Date: Sun,  6 Dec 2009 23:31:58 -0600
Message-Id: <1260163919-6679-2-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1260163919-6679-1-git-send-email-tzanussi@gmail.com>
References: <1260163919-6679-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I added the xs callbacks into perf, I forgot to re-check the
no-libperl case.  This patch fixes the undefined reference error for
that.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/util/trace-event-perl.c |    3 ---
 tools/perf/util/trace-event-perl.h |    4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/trace-event-perl.c b/tools/perf/util/trace-event-perl.c
index 51e833f..59564b2 100644
--- a/tools/perf/util/trace-event-perl.c
+++ b/tools/perf/util/trace-event-perl.c
@@ -32,9 +32,6 @@
 
 void xs_init(pTHX);
 
-void boot_Perf__Trace__Context(pTHX_ CV *cv);
-void boot_DynaLoader(pTHX_ CV *cv);
-
 void xs_init(pTHX)
 {
 	const char *file = __FILE__;
diff --git a/tools/perf/util/trace-event-perl.h b/tools/perf/util/trace-event-perl.h
index 8fe0d86..e88fb26 100644
--- a/tools/perf/util/trace-event-perl.h
+++ b/tools/perf/util/trace-event-perl.h
@@ -34,9 +34,13 @@ typedef int INTERP;
 #define dXSUB_SYS
 #define pTHX_
 static inline void newXS(const char *a, void *b, const char *c) {}
+static void boot_Perf__Trace__Context(pTHX_ CV *cv) {}
+static void boot_DynaLoader(pTHX_ CV *cv) {}
 #else
 #include <EXTERN.h>
 #include <perl.h>
+void boot_Perf__Trace__Context(pTHX_ CV *cv);
+void boot_DynaLoader(pTHX_ CV *cv);
 typedef PerlInterpreter * INTERP;
 #endif
 
-- 
1.6.4.GIT

