Return-Path: <linux-kernel-owner+w=401wt.eu-S932262AbXGQOI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbXGQOI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbXGQOHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:07:54 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35911 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760801AbXGQOHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:49 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 05/33] kbuild: avoid environment to set variables used by kbuild
Date: Tue, 17 Jul 2007 16:08:34 +0200
Message-Id: <11846813432300-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11846813433593-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org> <11846813433593-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A few of the variables used by kbuild has fixed naming.
Make sure we do not pick up random values from the environment.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/Makefile.build |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index a525112..3f7b451 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -7,6 +7,22 @@ src := $(obj)
 PHONY := __build
 __build:
 
+# Init all relevant variables used in kbuild files so
+# 1) they have correct type
+# 2) they do not inherit any value from the environment
+obj-y :=
+obj-m :=
+lib-y :=
+lib-m :=
+always :=
+targets :=
+subdir-y :=
+subdir-m :=
+EXTRA_AFLAGS   :=
+EXTRA_CFLAGS   :=
+EXTRA_CPPFLAGS :=
+EXTRA_LDFLAGS  :=
+
 # Read .config if it exist, otherwise ignore
 -include include/config/auto.conf
 
-- 
1.5.0.6

