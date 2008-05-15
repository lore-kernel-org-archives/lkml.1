Return-Path: <linux-kernel-owner+w=401wt.eu-S1757424AbYEOBis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbYEOBis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 21:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYEOBhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 21:37:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33416 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbYEOBhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 21:37:06 -0400
Message-Id: <20080515013705.333772641@goodmis.org>
References: <20080515013028.056366414@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 14 May 2008 21:30:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       pq@iki.fi, proski@gnu.org, sandmann@redhat.com, a.p.zijlstra@chello.nl,
       linux-kbuild@vger.kernel.org, zippel@linux-m68k.org,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/4] ftrace: use the new kbuild CFLAGS_REMOVE for lib directory
Content-Disposition: inline; filename=ftrace-cflags-remove-lib.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the Makefile turd and uses the nice CFLAGS_REMOVE macro
in the lib directory.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/Makefile |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-sched-devel.git/lib/Makefile
===================================================================
--- linux-sched-devel.git.orig/lib/Makefile	2008-05-14 18:24:01.000000000 -0700
+++ linux-sched-devel.git/lib/Makefile	2008-05-14 18:24:13.000000000 -0700
@@ -10,11 +10,11 @@ lib-y := ctype.o string.o vsprintf.o cmd
 
 ifdef CONFIG_FTRACE
 # Do not profile string.o, since it may be used in early boot or vdso
+CFLAGS_REMOVE_string.o = -pg
 # Also do not profile any debug utilities
-ORIG_CFLAGS := $(KBUILD_CFLAGS)
-KBUILD_CFLAGS = $(if $(filter-out %debug debug% string%,$(basename $(notdir $@))), \
-	$(ORIG_CFLAGS), \
-	$(subst -pg,,$(ORIG_CFLAGS)))
+CFLAGS_REMOVE_spinlock_debug.o = -pg
+CFLAGS_REMOVE_list_debug.o = -pg
+CFLAGS_REMOVE_debugobjects.o = -pg
 endif
 
 lib-$(CONFIG_MMU) += ioremap.o

-- 
