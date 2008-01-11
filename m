Return-Path: <linux-kernel-owner+w=401wt.eu-S1763339AbYAKXOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763339AbYAKXOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 18:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762159AbYAKXOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 18:14:42 -0500
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:50622 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbYAKXOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 18:14:41 -0500
Subject: [PATCH 7/10] kconfig: gettext support for menuconfig
From: EGRY Gabor <gaboregry1@t-online.hu>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-kernel@zh-kernel.org
Content-Type: text/plain
Date: Fri, 11 Jan 2008 23:50:37 +0100
Message-Id: <1200091837.10603.47.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Full gettext support for menuconfig.

Signed-off-by: Egry Gabor <gaboregry1@t-online.hu>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
---

 kbuild-szilard/scripts/kconfig/mconf.c |   51 ++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff -puN scripts/kconfig/mconf.c~kconfig-i18n-12-menuconfig-i18n scripts/kconfig/mconf.c
--- kbuild/scripts/kconfig/mconf.c~kconfig-i18n-12-menuconfig-i18n	2008-01-11 22:27:15.000000000 +0100
+++ kbuild-szilard/scripts/kconfig/mconf.c	2008-01-11 22:27:15.000000000 +0100
@@ -289,11 +289,11 @@ static void get_prompt_str(struct gstr *
 	int i, j;
 	struct menu *submenu[8], *menu;
 
-	str_printf(r, "Prompt: %s\n", prop->text);
-	str_printf(r, "  Defined at %s:%d\n", prop->menu->file->name,
+	str_printf(r, _("Prompt: %s\n"), _(prop->text));
+	str_printf(r, _("  Defined at %s:%d\n"), prop->menu->file->name,
 		prop->menu->lineno);
 	if (!expr_is_yes(prop->visible.expr)) {
-		str_append(r, "  Depends on: ");
+		str_append(r, _("  Depends on: "));
 		expr_gstr_print(prop->visible.expr, r);
 		str_append(r, "\n");
 	}
@@ -301,13 +301,13 @@ static void get_prompt_str(struct gstr *
 	for (i = 0; menu != &rootmenu && i < 8; menu = menu->parent)
 		submenu[i++] = menu;
 	if (i > 0) {
-		str_printf(r, "  Location:\n");
+		str_printf(r, _("  Location:\n"));
 		for (j = 4; --i >= 0; j += 2) {
 			menu = submenu[i];
-			str_printf(r, "%*c-> %s", j, ' ', menu_get_prompt(menu));
+			str_printf(r, "%*c-> %s", j, ' ', _(menu_get_prompt(menu)));
 			if (menu->sym) {
 				str_printf(r, " (%s [=%s])", menu->sym->name ?
-					menu->sym->name : "<choice>",
+					menu->sym->name : _("<choice>"),
 					sym_get_string_value(menu->sym));
 			}
 			str_append(r, "\n");
@@ -337,7 +337,7 @@ static void get_symbol_str(struct gstr *
 	if (hit)
 		str_append(r, "\n");
 	if (sym->rev_dep.expr) {
-		str_append(r, "  Selected by: ");
+		str_append(r, _("  Selected by: "));
 		expr_gstr_print(sym->rev_dep.expr, r);
 		str_append(r, "\n");
 	}
@@ -353,7 +353,7 @@ static struct gstr get_relations_str(str
 	for (i = 0; sym_arr && (sym = sym_arr[i]); i++)
 		get_symbol_str(&res, sym);
 	if (!i)
-		str_append(&res, "No matches found.\n");
+		str_append(&res, _("No matches found.\n"));
 	return res;
 }
 
@@ -433,6 +433,7 @@ static void build_conf(struct menu *menu
 			switch (prop->type) {
 			case P_MENU:
 				child_count++;
+				prompt = _(prompt);
 				if (single_menu_mode) {
 					item_make("%s%*c%s",
 						  menu->data ? "-->" : "++>",
@@ -448,7 +449,7 @@ static void build_conf(struct menu *menu
 			case P_COMMENT:
 				if (prompt) {
 					child_count++;
-					item_make("   %*c*** %s ***", indent + 1, ' ', prompt);
+					item_make("   %*c*** %s ***", indent + 1, ' ', _(prompt));
 					item_set_tag(':');
 					item_set_data(menu);
 				}
@@ -456,7 +457,7 @@ static void build_conf(struct menu *menu
 			default:
 				if (prompt) {
 					child_count++;
-					item_make("---%*c%s", indent + 1, ' ', prompt);
+					item_make("---%*c%s", indent + 1, ' ', _(prompt));
 					item_set_tag(':');
 					item_set_data(menu);
 				}
@@ -500,10 +501,10 @@ static void build_conf(struct menu *menu
 			item_set_data(menu);
 		}
 
-		item_add_str("%*c%s", indent + 1, ' ', menu_get_prompt(menu));
+		item_add_str("%*c%s", indent + 1, ' ', _(menu_get_prompt(menu)));
 		if (val == yes) {
 			if (def_menu) {
-				item_add_str(" (%s)", menu_get_prompt(def_menu));
+				item_add_str(" (%s)", _(menu_get_prompt(def_menu)));
 				item_add_str("  --->");
 				if (def_menu->list) {
 					indent += 2;
@@ -515,7 +516,7 @@ static void build_conf(struct menu *menu
 		}
 	} else {
 		if (menu == current_menu) {
-			item_make("---%*c%s", indent + 1, ' ', menu_get_prompt(menu));
+			item_make("---%*c%s", indent + 1, ' ', _(menu_get_prompt(menu)));
 			item_set_tag(':');
 			item_set_data(menu);
 			goto conf_childs;
@@ -558,17 +559,17 @@ static void build_conf(struct menu *menu
 				tmp = indent - tmp + 4;
 				if (tmp < 0)
 					tmp = 0;
-				item_add_str("%*c%s%s", tmp, ' ', menu_get_prompt(menu),
+				item_add_str("%*c%s%s", tmp, ' ', _(menu_get_prompt(menu)),
 					     (sym_has_value(sym) || !sym_is_changable(sym)) ?
-					     "" : " (NEW)");
+					     "" : _(" (NEW)"));
 				item_set_tag('s');
 				item_set_data(menu);
 				goto conf_childs;
 			}
 		}
-		item_add_str("%*c%s%s", indent + 1, ' ', menu_get_prompt(menu),
+		item_add_str("%*c%s%s", indent + 1, ' ', _(menu_get_prompt(menu)),
 			  (sym_has_value(sym) || !sym_is_changable(sym)) ?
-			  "" : " (NEW)");
+			  "" : _(" (NEW)"));
 		if (menu->prompt->type == P_MENU) {
 			item_add_str("  --->");
 			return;
@@ -606,7 +607,7 @@ static void conf(struct menu *menu)
 			item_set_tag('S');
 		}
 		dialog_clear();
-		res = dialog_menu(prompt ? prompt : _("Main Menu"),
+		res = dialog_menu(prompt ? _(prompt) : _("Main Menu"),
 				  _(menu_instructions),
 				  active_menu, &s_scroll);
 		if (res == 1 || res == KEY_ESC || res == -ERRDISPLAYTOOSMALL)
@@ -653,7 +654,7 @@ static void conf(struct menu *menu)
 			if (sym)
 				show_help(submenu);
 			else
-				show_helptext("README", _(mconf_readme));
+				show_helptext(_("README"), _(mconf_readme));
 			break;
 		case 3:
 			if (item_is_tag('t')) {
@@ -711,13 +712,13 @@ static void show_help(struct menu *menu)
 		str_append(&help, nohelp_text);
 	}
 	get_symbol_str(&help, sym);
-	show_helptext(menu_get_prompt(menu), str_get(&help));
+	show_helptext(_(menu_get_prompt(menu)), str_get(&help));
 	str_free(&help);
 }
 
 static void conf_choice(struct menu *menu)
 {
-	const char *prompt = menu_get_prompt(menu);
+	const char *prompt = _(menu_get_prompt(menu));
 	struct menu *child;
 	struct symbol *active;
 
@@ -731,7 +732,7 @@ static void conf_choice(struct menu *men
 		for (child = menu->list; child; child = child->next) {
 			if (!menu_is_visible(child))
 				continue;
-			item_make("%s", menu_get_prompt(child));
+			item_make("%s", _(menu_get_prompt(child)));
 			item_set_data(child);
 			if (child->sym == active)
 				item_set_selected(1);
@@ -739,7 +740,7 @@ static void conf_choice(struct menu *men
 				item_set_tag('X');
 		}
 		dialog_clear();
-		res = dialog_checklist(prompt ? prompt : _("Main Menu"),
+		res = dialog_checklist(prompt ? _(prompt) : _("Main Menu"),
 					_(radiolist_instructions),
 					 15, 70, 6);
 		selected = item_activate_selected();
@@ -785,10 +786,10 @@ static void conf_string(struct menu *men
 			heading = _(inputbox_instructions_string);
 			break;
 		default:
-			heading = "Internal mconf error!";
+			heading = _("Internal mconf error!");
 		}
 		dialog_clear();
-		res = dialog_inputbox(prompt ? prompt : _("Main Menu"),
+		res = dialog_inputbox(prompt ? _(prompt) : _("Main Menu"),
 				      heading, 10, 75,
 				      sym_get_string_value(menu->sym));
 		switch (res) {
_

