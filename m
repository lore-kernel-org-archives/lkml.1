Return-Path: <linux-kernel-owner+w=401wt.eu-S1752161AbZB1GNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbZB1GNQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 01:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbZB1GM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 01:12:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51129 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbZB1GM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 01:12:58 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@rostedt.homelinux.com>,
       Ingo Molnar <mingo@elte.hu>, Daniel Walker <dwalker@fifo99.com>
Subject: [PATCH] Don't profile branches in arm's boot decompressor
Date: Sat, 28 Feb 2009 07:12:54 +0100
Message-Id: <1235801574-6417-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20090227214403.GD25589@goodmis.org>
References: <20090227214403.GD25589@goodmis.org>
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

The problem is that the branch profiler requires static variables and
arch/arm/boot/compressed/misc.c is compiled with "-Dstatic=".  Anyhow,
there is no big win in profiling boot up code, so simply disable it.

Fix was suggested by Steven Rostedt in #linux-rt.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Steven Rostedt <rostedt@home.goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Daniel Walker <dwalker@fifo99.com>
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
