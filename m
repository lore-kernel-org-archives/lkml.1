Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZJEU0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZJEU0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 16:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbZJEU0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 16:26:42 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:43889 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbZJEU0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 16:26:42 -0400
Date: Mon, 5 Oct 2009 13:17:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch] perf build questions
Message-Id: <20091005131729.78444bfb.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4ACA5639.0039:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

How do I build 'perf' for an i386 target when running on x86_64?
and how do I do 'perf' cross-builds in general?


Also, I see build errors/warnings (-Werror).  Others aren't seeing these?
Just due to my gcc version?

Patch below.

Thanks.
---

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix perf build warnings/errors in function argument types:

builtin-sched.c:1894: warning: passing argument 1 of 'sort_dimension__add' discards qualifiers from pointer target type
util/trace-event-parse.c:685: warning: passing argument 2 of 'read_expected' discards qualifiers from pointer target type
util/trace-event-parse.c:741: warning: passing argument 4 of 'test_type_token' discards qualifiers from pointer target type
util/trace-event-parse.c:706: warning: passing argument 2 of 'read_expected_item' discards qualifiers from pointer target type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 tools/perf/builtin-sched.c          |    2 +-
 tools/perf/util/trace-event-parse.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1287,7 +1287,7 @@ static struct sort_dimension *available_
 
 static LIST_HEAD(sort_list);
 
-static int sort_dimension__add(char *tok, struct list_head *list)
+static int sort_dimension__add(const char *tok, struct list_head *list)
 {
 	int i;
 
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -618,7 +618,7 @@ static int test_type(enum event_type typ
 }
 
 static int test_type_token(enum event_type type, char *token,
-		    enum event_type expect, char *expect_tok)
+		    enum event_type expect, const char *expect_tok)
 {
 	if (type != expect) {
 		die("Error: expected type %d but read %d",
@@ -650,7 +650,7 @@ static int read_expect_type(enum event_t
 	return __read_expect_type(expect, tok, 1);
 }
 
-static int __read_expected(enum event_type expect, char *str, int newline_ok)
+static int __read_expected(enum event_type expect, const char *str, int newline_ok)
 {
 	enum event_type type;
 	char *token;
@@ -668,12 +668,12 @@ static int __read_expected(enum event_ty
 	return 0;
 }
 
-static int read_expected(enum event_type expect, char *str)
+static int read_expected(enum event_type expect, const char *str)
 {
 	return __read_expected(expect, str, 1);
 }
 
-static int read_expected_item(enum event_type expect, char *str)
+static int read_expected_item(enum event_type expect, const char *str)
 {
 	return __read_expected(expect, str, 0);
 }
