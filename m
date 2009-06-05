Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbZFEXol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbZFEXol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbZFEXlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:35 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:45073 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487AbZFEXlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:12 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Markus Heidelberg <markus.heidelberg@web.de>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 28/39] kconfig qconf: fix namespace for Horizontal and Vertical enum values
Date: Sat,  6 Jun 2009 01:42:46 +0200
Message-Id: <1244245377-17441-28-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Heidelberg <markus.heidelberg@web.de>

They were used as QSplitter::Horizontal resp. QSplitter::Vertical, but
are defined in the 'Qt' namespace.

Fixes the following compiler errors after a quick conversion with 'qt3to4',
which occured with g++ 3.4.6 and 4.1.2, but not anymore with 4.3.2.

scripts/kconfig/qconf.cc: In constructor 'ConfigSearchWindow::ConfigSearchWindow(ConfigMainWindow*, const char*)':
scripts/kconfig/qconf.cc:1213: error: 'Vertical' is not a member of 'QSplitter'

scripts/kconfig/qconf.cc: In constructor 'ConfigMainWindow::ConfigMainWindow()':
scripts/kconfig/qconf.cc:1304: error: 'Horizontal' is not a member of 'QSplitter'
scripts/kconfig/qconf.cc:1311: error: 'Vertical' is not a member of 'QSplitter'

Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/qconf.cc |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 2bd6ed0..7433dac 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -1199,7 +1199,7 @@ ConfigSearchWindow::ConfigSearchWindow(ConfigMainWindow* parent, const char *nam
 	layout1->addLayout(layout2);
 
 	split = new QSplitter(this);
-	split->setOrientation(QSplitter::Vertical);
+	split->setOrientation(Qt::Vertical);
 	list = new ConfigView(split, name);
 	list->list->mode = listMode;
 	info = new ConfigInfoView(split, name);
@@ -1290,14 +1290,14 @@ ConfigMainWindow::ConfigMainWindow(void)
 		move(x, y);
 
 	split1 = new QSplitter(this);
-	split1->setOrientation(QSplitter::Horizontal);
+	split1->setOrientation(Qt::Horizontal);
 	setCentralWidget(split1);
 
 	menuView = new ConfigView(split1, "menu");
 	menuList = menuView->list;
 
 	split2 = new QSplitter(split1);
-	split2->setOrientation(QSplitter::Vertical);
+	split2->setOrientation(Qt::Vertical);
 
 	// create config tree
 	configView = new ConfigView(split2, "config");
-- 
1.6.3.rc3.40.g75b44

