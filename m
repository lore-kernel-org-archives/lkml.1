Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbYL2Nyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbYL2Nyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 08:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbYL2Nv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 08:51:58 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:36133 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbYL2Nvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 08:51:51 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 04/13] kconfig: struct property commented
Date: Mon, 29 Dec 2008 14:53:14 +0100
Message-Id: <1230558803-7168-4-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081229134402.GA7069@uranus.ravnborg.org>
References: <20081229134402.GA7069@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/expr.h |   40 ++++++++++++++++++++++++++++++----------
 1 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 0bdb58e..6408fef 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -111,21 +111,41 @@ struct symbol {
 #define SYMBOL_HASHSIZE		257
 #define SYMBOL_HASHMASK		0xff
 
+/* A property represent the config options that can be associated
+ * with a config "symbol".
+ * Sample:
+ * config FOO
+ *         default y
+ *         prompt "foo prompt"
+ *         select BAR
+ * config BAZ
+ *         int "BAZ Value"
+ *         range 1..255
+ */
 enum prop_type {
-	P_UNKNOWN, P_PROMPT, P_COMMENT, P_MENU, P_DEFAULT, P_CHOICE,
-	P_SELECT, P_RANGE, P_ENV
+	P_UNKNOWN,
+	P_PROMPT,   /* prompt "foo prompt" or "BAZ Value" */
+	P_COMMENT,  /* text associated with a comment */
+	P_MENU,     /* prompt associated with a menuconfig option */
+	P_DEFAULT,  /* default y */
+	P_CHOICE,   /* choice value */
+	P_SELECT,   /* select BAR */
+	P_RANGE,    /* range 7..100 (for a symbol) */
+	P_ENV,      /* value from environment variable */
 };
 
 struct property {
-	struct property *next;
-	struct symbol *sym;
-	enum prop_type type;
-	const char *text;
+	struct property *next;     /* next property - null if last */
+	struct symbol *sym;        /* the symbol for which the property is associated */
+	enum prop_type type;       /* type of property */
+	const char *text;          /* the prompt value - P_PROMPT, P_MENU, P_COMMENT */
 	struct expr_value visible;
-	struct expr *expr;
-	struct menu *menu;
-	struct file *file;
-	int lineno;
+	struct expr *expr;         /* the optional conditional part of the property */
+	struct menu *menu;         /* the menu the property are associated with
+	                            * valid for: P_SELECT, P_RANGE, P_CHOICE,
+	                            * P_PROMPT, P_DEFAULT, P_MENU, P_COMMENT */
+	struct file *file;         /* what file was this property defined */
+	int lineno;                /* what lineno was this property defined */
 };
 
 #define for_all_properties(sym, st, tok) \
-- 
1.6.0.2.GIT

