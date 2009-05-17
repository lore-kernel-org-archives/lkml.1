Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbZEQXjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbZEQXjg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 19:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbZEQXg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 19:36:57 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:43806 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbZEQXgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 19:36:49 -0400
From: Markus Heidelberg <markus.heidelberg@web.de>
To: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Markus Heidelberg <markus.heidelberg@web.de>
Subject: [PATCH resend 08/10] kconfig qconf: fix the type of the desktop widget
Date: Mon, 18 May 2009 01:36:52 +0200
Message-Id: <1242603414-9267-9-git-send-email-markus.heidelberg@web.de>
X-Mailer: git-send-email 1.6.3.1.20.ga30f
In-Reply-To: <1242603414-9267-1-git-send-email-markus.heidelberg@web.de>
References: <1242603414-9267-1-git-send-email-markus.heidelberg@web.de>
X-Provags-ID: V01U2FsdGVkX19c9fNKD/L+3liqTvYu8I7jfkmcoM2eLZO/OctZ
	4zMuncN2cmYwmzJh8BhyZXbIUR6w/hUlMKHG5HhiXrZdkb1cuF
	FSBRJDgqaVgM7vKBW62A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

QApplication::desktop() returns a pointer to QDesktopWidget, not to
QWidget.

Fixes the following compiler error after a quick conversion with 'qt3to4',
which occured with g++ 3.4.6 and 4.1.2, but not anymore with 4.3.2.

scripts/kconfig/qconf.cc: In constructor 'ConfigMainWindow::ConfigMainWindow()':
scripts/kconfig/qconf.cc:1289: error: cannot convert 'QDesktopWidget*' to 'QWidget*' in initialization

Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
---
 scripts/kconfig/qconf.cc |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index afae613..19811fc 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -5,6 +5,7 @@
 
 #include <qapplication.h>
 #include <qmainwindow.h>
+#include <qdesktopwidget.h>
 #include <qtoolbar.h>
 #include <qlayout.h>
 #include <qvbox.h>
@@ -1275,7 +1276,7 @@ ConfigMainWindow::ConfigMainWindow(void)
 	int x, y, width, height;
 	char title[256];
 
-	QWidget *d = configApp->desktop();
+	QDesktopWidget *d = configApp->desktop();
 	snprintf(title, sizeof(title), _("Linux Kernel v%s Configuration"),
 		getenv("KERNELVERSION"));
 	setCaption(title);
-- 
1.6.3.1.20.ga30f

