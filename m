Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbZBWPLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbZBWPLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbZBWPK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:10:28 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:24359 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbZBWPK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:10:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ni7xyZzAfj21QnQIWX4kFR4bMcFa2vSiVBApVZp3BEy+ZrMJR0OEghLEFa6HSCBofX
         Z1K3KXKw3+DCDm3RQ+EJHwDuaCcQlq57Hdlm54vG+dZ0b5aRGAm1UZLtPjZ+wWuklYAQ
         VxXnz7hTL7RYWXTCZYVu0bGpKKzlV6m8sxBzE=
From: Cheng Renquan <crquan@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       cr_quan@163.com
Subject: [PATCH 4/6] [KBUILD] make use of menu_get_ext_help in gconfig
Date: Mon, 23 Feb 2009 23:10:02 +0800
Message-Id: <1235401804-8136-5-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235401804-8136-4-git-send-email-crquan@gmail.com>
References: <1235401804-8136-1-git-send-email-crquan@gmail.com>
 <1235401804-8136-2-git-send-email-crquan@gmail.com>
 <1235401804-8136-3-git-send-email-crquan@gmail.com>
 <1235401804-8136-4-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.6.0.6

