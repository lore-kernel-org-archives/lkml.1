Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbYJGKUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbYJGKUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbYJGKUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:20:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42024 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYJGKUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:20:45 -0400
Date: Tue, 7 Oct 2008 12:20:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: [PATCH] Fix documentation of sysrq-q
Message-ID: <20081007102044.GA25693@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix documentation of sysrq-q

I fell into the trap recently that it only dumps hrtimers instead of 
all timers. Fix the documentation.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.27-rc6-misc/Documentation/sysrq.txt
===================================================================
--- linux-2.6.27-rc6-misc.orig/Documentation/sysrq.txt
+++ linux-2.6.27-rc6-misc/Documentation/sysrq.txt
@@ -95,7 +95,8 @@ On all -  write a character to /proc/sys
 
 'p'     - Will dump the current registers and flags to your console.
 
-'q'     - Will dump a list of all running timers.
+'q'     - Will dump a list of all running hrtimers.
+	  WARNING: Does not cover any other timers
 
 'r'     - Turns off keyboard raw mode and sets it to XLATE.
 
Index: linux-2.6.27-rc6-misc/drivers/char/sysrq.c
===================================================================
--- linux-2.6.27-rc6-misc.orig/drivers/char/sysrq.c
+++ linux-2.6.27-rc6-misc/drivers/char/sysrq.c
@@ -167,7 +167,7 @@ static void sysrq_handle_show_timers(int
 static struct sysrq_key_op sysrq_show_timers_op = {
 	.handler	= sysrq_handle_show_timers,
 	.help_msg	= "show-all-timers(Q)",
-	.action_msg	= "Show Pending Timers",
+	.action_msg	= "Show pending hrtimers (no others)",
 };
 
 static void sysrq_handle_mountro(int key, struct tty_struct *tty)
