Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbZEQXiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbZEQXiv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 19:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbZEQXgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 19:36:55 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:43793 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbZEQXgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 19:36:48 -0400
From: Markus Heidelberg <markus.heidelberg@web.de>
To: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Markus Heidelberg <markus.heidelberg@web.de>
Subject: [PATCH resend 05/10] kconfig qconf: fix -Wall compiler warnings
Date: Mon, 18 May 2009 01:36:49 +0200
Message-Id: <1242603414-9267-6-git-send-email-markus.heidelberg@web.de>
X-Mailer: git-send-email 1.6.3.1.20.ga30f
In-Reply-To: <1242603414-9267-1-git-send-email-markus.heidelberg@web.de>
References: <1242603414-9267-1-git-send-email-markus.heidelberg@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1/SbF/tGJfXDJ40LLOjmOM6WMfnUVw22vSHkROW
	gW4wQO+UfCNyejS7eLhvVxPkQvknvxPUufiO//itBchKDUMZ3n
	0rHDGY0xpCU+/RCwYx/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.6.3.1.20.ga30f

