Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbYKYWpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbYKYWpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 17:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYKYWo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 17:44:58 -0500
Received: from vpnflf.ccur.com ([12.192.68.2]:50491 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751386AbYKYWo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 17:44:57 -0500
Date: Tue, 25 Nov 2008 17:44:39 -0500
From: Joe Korty <joe.korty@ccur.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix overbroad /proc/timer_list file permissions
Message-ID: <20081125224439.GA24042@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix overbroad file permissions on /proc/timer_list.

/proc/timer_list has 0644 permissions, this should be 0444.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.28-rc6/kernel/time/timer_list.c
===================================================================
--- 2.6.28-rc6.orig/kernel/time/timer_list.c	2008-11-25 17:32:46.000000000 -0500
+++ 2.6.28-rc6/kernel/time/timer_list.c	2008-11-25 17:33:16.000000000 -0500
@@ -286,7 +286,7 @@
 {
 	struct proc_dir_entry *pe;
 
-	pe = proc_create("timer_list", 0644, NULL, &timer_list_fops);
+	pe = proc_create("timer_list", 0444, NULL, &timer_list_fops);
 	if (!pe)
 		return -ENOMEM;
 	return 0;

