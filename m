Return-Path: <linux-kernel-owner+w=401wt.eu-S1755641AbZEQXjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbZEQXjQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 19:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbZEQXg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 19:36:56 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:43799 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034AbZEQXgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 19:36:48 -0400
From: Markus Heidelberg <markus.heidelberg@web.de>
To: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Markus Heidelberg <markus.heidelberg@web.de>
Subject: [PATCH resend 06/10] kconfig qconf: fix namespace for Horizontal and Vertical enum values
Date: Mon, 18 May 2009 01:36:50 +0200
Message-Id: <1242603414-9267-7-git-send-email-markus.heidelberg@web.de>
X-Mailer: git-send-email 1.6.3.1.20.ga30f
In-Reply-To: <1242603414-9267-1-git-send-email-markus.heidelberg@web.de>
References: <1242603414-9267-1-git-send-email-markus.heidelberg@web.de>
X-Provags-ID: V01U2FsdGVkX1+nvQW2vkbs5FxFaBDz4lzWKgxySIcCVbSOcMv3
	LOUScA6pQEly+tMCjc/4ufnK7JPeKkoVFkHAp4s19GvxsTw0kA
	uIxUuUjr43lpLuj9Cb1w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.6.3.1.20.ga30f

