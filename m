Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbYH0PQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbYH0PQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 11:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbYH0PQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 11:16:24 -0400
Received: from vpnflf.ccur.com ([12.192.68.2]:40542 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752834AbYH0PQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 11:16:24 -0400
Date: Wed, 27 Aug 2008 11:16:13 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] printk timestamp post-boot suppression
Message-ID: <20080827151613.GA10325@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suppress printk timestamping after system boot.

The timestamp printk prefix seems most useful during boot,
where it easily shows where the boot sequence is spending
its time.

Its utility after boot is questionable, since 1) the
timestamp becomes a rather large, unreadable integer,
as the hours, days and weeks go by, and 2) syslog does
a proper TOD timestamp anyways on these later messages,
as they go into /var/log/messages.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.27-rc4-git4/kernel/printk.c
===================================================================
--- 2.6.27-rc4-git4.orig/kernel/printk.c	2008-08-26 16:28:41.000000000 -0400
+++ 2.6.27-rc4-git4/kernel/printk.c	2008-08-26 16:53:11.000000000 -0400
@@ -730,7 +730,7 @@
 			printed_len += 3;
 			new_text_line = 0;
 
-			if (printk_time) {
+			if (printk_time && system_state == SYSTEM_BOOTING) {
 				/* Follow the token with the time */
 				char tbuf[50], *tp;
 				unsigned tlen;
