Return-Path: <linux-kernel-owner+w=401wt.eu-S1763387AbYAKWzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763387AbYAKWzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 17:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763107AbYAKWz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 17:55:27 -0500
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:51909 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763048AbYAKWzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 17:55:25 -0500
Subject: [PATCH 10/10] kconfig: whitespace removing
From: EGRY Gabor <gaboregry1@t-online.hu>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-kernel@zh-kernel.org
Content-Type: text/plain
Date: Fri, 11 Jan 2008 23:55:20 +0100
Message-Id: <1200092120.10603.54.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch removes the unnecessary whitespaces from end of help lines of Kconfig files.

Signed-off-by: Egry Gabor <gaboregry1@t-online.hu>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
---

 kbuild-szilard/scripts/kconfig/lex.zconf.c_shipped |    5 +++++
 kbuild-szilard/scripts/kconfig/zconf.l             |    5 +++++
 2 files changed, 10 insertions(+)

diff -puN scripts/kconfig/zconf.l~kconfig-i18n-18-whitespace-fix scripts/kconfig/zconf.l
--- kbuild/scripts/kconfig/zconf.l~kconfig-i18n-18-whitespace-fix	2008-01-11 22:27:19.000000000 +0100
+++ kbuild-szilard/scripts/kconfig/zconf.l	2008-01-11 22:27:19.000000000 +0100
@@ -217,6 +217,11 @@ n	[A-Za-z0-9_]
 		append_string("\n", 1);
 	}
 	[^ \t\n].* {
+		while (yyleng) {
+			if ((yytext[yyleng-1] != ' ') && (yytext[yyleng-1] != '\t'))
+				break;
+			yyleng--;
+		}
 		append_string(yytext, yyleng);
 		if (!first_ts)
 			first_ts = last_ts;
diff -puN scripts/kconfig/lex.zconf.c_shipped~kconfig-i18n-18-whitespace-fix scripts/kconfig/lex.zconf.c_shipped
--- kbuild/scripts/kconfig/lex.zconf.c_shipped~kconfig-i18n-18-whitespace-fix	2008-01-11 22:27:19.000000000 +0100
+++ kbuild-szilard/scripts/kconfig/lex.zconf.c_shipped	2008-01-11 22:27:19.000000000 +0100
@@ -1275,6 +1275,11 @@ YY_RULE_SETUP
 case 32:
 YY_RULE_SETUP
 {
+		while (zconfleng) {
+			if ((zconftext[zconfleng-1] != ' ') && (zconftext[zconfleng-1] != '\t'))
+				break;
+			zconfleng--;
+		}
 		append_string(zconftext, zconfleng);
 		if (!first_ts)
 			first_ts = last_ts;
_

