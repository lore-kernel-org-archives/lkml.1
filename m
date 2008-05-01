Return-Path: <linux-kernel-owner+w=401wt.eu-S932546AbYEAWvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546AbYEAWvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbYEAWvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:51:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61767 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933AbYEAWvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:51:10 -0400
Date: Thu, 1 May 2008 18:51:09 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: akpm@osdl.org, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       Andrew Sharp <andy.sharp@onstor.com>
Subject: [PATCH] fix irq flags in rtc-ds1511
Message-ID: <Pine.LNX.4.58.0805011850120.12785@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The file in drivers/rtc/rtc-ds1551.c uses "int" for flags. This can
cause hard to find bugs on some architectures. This patch converts the
flags to use "long" instead.

This bug was discovered by doing an allyesconfig make on the -rt kernel
where checks are done to ensure all flags are of size sizeof(long).

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 drivers/rtc/rtc-ds1511.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-compile.git/drivers/rtc/rtc-ds1511.c
===================================================================
--- linux-compile.git.orig/drivers/rtc/rtc-ds1511.c	2008-05-01 16:58:49.000000000 -0400
+++ linux-compile.git/drivers/rtc/rtc-ds1511.c	2008-05-01 18:41:47.000000000 -0400
@@ -184,7 +184,7 @@ ds1511_wdog_disable(void)
 static int ds1511_rtc_set_time(struct device *dev, struct rtc_time *rtc_tm)
 {
 	u8 mon, day, dow, hrs, min, sec, yrs, cen;
-	unsigned int flags;
+	unsigned long flags;

 	/*
 	 * won't have to change this for a while
@@ -247,7 +247,7 @@ static int ds1511_rtc_set_time(struct de
 static int ds1511_rtc_read_time(struct device *dev, struct rtc_time *rtc_tm)
 {
 	unsigned int century;
-	unsigned int flags;
+	unsigned long flags;

 	spin_lock_irqsave(&ds1511_lock, flags);
 	rtc_disable_update();

