Return-Path: <linux-kernel-owner+w=401wt.eu-S1759829AbZJNTsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829AbZJNTsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759445AbZJNTsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:48:13 -0400
Received: from [71.74.56.125] ([71.74.56.125]:56565 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759426AbZJNTqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:46:48 -0400
Message-Id: <20091014194400.635935008@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 14 Oct 2009 15:43:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 13/13] [PATCH 13/13] perf tools: remove all char * typecasts and use const in prototype
References: <20091014194330.980165492@goodmis.org>
Content-Disposition: inline; filename=0013-perf-tools-remove-all-char-typecasts-and-use-const-i.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The (char *) for all the static strings was a fix for the symptom and
not the disease. The real issue was that the function prototypes
needed to be declared "const char *".

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 tools/perf/util/trace-event-parse.c |  131 ++++++++++++++++++-----------------
 1 files changed, 66 insertions(+), 65 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index b8edc9d..22574c4 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -620,8 +620,8 @@ static int test_type(enum event_type type, enum event_type expect)
 	return 0;
 }
 
-static int test_type_token(enum event_type type, char *token,
-		    enum event_type expect, char *expect_tok)
+static int test_type_token(enum event_type type, const char *token,
+		    enum event_type expect, const char *expect_tok)
 {
 	if (type != expect) {
 		warning("Error: expected type %d but read %d",
@@ -653,7 +653,8 @@ static int read_expect_type(enum event_type expect, char **tok)
 	return __read_expect_type(expect, tok, 1);
 }
 
-static int __read_expected(enum event_type expect, char *str, int newline_ok)
+static int __read_expected(enum event_type expect, const char *str,
+			   int newline_ok)
 {
 	enum event_type type;
 	char *token;
@@ -671,12 +672,12 @@ static int __read_expected(enum event_type expect, char *str, int newline_ok)
 	return ret;
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
@@ -685,10 +686,10 @@ static char *event_read_name(void)
 {
 	char *token;
 
-	if (read_expected(EVENT_ITEM, (char *)"name") < 0)
+	if (read_expected(EVENT_ITEM, "name") < 0)
 		return NULL;
 
-	if (read_expected(EVENT_OP, (char *)":") < 0)
+	if (read_expected(EVENT_OP, ":") < 0)
 		return NULL;
 
 	if (read_expect_type(EVENT_ITEM, &token) < 0)
@@ -706,10 +707,10 @@ static int event_read_id(void)
 	char *token;
 	int id;
 
-	if (read_expected_item(EVENT_ITEM, (char *)"ID") < 0)
+	if (read_expected_item(EVENT_ITEM, "ID") < 0)
 		return -1;
 
-	if (read_expected(EVENT_OP, (char *)":") < 0)
+	if (read_expected(EVENT_OP, ":") < 0)
 		return -1;
 
 	if (read_expect_type(EVENT_ITEM, &token) < 0)
@@ -759,7 +760,7 @@ static int event_read_fields(struct event *event, struct format_field **fields)
 
 		count++;
 
-		if (test_type_token(type, token, EVENT_ITEM, (char *)"field"))
+		if (test_type_token(type, token, EVENT_ITEM, "field"))
 			goto fail;
 		free_token(token);
 
@@ -774,7 +775,7 @@ static int event_read_fields(struct event *event, struct format_field **fields)
 			type = read_token(&token);
 		}
 
-		if (test_type_token(type, token, EVENT_OP, (char *)":") < 0)
+		if (test_type_token(type, token, EVENT_OP, ":") < 0)
 			return -1;
 
 		if (read_expect_type(EVENT_ITEM, &token) < 0)
@@ -892,14 +893,14 @@ static int event_read_fields(struct event *event, struct format_field **fields)
 				field->flags |= FIELD_IS_DYNAMIC;
 		}
 
-		if (test_type_token(type, token,  EVENT_OP, (char *)";"))
+		if (test_type_token(type, token,  EVENT_OP, ";"))
 			goto fail;
 		free_token(token);
 
-		if (read_expected(EVENT_ITEM, (char *)"offset") < 0)
+		if (read_expected(EVENT_ITEM, "offset") < 0)
 			goto fail_expect;
 
-		if (read_expected(EVENT_OP, (char *)":") < 0)
+		if (read_expected(EVENT_OP, ":") < 0)
 			goto fail_expect;
 
 		if (read_expect_type(EVENT_ITEM, &token))
@@ -907,13 +908,13 @@ static int event_read_fields(struct event *event, struct format_field **fields)
 		field->offset = strtoul(token, NULL, 0);
 		free_token(token);
 
-		if (read_expected(EVENT_OP, (char *)";") < 0)
+		if (read_expected(EVENT_OP, ";") < 0)
 			goto fail_expect;
 
-		if (read_expected(EVENT_ITEM, (char *)"size") < 0)
+		if (read_expected(EVENT_ITEM, "size") < 0)
 			goto fail_expect;
 
-		if (read_expected(EVENT_OP, (char *)":") < 0)
+		if (read_expected(EVENT_OP, ":") < 0)
 			goto fail_expect;
 
 		if (read_expect_type(EVENT_ITEM, &token))
@@ -921,18 +922,18 @@ static int event_read_fields(struct event *event, struct format_field **fields)
 		field->size = strtoul(token, NULL, 0);
 		free_token(token);
 
-		if (read_expected(EVENT_OP, (char *)";") < 0)
+		if (read_expected(EVENT_OP, ";") < 0)
 			goto fail_expect;
 
 		type = read_token(&token);
 		if (type != EVENT_NEWLINE) {
 			/* newer versions of the kernel have a "signed" type */
-			if (test_type_token(type, token, EVENT_ITEM, (char *)"signed"))
+			if (test_type_token(type, token, EVENT_ITEM, "signed"))
 				goto fail;
 
 			free_token(token);
 
-			if (read_expected(EVENT_OP, (char *)":") < 0)
+			if (read_expected(EVENT_OP, ":") < 0)
 				goto fail_expect;
 
 			if (read_expect_type(EVENT_ITEM, &token))
@@ -941,7 +942,7 @@ static int event_read_fields(struct event *event, struct format_field **fields)
 			/* add signed type */
 
 			free_token(token);
-			if (read_expected(EVENT_OP, (char *)";") < 0)
+			if (read_expected(EVENT_OP, ";") < 0)
 				goto fail_expect;
 
 			if (read_expect_type(EVENT_NEWLINE, &token))
@@ -970,10 +971,10 @@ static int event_read_format(struct event *event)
 	char *token;
 	int ret;
 
-	if (read_expected_item(EVENT_ITEM, (char *)"format") < 0)
+	if (read_expected_item(EVENT_ITEM, "format") < 0)
 		return -1;
 
-	if (read_expected(EVENT_OP, (char *)":") < 0)
+	if (read_expected(EVENT_OP, ":") < 0)
 		return -1;
 
 	if (read_expect_type(EVENT_NEWLINE, &token))
@@ -1033,7 +1034,7 @@ process_cond(struct event *event, struct print_arg *top, char **tok)
 
 	*tok = NULL;
 	type = process_arg(event, left, &token);
-	if (test_type_token(type, token, EVENT_OP, (char *)":"))
+	if (test_type_token(type, token, EVENT_OP, ":"))
 		goto out_free;
 
 	arg->op.op = token;
@@ -1065,7 +1066,7 @@ process_array(struct event *event, struct print_arg *top, char **tok)
 
 	*tok = NULL;
 	type = process_arg(event, arg, &token);
-	if (test_type_token(type, token, EVENT_OP, (char *)"]"))
+	if (test_type_token(type, token, EVENT_OP, "]"))
 		goto out_free;
 
 	top->op.right = arg;
@@ -1287,7 +1288,7 @@ process_entry(struct event *event __unused, struct print_arg *arg,
 	char *field;
 	char *token;
 
-	if (read_expected(EVENT_OP, (char *)"->") < 0)
+	if (read_expected(EVENT_OP, "->") < 0)
 		return EVENT_ERROR;
 
 	if (read_expect_type(EVENT_ITEM, &token) < 0)
@@ -1447,14 +1448,14 @@ process_fields(struct event *event, struct print_flag_sym **list, char **tok)
 	do {
 		free_token(token);
 		type = read_token_item(&token);
-		if (test_type_token(type, token, EVENT_OP, (char *)"{"))
+		if (test_type_token(type, token, EVENT_OP, "{"))
 			break;
 
 		arg = malloc_or_die(sizeof(*arg));
 
 		free_token(token);
 		type = process_arg(event, arg, &token);
-		if (test_type_token(type, token, EVENT_DELIM, (char *)","))
+		if (test_type_token(type, token, EVENT_DELIM, ","))
 			goto out_free;
 
 		field = malloc_or_die(sizeof(*field));
@@ -1465,7 +1466,7 @@ process_fields(struct event *event, struct print_flag_sym **list, char **tok)
 
 		free_token(token);
 		type = process_arg(event, arg, &token);
-		if (test_type_token(type, token, EVENT_OP, (char *)"}"))
+		if (test_type_token(type, token, EVENT_OP, "}"))
 			goto out_free;
 
 		value = arg_eval(arg);
@@ -1500,13 +1501,13 @@ process_flags(struct event *event, struct print_arg *arg, char **tok)
 	memset(arg, 0, sizeof(*arg));
 	arg->type = PRINT_FLAGS;
 
-	if (read_expected_item(EVENT_DELIM, (char *)"(") < 0)
+	if (read_expected_item(EVENT_DELIM, "(") < 0)
 		return EVENT_ERROR;
 
 	field = malloc_or_die(sizeof(*field));
 
 	type = process_arg(event, field, &token);
-	if (test_type_token(type, token, EVENT_DELIM, (char *)","))
+	if (test_type_token(type, token, EVENT_DELIM, ","))
 		goto out_free;
 
 	arg->flags.field = field;
@@ -1517,11 +1518,11 @@ process_flags(struct event *event, struct print_arg *arg, char **tok)
 		type = read_token_item(&token);
 	}
 
-	if (test_type_token(type, token, EVENT_DELIM, (char *)","))
+	if (test_type_token(type, token, EVENT_DELIM, ","))
 		goto out_free;
 
 	type = process_fields(event, &arg->flags.flags, &token);
-	if (test_type_token(type, token, EVENT_DELIM, (char *)")"))
+	if (test_type_token(type, token, EVENT_DELIM, ")"))
 		goto out_free;
 
 	free_token(token);
@@ -1543,19 +1544,19 @@ process_symbols(struct event *event, struct print_arg *arg, char **tok)
 	memset(arg, 0, sizeof(*arg));
 	arg->type = PRINT_SYMBOL;
 
-	if (read_expected_item(EVENT_DELIM, (char *)"(") < 0)
+	if (read_expected_item(EVENT_DELIM, "(") < 0)
 		return EVENT_ERROR;
 
 	field = malloc_or_die(sizeof(*field));
 
 	type = process_arg(event, field, &token);
-	if (test_type_token(type, token, EVENT_DELIM, (char *)","))
+	if (test_type_token(type, token, EVENT_DELIM, ","))
 		goto out_free;
 
 	arg->symbol.field = field;
 
 	type = process_fields(event, &arg->symbol.symbols, &token);
-	if (test_type_token(type, token, EVENT_DELIM, (char *)")"))
+	if (test_type_token(type, token, EVENT_DELIM, ")"))
 		goto out_free;
 
 	free_token(token);
@@ -1585,7 +1586,7 @@ process_paren(struct event *event, struct print_arg *arg, char **tok)
 	if (type == EVENT_ERROR)
 		return EVENT_ERROR;
 
-	if (test_type_token(type, token, EVENT_DELIM, (char *)")")) {
+	if (test_type_token(type, token, EVENT_DELIM, ")")) {
 		free_token(token);
 		return EVENT_ERROR;
 	}
@@ -1626,7 +1627,7 @@ process_str(struct event *event __unused, struct print_arg *arg, char **tok)
 	enum event_type type;
 	char *token;
 
-	if (read_expected(EVENT_DELIM, (char *)"(") < 0)
+	if (read_expected(EVENT_DELIM, "(") < 0)
 		return EVENT_ERROR;
 
 	if (read_expect_type(EVENT_ITEM, &token) < 0)
@@ -1636,7 +1637,7 @@ process_str(struct event *event __unused, struct print_arg *arg, char **tok)
 	arg->string.string = token;
 	arg->string.offset = -1;
 
-	if (read_expected(EVENT_DELIM, (char *)")") < 0)
+	if (read_expected(EVENT_DELIM, ")") < 0)
 		return EVENT_ERROR;
 
 	type = read_token(&token);
@@ -1775,13 +1776,13 @@ static int event_read_print(struct event *event)
 	char *token;
 	int ret;
 
-	if (read_expected_item(EVENT_ITEM, (char *)"print") < 0)
+	if (read_expected_item(EVENT_ITEM, "print") < 0)
 		return -1;
 
-	if (read_expected(EVENT_ITEM, (char *)"fmt") < 0)
+	if (read_expected(EVENT_ITEM, "fmt") < 0)
 		return -1;
 
-	if (read_expected(EVENT_OP, (char *)":") < 0)
+	if (read_expected(EVENT_OP, ":") < 0)
 		return -1;
 
 	if (read_expect_type(EVENT_DQUOTE, &token) < 0)
@@ -1812,7 +1813,7 @@ static int event_read_print(struct event *event)
 		goto concat;
 	}
 			     
-	if (test_type_token(type, token, EVENT_DELIM, (char *)","))
+	if (test_type_token(type, token, EVENT_DELIM, ","))
 		goto fail;
 
 	free_token(token);
@@ -1931,7 +1932,7 @@ static int get_common_info(const char *type, int *offset, int *size)
 }
 
 static int __parse_common(void *data, int *size, int *offset,
-			  char *name)
+			  const char *name)
 {
 	int ret;
 
@@ -1949,7 +1950,7 @@ int trace_parse_common_type(void *data)
 	static int type_size;
 
 	return __parse_common(data, &type_size, &type_offset,
-			      (char *)"common_type");
+			      "common_type");
 }
 
 static int parse_common_pid(void *data)
@@ -1958,7 +1959,7 @@ static int parse_common_pid(void *data)
 	static int pid_size;
 
 	return __parse_common(data, &pid_size, &pid_offset,
-			      (char *)"common_pid");
+			      "common_pid");
 }
 
 static int parse_common_pc(void *data)
@@ -1967,7 +1968,7 @@ static int parse_common_pc(void *data)
 	static int pc_size;
 
 	return __parse_common(data, &pc_size, &pc_offset,
-			      (char *)"common_preempt_count");
+			      "common_preempt_count");
 }
 
 static int parse_common_flags(void *data)
@@ -1976,7 +1977,7 @@ static int parse_common_flags(void *data)
 	static int flags_size;
 
 	return __parse_common(data, &flags_size, &flags_offset,
-			      (char *)"common_flags");
+			      "common_flags");
 }
 
 static int parse_common_lock_depth(void *data)
@@ -1986,7 +1987,7 @@ static int parse_common_lock_depth(void *data)
 	int ret;
 
 	ret = __parse_common(data, &ld_size, &ld_offset,
-			     (char *)"common_lock_depth");
+			     "common_lock_depth");
 	if (ret < 0)
 		return -1;
 
@@ -3049,15 +3050,15 @@ static void print_args(struct print_arg *args)
 	}
 }
 
-static void parse_header_field(char *field,
+static void parse_header_field(const char *field,
 			       int *offset, int *size)
 {
 	char *token;
 	int type;
 
-	if (read_expected(EVENT_ITEM, (char *)"field") < 0)
+	if (read_expected(EVENT_ITEM, "field") < 0)
 		return;
-	if (read_expected(EVENT_OP, (char *)":") < 0)
+	if (read_expected(EVENT_OP, ":") < 0)
 		return;
 
 	/* type */
@@ -3067,27 +3068,27 @@ static void parse_header_field(char *field,
 
 	if (read_expected(EVENT_ITEM, field) < 0)
 		return;
-	if (read_expected(EVENT_OP, (char *)";") < 0)
+	if (read_expected(EVENT_OP, ";") < 0)
 		return;
-	if (read_expected(EVENT_ITEM, (char *)"offset") < 0)
+	if (read_expected(EVENT_ITEM, "offset") < 0)
 		return;
-	if (read_expected(EVENT_OP, (char *)":") < 0)
+	if (read_expected(EVENT_OP, ":") < 0)
 		return;
 	if (read_expect_type(EVENT_ITEM, &token) < 0)
 		goto fail;
 	*offset = atoi(token);
 	free_token(token);
-	if (read_expected(EVENT_OP, (char *)";") < 0)
+	if (read_expected(EVENT_OP, ";") < 0)
 		return;
-	if (read_expected(EVENT_ITEM, (char *)"size") < 0)
+	if (read_expected(EVENT_ITEM, "size") < 0)
 		return;
-	if (read_expected(EVENT_OP, (char *)":") < 0)
+	if (read_expected(EVENT_OP, ":") < 0)
 		return;
 	if (read_expect_type(EVENT_ITEM, &token) < 0)
 		goto fail;
 	*size = atoi(token);
 	free_token(token);
-	if (read_expected(EVENT_OP, (char *)";") < 0)
+	if (read_expected(EVENT_OP, ";") < 0)
 		return;
 	type = read_token(&token);
 	if (type != EVENT_NEWLINE) {
@@ -3095,19 +3096,19 @@ static void parse_header_field(char *field,
 		if (type != EVENT_ITEM)
 			goto fail;
 
-		if (strcmp(token, (char *)"signed") != 0)
+		if (strcmp(token, "signed") != 0)
 			goto fail;
 
 		free_token(token);
 
-		if (read_expected(EVENT_OP, (char *)":") < 0)
+		if (read_expected(EVENT_OP, ":") < 0)
 			return;
 
 		if (read_expect_type(EVENT_ITEM, &token))
 			goto fail;
 
 		free_token(token);
-		if (read_expected(EVENT_OP, (char *)";") < 0)
+		if (read_expected(EVENT_OP, ";") < 0)
 			return;
 
 		if (read_expect_type(EVENT_NEWLINE, &token))
@@ -3121,11 +3122,11 @@ int parse_header_page(char *buf, unsigned long size)
 {
 	init_input_buf(buf, size);
 
-	parse_header_field((char *)"timestamp", &header_page_ts_offset,
+	parse_header_field("timestamp", &header_page_ts_offset,
 			   &header_page_ts_size);
-	parse_header_field((char *)"commit", &header_page_size_offset,
+	parse_header_field("commit", &header_page_size_offset,
 			   &header_page_size_size);
-	parse_header_field((char *)"data", &header_page_data_offset,
+	parse_header_field("data", &header_page_data_offset,
 			   &header_page_data_size);
 
 	return 0;
-- 
1.6.3.3


