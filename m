Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbZBWPM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbZBWPM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:12:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbZBWPKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:10:33 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:24359 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625AbZBWPKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:10:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=W8nS3Onl1uxNFfuifT8J9Kvhozpc6WmRvPXR0SMkxXlCjOtKytMzkkoYN4KZq1sTJw
         bT3dC9L1YjdnQBxBxj3QgujPT3J+Jz/ezlbAd0HdvTouYjTwcnYTeUMUhojdo8fCFMul
         OFP0UalpZgIvcIYICTA/rTI1tzJgZig3NYlTc=
From: Cheng Renquan <crquan@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       cr_quan@163.com
Subject: [PATCH 6/6] [KBUILD] make use of menu_get_ext_help in "make config"
Date: Mon, 23 Feb 2009 23:10:04 +0800
Message-Id: <1235401804-8136-7-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235401804-8136-6-git-send-email-crquan@gmail.com>
References: <1235401804-8136-1-git-send-email-crquan@gmail.com>
 <1235401804-8136-2-git-send-email-crquan@gmail.com>
 <1235401804-8136-3-git-send-email-crquan@gmail.com>
 <1235401804-8136-4-git-send-email-crquan@gmail.com>
 <1235401804-8136-5-git-send-email-crquan@gmail.com>
 <1235401804-8136-6-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cheng Renquan <crquan@gmail.com>
---
 scripts/kconfig/conf.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 3e1057f..8ec35c9 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -37,14 +37,14 @@ static int conf_cnt;
 static char line[128];
 static struct menu *rootEntry;
 
-static char nohelp_text[] = N_("Sorry, no help available for this option yet.\n");
-
-static const char *get_help(struct menu *menu)
+static void print_help(struct menu *menu)
 {
-	if (menu_has_help(menu))
-		return _(menu_get_help(menu));
-	else
-		return nohelp_text;
+	struct gstr help = str_new();
+
+	menu_get_ext_help(menu, &help);
+
+	printf("\n%s\n", str_get(&help));
+	str_free(&help);
 }
 
 static void strip(char *str)
@@ -139,7 +139,7 @@ int conf_string(struct menu *menu)
 		case '?':
 			/* print help */
 			if (line[1] == '\n') {
-				printf("\n%s\n", get_help(menu));
+				print_help(menu);
 				def = NULL;
 				break;
 			}
@@ -219,7 +219,7 @@ static int conf_sym(struct menu *menu)
 		if (sym_set_tristate_value(sym, newval))
 			return 0;
 help:
-		printf("\n%s\n", get_help(menu));
+		print_help(menu);
 	}
 }
 
@@ -306,7 +306,7 @@ static int conf_choice(struct menu *menu)
 			fgets(line, 128, stdin);
 			strip(line);
 			if (line[0] == '?') {
-				printf("\n%s\n", get_help(menu));
+				print_help(menu);
 				continue;
 			}
 			if (!line[0])
@@ -330,7 +330,7 @@ static int conf_choice(struct menu *menu)
 		if (!child)
 			continue;
 		if (line[strlen(line) - 1] == '?') {
-			printf("\n%s\n", get_help(child));
+			print_help(child);
 			continue;
 		}
 		sym_set_choice_value(sym, child->sym);
-- 
1.6.0.6

