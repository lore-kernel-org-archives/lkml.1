Return-Path: <linux-kernel-owner+w=401wt.eu-S937322AbXHICXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937322AbXHICXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 22:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760699AbXHICXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 22:23:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46841 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759431AbXHICXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 22:23:08 -0400
Message-ID: <46BA7A9E.1090802@cn.fujitsu.com>
Date: Thu, 09 Aug 2007 11:23:26 +0900
From: Miao Xie <miaox@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] timer:Remove clockevents_unregister_notifier
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

   I find a function(clockevents_unregister_notifier) which is not
called by anything in tree.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

diff -urN linux-2.6.23-rc2.orig/kernel/time/clockevents.c linux-2.6.23-rc2/kernel/time/clockevents.c
--- linux-2.6.23-rc2.orig/kernel/time/clockevents.c	2007-08-08 13:20:38.000000000 +0800
+++ linux-2.6.23-rc2/kernel/time/clockevents.c	2007-08-08 13:45:31.000000000 +0800
@@ -113,16 +113,6 @@
 	return ret;
 }
 
-/**
- * clockevents_unregister_notifier - unregister a clock events change listener
- */
-void clockevents_unregister_notifier(struct notifier_block *nb)
-{
-	spin_lock(&clockevents_lock);
-	raw_notifier_chain_unregister(&clockevents_chain, nb);
-	spin_unlock(&clockevents_lock);
-}
-
 /*
  * Notify about a clock event change. Called with clockevents_lock
  * held.

diff -urN linux-2.6.23-rc2.orig/include/linux/clockchips.h linux-2.6.23-rc2/include/linux/clockchips.h
--- linux-2.6.23-rc2.orig/include/linux/clockchips.h	2007-08-08 13:20:29.000000000 +0800
+++ linux-2.6.23-rc2/include/linux/clockchips.h	2007-08-08 13:46:06.000000000 +0800
@@ -123,7 +123,6 @@
 extern void clockevents_set_mode(struct clock_event_device *dev,
 				 enum clock_event_mode mode);
 extern int clockevents_register_notifier(struct notifier_block *nb);
-extern void clockevents_unregister_notifier(struct notifier_block *nb);
 extern int clockevents_program_event(struct clock_event_device *dev,
 				     ktime_t expires, ktime_t now);
 



