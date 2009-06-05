Return-Path: <linux-kernel-owner+w=401wt.eu-S1756964AbZFEXsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbZFEXsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756222AbZFEXl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:56 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36404 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbZFEXlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:12 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Markus Heidelberg <markus.heidelberg@web.de>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 27/39] kconfig qconf: fix -Wall compiler warnings
Date: Sat,  6 Jun 2009 01:42:45 +0200
Message-Id: <1244245377-17441-27-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Heidelberg <markus.heidelberg@web.de>

These compiler warnings occure when adding -Wall to HOSTCXXFLAGS in
/Makefile

scripts/kconfig/qconf.h: In constructor ‘ConfigInfoView::ConfigInfoView(QWidget*, const char*)’:
scripts/kconfig/qconf.h:274: warning: ‘ConfigInfoView::menu’ will be initialized after
scripts/kconfig/qconf.h:273: warning:   ‘symbol* ConfigInfoView::sym’
scripts/kconfig/qconf.cc:922: warning:   when initialized here

scripts/kconfig/qconf.cc: In member function ‘void ConfigMainWindow::setMenuLink(menu*)’:
scripts/kconfig/qconf.cc:1498: warning: enumeration value ‘menuMode’ not handled in switch
scripts/kconfig/qconf.cc:1498: warning: enumeration value ‘listMode’ not handled in switch

scripts/kconfig/qconf.cc: In member function ‘void ConfigMainWindow::saveSettings()’:
scripts/kconfig/qconf.cc:1664: warning: enumeration value ‘menuMode’ not handled in switch
scripts/kconfig/qconf.cc:1664: warning: enumeration value ‘listMode’ not handled in switch

Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/qconf.cc |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 5d0fd38..2bd6ed0 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -920,7 +920,7 @@ void ConfigView::updateListAll(void)
 }
 
 ConfigInfoView::ConfigInfoView(QWidget* parent, const char *name)
-	: Parent(parent, name), menu(0), sym(0)
+	: Parent(parent, name), sym(0), menu(0)
 {
 	if (name) {
 		configSettings->beginGroup(name);
@@ -1524,6 +1524,8 @@ void ConfigMainWindow::setMenuLink(struct menu *menu)
 	case fullMode:
 		list = configList;
 		break;
+	default:
+		break;
 	}
 
 	if (list) {
@@ -1673,6 +1675,9 @@ void ConfigMainWindow::saveSettings(void)
 	case fullMode :
 		entry = "full";
 		break;
+
+	default:
+		break;
 	}
 	configSettings->writeEntry("/listMode", entry);
 
-- 
1.6.3.rc3.40.g75b44

