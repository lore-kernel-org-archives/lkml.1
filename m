Return-Path: <linux-kernel-owner+w=401wt.eu-S1762865AbYAKXHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762865AbYAKXHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 18:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760249AbYAKXHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 18:07:11 -0500
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:61502 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759284AbYAKXHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 18:07:09 -0500
Subject: [PATCH 2/10] kconfig: gettext support for lxdialog
From: EGRY Gabor <gaboregry1@t-online.hu>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-kernel@zh-kernel.org
Content-Type: text/plain
Date: Fri, 11 Jan 2008 23:42:54 +0100
Message-Id: <1200091374.10603.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gettext support for lxdialog.

Signed-off-by: Egry Gabor <gaboregry1@t-online.hu>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>

---

 kbuild-szilard/scripts/kconfig/POTFILES.in          |    6 ++++++
 kbuild-szilard/scripts/kconfig/lxdialog/checklist.c |    4 ++--
 kbuild-szilard/scripts/kconfig/lxdialog/dialog.h    |    6 ++++++
 kbuild-szilard/scripts/kconfig/lxdialog/inputbox.c  |    4 ++--
 kbuild-szilard/scripts/kconfig/lxdialog/menubox.c   |    6 +++---
 kbuild-szilard/scripts/kconfig/lxdialog/textbox.c   |    2 +-
 kbuild-szilard/scripts/kconfig/lxdialog/yesno.c     |    4 ++--
 7 files changed, 22 insertions(+), 10 deletions(-)

diff -puN scripts/kconfig/lxdialog/checklist.c~kconfig-i18n-03-lxdialog-i18n scripts/kconfig/lxdialog/checklist.c
--- kbuild/scripts/kconfig/lxdialog/checklist.c~kconfig-i18n-03-lxdialog-i18n	2008-01-11 22:24:39.000000000 +0100
+++ kbuild-szilard/scripts/kconfig/lxdialog/checklist.c	2008-01-11 22:24:39.000000000 +0100
@@ -97,8 +97,8 @@ static void print_buttons(WINDOW * dialo
 	int x = width / 2 - 11;
 	int y = height - 2;
 
-	print_button(dialog, "Select", y, x, selected == 0);
-	print_button(dialog, " Help ", y, x + 14, selected == 1);
+	print_button(dialog, gettext("Select"), y, x, selected == 0);
+	print_button(dialog, gettext(" Help "), y, x + 14, selected == 1);
 
 	wmove(dialog, y, x + 1 + 14 * selected);
 	wrefresh(dialog);
diff -puN scripts/kconfig/lxdialog/dialog.h~kconfig-i18n-03-lxdialog-i18n scripts/kconfig/lxdialog/dialog.h
--- kbuild/scripts/kconfig/lxdialog/dialog.h~kconfig-i18n-03-lxdialog-i18n	2008-01-11 22:24:39.000000000 +0100
+++ kbuild-szilard/scripts/kconfig/lxdialog/dialog.h	2008-01-11 22:24:39.000000000 +0100
@@ -26,6 +26,12 @@
 #include <string.h>
 #include <stdbool.h>
 
+#ifndef KBUILD_NO_NLS
+# include <libintl.h>
+#else
+# define gettext(Msgid) ((const char *) (Msgid))
+#endif
+
 #ifdef __sun__
 #define CURS_MACROS
 #endif
diff -puN scripts/kconfig/lxdialog/inputbox.c~kconfig-i18n-03-lxdialog-i18n scripts/kconfig/lxdialog/inputbox.c
--- kbuild/scripts/kconfig/lxdialog/inputbox.c~kconfig-i18n-03-lxdialog-i18n	2008-01-11 22:24:39.000000000 +0100
+++ kbuild-szilard/scripts/kconfig/lxdialog/inputbox.c	2008-01-11 22:24:39.000000000 +0100
@@ -31,8 +31,8 @@ static void print_buttons(WINDOW * dialo
 	int x = width / 2 - 11;
 	int y = height - 2;
 
-	print_button(dialog, "  Ok  ", y, x, selected == 0);
-	print_button(dialog, " Help ", y, x + 14, selected == 1);
+	print_button(dialog, gettext("  Ok  "), y, x, selected == 0);
+	print_button(dialog, gettext(" Help "), y, x + 14, selected == 1);
 
 	wmove(dialog, y, x + 1 + 14 * selected);
 	wrefresh(dialog);
diff -puN scripts/kconfig/lxdialog/menubox.c~kconfig-i18n-03-lxdialog-i18n scripts/kconfig/lxdialog/menubox.c
--- kbuild/scripts/kconfig/lxdialog/menubox.c~kconfig-i18n-03-lxdialog-i18n	2008-01-11 22:24:39.000000000 +0100
+++ kbuild-szilard/scripts/kconfig/lxdialog/menubox.c	2008-01-11 22:24:39.000000000 +0100
@@ -157,9 +157,9 @@ static void print_buttons(WINDOW * win, 
 	int x = width / 2 - 16;
 	int y = height - 2;
 
-	print_button(win, "Select", y, x, selected == 0);
-	print_button(win, " Exit ", y, x + 12, selected == 1);
-	print_button(win, " Help ", y, x + 24, selected == 2);
+	print_button(win, gettext("Select"), y, x, selected == 0);
+	print_button(win, gettext(" Exit "), y, x + 12, selected == 1);
+	print_button(win, gettext(" Help "), y, x + 24, selected == 2);
 
 	wmove(win, y, x + 1 + 12 * selected);
 	wrefresh(win);
diff -puN scripts/kconfig/lxdialog/textbox.c~kconfig-i18n-03-lxdialog-i18n scripts/kconfig/lxdialog/textbox.c
--- kbuild/scripts/kconfig/lxdialog/textbox.c~kconfig-i18n-03-lxdialog-i18n	2008-01-11 22:24:39.000000000 +0100
+++ kbuild-szilard/scripts/kconfig/lxdialog/textbox.c	2008-01-11 22:24:39.000000000 +0100
@@ -114,7 +114,7 @@ do_resize:
 
 	print_title(dialog, title, width);
 
-	print_button(dialog, " Exit ", height - 2, width / 2 - 4, TRUE);
+	print_button(dialog, gettext(" Exit "), height - 2, width / 2 - 4, TRUE);
 	wnoutrefresh(dialog);
 	getyx(dialog, cur_y, cur_x);	/* Save cursor position */
 
diff -puN scripts/kconfig/lxdialog/yesno.c~kconfig-i18n-03-lxdialog-i18n scripts/kconfig/lxdialog/yesno.c
--- kbuild/scripts/kconfig/lxdialog/yesno.c~kconfig-i18n-03-lxdialog-i18n	2008-01-11 22:24:39.000000000 +0100
+++ kbuild-szilard/scripts/kconfig/lxdialog/yesno.c	2008-01-11 22:24:39.000000000 +0100
@@ -29,8 +29,8 @@ static void print_buttons(WINDOW * dialo
 	int x = width / 2 - 10;
 	int y = height - 2;
 
-	print_button(dialog, " Yes ", y, x, selected == 0);
-	print_button(dialog, "  No  ", y, x + 13, selected == 1);
+	print_button(dialog, gettext(" Yes "), y, x, selected == 0);
+	print_button(dialog, gettext("  No  "), y, x + 13, selected == 1);
 
 	wmove(dialog, y, x + 1 + 13 * selected);
 	wrefresh(dialog);
diff -puN scripts/kconfig/POTFILES.in~kconfig-i18n-03-lxdialog-i18n scripts/kconfig/POTFILES.in
--- kbuild/scripts/kconfig/POTFILES.in~kconfig-i18n-03-lxdialog-i18n	2008-01-11 22:24:39.000000000 +0100
+++ kbuild-szilard/scripts/kconfig/POTFILES.in	2008-01-11 22:27:38.000000000 +0100
@@ -1,3 +1,9 @@
+scripts/kconfig/lxdialog/checklist.c
+scripts/kconfig/lxdialog/inputbox.c
+scripts/kconfig/lxdialog/menubox.c
+scripts/kconfig/lxdialog/textbox.c
+scripts/kconfig/lxdialog/util.c
+scripts/kconfig/lxdialog/yesno.c
 scripts/kconfig/mconf.c
 scripts/kconfig/conf.c
 scripts/kconfig/confdata.c
_

