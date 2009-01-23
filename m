Return-Path: <linux-kernel-owner+w=401wt.eu-S1762695AbZAWLDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762695AbZAWLDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 06:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759746AbZAWLB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 06:01:28 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:5663 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762264AbZAWLB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 06:01:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=vcBOvtFAcrt322Z72G4xun7wpVSWyan2hAivAX1RbdhPnoXZn+IMF/WMuF/CqO4vux
         8ARHs232Sx5H4+CQYeSJZpN5BT23/LFVxV3eNt98JBNwc96P66x+9kO8zQM24FI3p+GF
         OOUUEhovNfodY5zJd2y3yoXTPQf+3vFl0YjB0=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: johnstul@us.ibm.com, gregkh@suse.de, roel.kluin@gmail.com,
       lethal@linux-sh.org, tglx@linutronix.de,
       Magnus Damm <magnus.damm@gmail.com>, mingo@redhat.com,
       akpm@linux-foundation.org
Date: Fri, 23 Jan 2009 19:59:24 +0900
Message-Id: <20090123105924.18779.63175.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
References: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
Subject: [PATCH 010/011] sh: add early platform support for earlytimer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch adds early platform "earlytimer" class support.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 arch/sh/kernel/time_32.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- 0017/arch/sh/kernel/time_32.c
+++ work/arch/sh/kernel/time_32.c	2009-01-23 16:41:21.000000000 +0900
@@ -218,6 +218,8 @@ unsigned long long sched_clock(void)
 
 void __init time_init(void)
 {
+	int n;
+
 	if (board_time_init)
 		board_time_init();
 
@@ -236,6 +238,15 @@ void __init time_init(void)
 	 * initialized for us.
 	 */
 	sys_timer = get_sys_timer();
+
+	/* Make sure all compiled-in early timers register themselves.
+	 * Run probe() for one "earlytimer" device.
+	 */
+	early_platform_driver_register_all("earlytimer");
+	n = early_platform_driver_probe("earlytimer", 1, 0);
+	if (n)
+		return;
+
 	if (sys_timer)
 		pr_info("Using %s for system timer\n", sys_timer->name);
 	else
