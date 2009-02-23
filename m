Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbZBWPL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbZBWPL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755663AbZBWPKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:10:30 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:26146 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbZBWPK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:10:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GH6vUUz30mDv57cOjf9d0tYW/V/QWq+rGFym1+dYO0dX+oaOrD3iP3umDFxtGavaBq
         4EWwgy0UUGyO0W1KH8ZwwvTWOH5H9KShU4boueT02GsqN8GbhyU917pQd8KjAqAXv1hB
         XaQuFNyFN61xxdNiHG2mDPoePTfAFNFckrSYQ=
From: Cheng Renquan <crquan@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       cr_quan@163.com
Subject: [PATCH 5/6] [KBUILD] make use of menu_get_ext_help in qconfig
Date: Mon, 23 Feb 2009 23:10:03 +0800
Message-Id: <1235401804-8136-6-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235401804-8136-5-git-send-email-crquan@gmail.com>
References: <1235401804-8136-1-git-send-email-crquan@gmail.com>
 <1235401804-8136-2-git-send-email-crquan@gmail.com>
 <1235401804-8136-3-git-send-email-crquan@gmail.com>
 <1235401804-8136-4-git-send-email-crquan@gmail.com>
 <1235401804-8136-5-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cheng Renquan <crquan@gmail.com>
---
 scripts/kconfig/qconf.cc |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 5d0fd38..9e03592 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -1041,12 +1041,10 @@ void ConfigInfoView::menuInfo(void)
 		if (showDebug())
 			debug = debug_info(sym);
 
-		help = menu_get_help(menu);
-		/* Gettextize if the help text not empty */
-		if (help.isEmpty())
-			help = print_filter(menu_get_help(menu));
-		else
-			help = print_filter(_(menu_get_help(menu)));
+		struct gstr help_gstr = str_new();
+		menu_get_ext_help(menu, &help_gstr);
+		help = print_filter(str_get(&help_gstr));
+		str_free(&help_gstr);
 	} else if (menu->prompt) {
 		head += "<big><b>";
 		head += print_filter(_(menu->prompt->text));
-- 
1.6.0.6

