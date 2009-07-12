Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbZGLINh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbZGLINh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 04:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbZGLIMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 04:12:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:53916 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbZGLIM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 04:12:29 -0400
From: Cheng Renquan <crq@kernel.org>
To: linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       crquan@gmail.com
Subject: [PATCH 4/6] make use of menu_get_ext_help in gconfig
Date: Sun, 12 Jul 2009 16:11:46 +0800
Message-Id: <1247386308-19628-5-git-send-email-crq@kernel.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247386308-19628-4-git-send-email-crq@kernel.org>
References: <1247386308-19628-1-git-send-email-crq@kernel.org>
 <1247386308-19628-2-git-send-email-crq@kernel.org>
 <1247386308-19628-3-git-send-email-crq@kernel.org>
 <1247386308-19628-4-git-send-email-crq@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 12 Jul 2009 08:11:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cheng Renquan <crquan@gmail.com>

Futhermore, gconfig interface lack the "search a symbol" function, do later.

Signed-off-by: Cheng Renquan <crquan@gmail.com>
---
 scripts/kconfig/gconf.c |   21 ++++-----------------
 1 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index 199b22b..6546436 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -456,19 +456,9 @@ static void text_insert_help(struct menu *menu)
 	GtkTextBuffer *buffer;
 	GtkTextIter start, end;
 	const char *prompt = _(menu_get_prompt(menu));
-	gchar *name;
-	const char *help;
+	struct gstr help = str_new();
 
-	help = menu_get_help(menu);
-
-	/* Gettextize if the help text not empty */
-	if ((help != 0) && (help[0] != 0))
-		help = _(help);
-
-	if (menu->sym && menu->sym->name)
-		name = g_strdup_printf(menu->sym->name);
-	else
-		name = g_strdup("");
+	menu_get_ext_help(menu, &help);
 
 	buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(text_w));
 	gtk_text_buffer_get_bounds(buffer, &start, &end);
@@ -478,14 +468,11 @@ static void text_insert_help(struct menu *menu)
 	gtk_text_buffer_get_end_iter(buffer, &end);
 	gtk_text_buffer_insert_with_tags(buffer, &end, prompt, -1, tag1,
 					 NULL);
-	gtk_text_buffer_insert_at_cursor(buffer, " ", 1);
-	gtk_text_buffer_get_end_iter(buffer, &end);
-	gtk_text_buffer_insert_with_tags(buffer, &end, name, -1, tag1,
-					 NULL);
 	gtk_text_buffer_insert_at_cursor(buffer, "\n\n", 2);
 	gtk_text_buffer_get_end_iter(buffer, &end);
-	gtk_text_buffer_insert_with_tags(buffer, &end, help, -1, tag2,
+	gtk_text_buffer_insert_with_tags(buffer, &end, str_get(&help), -1, tag2,
 					 NULL);
+	str_free(&help);
 }
 
 
-- 
1.6.3.3

