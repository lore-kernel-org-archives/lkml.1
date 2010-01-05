Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847Ab0AERDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0AERDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 12:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713Ab0AERC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 12:02:59 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:53991 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab0AERC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 12:02:58 -0500
From: Darren Hart <dvhltc@us.ibm.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: dvhltc@us.ibm.com
Subject: 
Date: Tue,  5 Jan 2010 09:02:31 -0800
Message-Id: <1262710951-6614-1-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   git://git.kernel.org/pub/scm/linux/kernel/git/dvhart/trace-cmd.git for-rostedt/trace-view


>From cacc655df9360e74a02561312da0bb78fdbae38c Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhltc@us.ibm.com>
Date: Tue, 5 Jan 2010 08:53:12 -0800
Subject: [PATCH] trace-view: cleanup python make targets

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---
 Makefile |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index 3d17256..4826dd1 100644
--- a/Makefile
+++ b/Makefile
@@ -129,21 +129,24 @@ plugin_mac80211.so: plugin_mac80211.o
 	$(CC) -shared -nostartfiles -o $@ $<
 
 
-.PHONY: python
-python:	$(TCMD_LIB_OBJS)
+PYTHON_INCLUDES = `python-config --includes`
+PYGTK_CFLAGS = `pkg-config --cflags pygtk-2.0`
+
+ctracecmd.so: $(TCMD_LIB_OBJS)
 	swig -Wall -python -noproxy ctracecmd.i
-	#swig -Wall -python ctracecmd.i
-	gcc -fpic -c  `python-config --includes` ctracecmd_wrap.c
+	gcc -fpic -c $(PYTHON_INCLUDES)  ctracecmd_wrap.c
 	$(CC) --shared $^ ctracecmd_wrap.o -o ctracecmd.so
-	#$(CC) --shared $^ ctracecmd_wrap.o -o _ctracecmd.so
 
-.PHONY: python-gui
-python-gui: $(TRACE_VIEW_OBJS)
+ctracecmdgui.so: $(TRACE_VIEW_OBJS) $(LIB_FILE)
 	swig -Wall -python -noproxy ctracecmdgui.i
-	# FIXME: where do we get the pygtk include from?
-	gcc -fpic -c  `python-config --includes` $(CFLAGS) $(INCLUDES) -I/usr/include/pygtk-2.0/ ctracecmdgui_wrap.c
+	gcc -fpic -c  $(CFLAGS) $(INCLUDES) $(PYTHON_INCLUDES) $(PYGTK_CFLAGS) ctracecmdgui_wrap.c
 	$(CC) --shared $^ $(LIBS) $(CONFIG_LIBS) ctracecmdgui_wrap.o -o ctracecmdgui.so
 
+.PHONY: python
+python: ctracecmd.so
+
+.PHONY: python-gui
+python-gui: ctracecmd.so ctracecmdgui.so 
 
 .PHONY: force
 force:
-- 
1.6.3.3

