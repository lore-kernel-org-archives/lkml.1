Return-Path: <linux-kernel-owner+w=401wt.eu-S1760656AbZB0VK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760656AbZB0VK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760157AbZB0VJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:09:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52789 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760063AbZB0VJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:09:47 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@rostedt.homelinux.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Don't profile branches in arm's boot decompressor
Date: Fri, 27 Feb 2009 22:09:43 +0100
Message-Id: <1235768983-4830-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes many compile errors for arch/arm/boot/compressed/misc.c of
the type:

	arch/arm/boot/compressed/misc.c:127: error: section attribute cannot be specified for local variables

Fix was suggested by Steven Rostedt in #linux-rt.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Steven Rostedt <rostedt@home.goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>

---
 arch/arm/boot/compressed/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index fbe5eef..0bcc98c 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -89,7 +89,7 @@ LDFLAGS_vmlinux += -p --no-undefined -X \
 
 # Don't allow any static data in misc.o, which
 # would otherwise mess up our GOT table
-CFLAGS_misc.o := -Dstatic=
+CFLAGS_misc.o := -Dstatic= -DDISABLE_BRANCH_PROFILING
 
 $(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/$(HEAD) $(obj)/piggy.o \
 	 	$(addprefix $(obj)/, $(OBJS)) FORCE
-- 
tg: (db50eec..) t/ftrace/fix-PROFILE_ALL_BRANCHES (depends on: tip/master)
