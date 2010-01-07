Return-Path: <linux-kernel-owner+w=401wt.eu-S1752954Ab0AGOxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab0AGOxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 09:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935Ab0AGOx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 09:53:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:51254 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab0AGOxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 09:53:25 -0500
From: Michal Marek <mmarek@suse.cz>
To: Nir Tzachar <nir.tzachar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] nconfig: mark local functions as such
Date: Thu,  7 Jan 2010 15:52:48 +0100
Message-Id: <1262875968-1078-3-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1262875968-1078-1-git-send-email-mmarek@suse.cz>
References: <1262875968-1078-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scripts/kconfig/nconf.gui.c:23: warning: no previous prototype for 'set_normal_colors'
scripts/kconfig/nconf.gui.c:68: warning: no previous prototype for 'normal_color_theme'
scripts/kconfig/nconf.gui.c:100: warning: no previous prototype for 'no_colors_theme'
scripts/kconfig/nconf.c:455: warning: no previous prototype for 'process_special_keys'
scripts/kconfig/nconf.c:487: warning: no previous prototype for 'get_next_hot'
scripts/kconfig/nconf.c:506: warning: no previous prototype for 'canbhot'
scripts/kconfig/nconf.c:514: warning: no previous prototype for 'is_hot'
scripts/kconfig/nconf.c:522: warning: no previous prototype for 'make_hot'
scripts/kconfig/nconf.c:582: warning: no previous prototype for 'item_make'
scripts/kconfig/nconf.c:626: warning: no previous prototype for 'item_add_str'
scripts/kconfig/nconf.c:656: warning: no previous prototype for 'item_tag'
scripts/kconfig/nconf.c:668: warning: no previous prototype for 'curses_item_index'
scripts/kconfig/nconf.c:673: warning: no previous prototype for 'item_data'
scripts/kconfig/nconf.c:684: warning: no previous prototype for 'item_is_tag'
scripts/kconfig/nconf.c:691: warning: no previous prototype for 'set_config_filename'

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/kconfig/nconf.c     |   24 ++++++++++++------------
 scripts/kconfig/nconf.gui.c |    6 +++---
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index 8c56150..fb54c98 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -452,7 +452,7 @@ static void handle_f8(int *key, struct menu *current_item)
 }
 
 /* return != 0 to indicate the key was handles */
-int process_special_keys(int *key, struct menu *menu)
+static int process_special_keys(int *key, struct menu *menu)
 {
 	int i;
 
@@ -484,7 +484,7 @@ static void clean_items(void)
 }
 
 /* return the index of the next hot item, or -1 if no such item exists */
-int get_next_hot(int c)
+static int get_next_hot(int c)
 {
 	static int hot_index;
 	static int hot_char;
@@ -503,7 +503,7 @@ int get_next_hot(int c)
 }
 
 /* can the char c be a hot key? no, if c is a common shortcut used elsewhere */
-int canbhot(char c)
+static int canbhot(char c)
 {
 	c = tolower(c);
 	return isalnum(c) && c != 'y' && c != 'm' && c != 'h' &&
@@ -511,7 +511,7 @@ int canbhot(char c)
 }
 
 /* check if str already contains a hot key. */
-int is_hot(int index)
+static int is_hot(int index)
 {
 	return k_menu_items[index].is_hot;
 }
@@ -519,7 +519,7 @@ int is_hot(int index)
 /* find the first possible hot key, and mark it.
  * index is the index of the item in the menu
  * return 0 on success*/
-int make_hot(char *dest, int len, const char *org, int index)
+static int make_hot(char *dest, int len, const char *org, int index)
 {
 	int position = -1;
 	int i;
@@ -579,7 +579,7 @@ int make_hot(char *dest, int len, const char *org, int index)
 /* Make a new item. Add a hotkey mark in the first possible letter.
  * As ncurses does not allow any attributes inside menue item, we mark the
  * hot key as the first capitalized letter in the string */
-void item_make(struct menu *menu, char tag, const char *fmt, ...)
+static void item_make(struct menu *menu, char tag, const char *fmt, ...)
 {
 	va_list ap;
 	char tmp_str[256];
@@ -623,7 +623,7 @@ void item_make(struct menu *menu, char tag, const char *fmt, ...)
 }
 
 /* very hackish. adds a string to the last item added */
-void item_add_str(const char *fmt, ...)
+static void item_add_str(const char *fmt, ...)
 {
 	va_list ap;
 	int index = items_num-1;
@@ -653,7 +653,7 @@ void item_add_str(const char *fmt, ...)
 }
 
 /* get the tag of the currently selected item */
-char item_tag(void)
+static char item_tag(void)
 {
 	ITEM *cur;
 	struct mitem *mcur;
@@ -665,12 +665,12 @@ char item_tag(void)
 	return mcur->tag;
 }
 
-int curses_item_index(void)
+static int curses_item_index(void)
 {
 	return  item_index(current_item(curses_menu));
 }
 
-void *item_data(void)
+static void *item_data(void)
 {
 	ITEM *cur;
 	struct mitem *mcur;
@@ -681,14 +681,14 @@ void *item_data(void)
 
 }
 
-int item_is_tag(char tag)
+static int item_is_tag(char tag)
 {
 	return item_tag() == tag;
 }
 
 static char filename[PATH_MAX+1];
 static char menu_backtitle[PATH_MAX+128];
-const char *set_config_filename(const char *config_filename)
+static const char *set_config_filename(const char *config_filename)
 {
 	int size;
 	struct symbol *sym;
diff --git a/scripts/kconfig/nconf.gui.c b/scripts/kconfig/nconf.gui.c
index 879ade6..115edb4 100644
--- a/scripts/kconfig/nconf.gui.c
+++ b/scripts/kconfig/nconf.gui.c
@@ -20,7 +20,7 @@ attributes_t attributes[ATTR_MAX+1] = {0};
    COLOR_CYAN    6
    COLOR_WHITE   7
    */
-void set_normal_colors(void)
+static void set_normal_colors(void)
 {
 	init_pair(NORMAL, -1, -1);
 	init_pair(MAIN_HEADING, COLOR_MAGENTA, -1);
@@ -65,7 +65,7 @@ void set_normal_colors(void)
    A_CHARTEXT      Bit-mask to extract a character
    COLOR_PAIR(n)   Color-pair number n
    */
-void normal_color_theme(void)
+static void normal_color_theme(void)
 {
 	/* automatically add color... */
 #define mkattr(name, attr) do { \
@@ -97,7 +97,7 @@ attributes[name] = attr | COLOR_PAIR(name); } while (0)
 	mkattr(FUNCTION_TEXT, A_REVERSE);
 }
 
-void no_colors_theme(void)
+static void no_colors_theme(void)
 {
 	/* automatically add highlight, no color */
 #define mkattrn(name, attr) { attributes[name] = attr; }
-- 
1.6.5.3

