Return-Path: <linux-kernel-owner+w=401wt.eu-S1762949AbZLQAPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762949AbZLQAPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758207AbZLQAPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:15:44 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:52700 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZLQAPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:15:44 -0500
Date: Thu, 17 Dec 2009 11:15:42 +1100
From: Simon Horman <horms@verge.net.au>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] timers: Remove duplicate setting of new_base in
 __mod_timer()
Message-ID: <20091217001542.GD25317@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

new_base is set using per_cpu(tvec_bases, cpu) after selecting the desired
value of cpu immediately below so this line is a unnecessary.

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c	2009-12-17 07:02:57.000000000 +0900
+++ linux-2.6/kernel/timer.c	2009-12-17 07:03:17.000000000 +0900
@@ -656,8 +656,6 @@ __mod_timer(struct timer_list *timer, un
 
 	debug_activate(timer, expires);
 
-	new_base = __get_cpu_var(tvec_bases);
-
 	cpu = smp_processor_id();
 
 #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
