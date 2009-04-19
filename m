Return-Path: <linux-kernel-owner+w=401wt.eu-S1761729AbZDSNof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761729AbZDSNof (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 09:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760857AbZDSNld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 09:41:33 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:53348 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758584AbZDSNlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 09:41:22 -0400
From: Markus Heidelberg <markus.heidelberg@web.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Markus Heidelberg <markus.heidelberg@web.de>
Subject: [PATCH 07/10] kconfig qconf: add namespace for use of Key_ enum values
Date: Sun, 19 Apr 2009 15:41:24 +0200
Message-Id: <1240148487-27584-8-git-send-email-markus.heidelberg@web.de>
X-Mailer: git-send-email 1.6.3.rc1.24.g467d50
In-Reply-To: <1240148487-27584-1-git-send-email-markus.heidelberg@web.de>
References: <1240148487-27584-1-git-send-email-markus.heidelberg@web.de>
X-Provags-ID: V01U2FsdGVkX19ZPXG9cl4NbHdrZeVrH/4NtQXC5RmUlqhtx1bk
	nCJQhy69pRgvx6+JrdsnqUBLBUbWL4rxojRV5MEImzqtDEFLI7
	/s1qq+sXosbKSlLxnrYA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are defined in the 'Qt' namespace.

Fixes the following compiler errors after a quick conversion with 'qt3to4',
which occured with g++ 3.4.6 and 4.1.2, but not anymore with 4.3.2.

scripts/kconfig/qconf.cc: In member function 'virtual void ConfigLineEdit::keyPressEvent(QKeyEvent*)':
scripts/kconfig/qconf.cc:311: error: 'Key_Escape' was not declared in this scope
scripts/kconfig/qconf.cc:313: error: 'Key_Return' was not declared in this scope
scripts/kconfig/qconf.cc:314: error: 'Key_Enter' was not declared in this scope

scripts/kconfig/qconf.cc: In member function 'virtual void ConfigList::keyPressEvent(QKeyEvent*)':
scripts/kconfig/qconf.cc:653: error: 'Key_Escape' was not declared in this scope
scripts/kconfig/qconf.cc:666: error: 'Key_Return' was not declared in this scope
scripts/kconfig/qconf.cc:667: error: 'Key_Enter' was not declared in this scope
scripts/kconfig/qconf.cc:681: error: 'Key_Space' was not declared in this scope
scripts/kconfig/qconf.cc:684: error: 'Key_N' was not declared in this scope
scripts/kconfig/qconf.cc:687: error: 'Key_M' was not declared in this scope
scripts/kconfig/qconf.cc:690: error: 'Key_Y' was not declared in this scope

scripts/kconfig/qconf.cc: In constructor 'ConfigMainWindow::ConfigMainWindow()':
scripts/kconfig/qconf.cc:1329: error: 'CTRL' was not declared in this scope
scripts/kconfig/qconf.cc:1329: error: 'Key_Q' was not declared in this scope
scripts/kconfig/qconf.cc:1331: error: 'Key_L' was not declared in this scope
scripts/kconfig/qconf.cc:1333: error: 'Key_S' was not declared in this scope
scripts/kconfig/qconf.cc:1340: error: 'Key_F' was not declared in this scope

Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
---
 scripts/kconfig/qconf.cc |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 7433dac..afae613 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -297,10 +297,10 @@ void ConfigLineEdit::show(ConfigItem* i)
 void ConfigLineEdit::keyPressEvent(QKeyEvent* e)
 {
 	switch (e->key()) {
-	case Key_Escape:
+	case Qt::Key_Escape:
 		break;
-	case Key_Return:
-	case Key_Enter:
+	case Qt::Key_Return:
+	case Qt::Key_Enter:
 		sym_set_string_value(item->menu->sym, text().latin1());
 		parent()->updateList(item);
 		break;
@@ -639,7 +639,7 @@ void ConfigList::keyPressEvent(QKeyEvent* ev)
 	struct menu *menu;
 	enum prop_type type;
 
-	if (ev->key() == Key_Escape && mode != fullMode && mode != listMode) {
+	if (ev->key() == Qt::Key_Escape && mode != fullMode && mode != listMode) {
 		emit parentSelected();
 		ev->accept();
 		return;
@@ -652,8 +652,8 @@ void ConfigList::keyPressEvent(QKeyEvent* ev)
 	item = (ConfigItem*)i;
 
 	switch (ev->key()) {
-	case Key_Return:
-	case Key_Enter:
+	case Qt::Key_Return:
+	case Qt::Key_Enter:
 		if (item->goParent) {
 			emit parentSelected();
 			break;
@@ -667,16 +667,16 @@ void ConfigList::keyPressEvent(QKeyEvent* ev)
 			emit menuSelected(menu);
 			break;
 		}
-	case Key_Space:
+	case Qt::Key_Space:
 		changeValue(item);
 		break;
-	case Key_N:
+	case Qt::Key_N:
 		setValue(item, no);
 		break;
-	case Key_M:
+	case Qt::Key_M:
 		setValue(item, mod);
 		break;
-	case Key_Y:
+	case Qt::Key_Y:
 		setValue(item, yes);
 		break;
 	default:
@@ -1315,18 +1315,18 @@ ConfigMainWindow::ConfigMainWindow(void)
 	backAction = new QAction("Back", QPixmap(xpm_back), _("Back"), 0, this);
 	  connect(backAction, SIGNAL(activated()), SLOT(goBack()));
 	  backAction->setEnabled(FALSE);
-	QAction *quitAction = new QAction("Quit", _("&Quit"), CTRL+Key_Q, this);
+	QAction *quitAction = new QAction("Quit", _("&Quit"), Qt::CTRL + Qt::Key_Q, this);
 	  connect(quitAction, SIGNAL(activated()), SLOT(close()));
-	QAction *loadAction = new QAction("Load", QPixmap(xpm_load), _("&Load"), CTRL+Key_L, this);
+	QAction *loadAction = new QAction("Load", QPixmap(xpm_load), _("&Load"), Qt::CTRL + Qt::Key_L, this);
 	  connect(loadAction, SIGNAL(activated()), SLOT(loadConfig()));
-	saveAction = new QAction("Save", QPixmap(xpm_save), _("&Save"), CTRL+Key_S, this);
+	saveAction = new QAction("Save", QPixmap(xpm_save), _("&Save"), Qt::CTRL + Qt::Key_S, this);
 	  connect(saveAction, SIGNAL(activated()), SLOT(saveConfig()));
 	conf_set_changed_callback(conf_changed);
 	// Set saveAction's initial state
 	conf_changed();
 	QAction *saveAsAction = new QAction("Save As...", _("Save &As..."), 0, this);
 	  connect(saveAsAction, SIGNAL(activated()), SLOT(saveConfigAs()));
-	QAction *searchAction = new QAction("Find", _("&Find"), CTRL+Key_F, this);
+	QAction *searchAction = new QAction("Find", _("&Find"), Qt::CTRL + Qt::Key_F, this);
 	  connect(searchAction, SIGNAL(activated()), SLOT(searchConfig()));
 	QAction *singleViewAction = new QAction("Single View", QPixmap(xpm_single_view), _("Single View"), 0, this);
 	  connect(singleViewAction, SIGNAL(activated()), SLOT(showSingleView()));
-- 
1.6.3.rc1.24.g467d50

