Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbYEOBid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbYEOBid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 21:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYEOBhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 21:37:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33427 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbYEOBhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 21:37:06 -0400
Message-Id: <20080515013705.487397915@goodmis.org>
References: <20080515013028.056366414@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 14 May 2008 21:30:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       pq@iki.fi, proski@gnu.org, sandmann@redhat.com, a.p.zijlstra@chello.nl,
       linux-kbuild@vger.kernel.org, zippel@linux-m68k.org,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/4] ftrace: use the new kbuild CFLAGS_REMOVE for x86/kernel directory
Content-Disposition: inline; filename=ftrace-cflags-remove-x86.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the Makefile turd and uses the nice CFLAGS_REMOVE macro
in the x86/kernel directory.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/Makefile |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-sched-devel.git/arch/x86/kernel/Makefile
===================================================================
--- linux-sched-devel.git.orig/arch/x86/kernel/Makefile	2008-05-14 18:12:21.000000000 -0700
+++ linux-sched-devel.git/arch/x86/kernel/Makefile	2008-05-14 18:24:43.000000000 -0700
@@ -8,10 +8,9 @@ CPPFLAGS_vmlinux.lds += -U$(UTS_MACHINE)
 
 ifdef CONFIG_FTRACE
 # Do not profile debug utilities
-ORIG_CFLAGS := $(KBUILD_CFLAGS)
-KBUILD_CFLAGS = $(if $(filter-out tsc_64 tsc_32 rtc,$(basename $(notdir $@))), \
-	$(ORIG_CFLAGS), \
-	$(subst -pg,,$(ORIG_CFLAGS)))
+CFLAGS_REMOVE_tsc_64.o = -pg
+CFLAGS_REMOVE_tsc_32.o = -pg
+CFLAGS_REMOVE_rtc.o = -pg
 endif
 
 #

-- 
