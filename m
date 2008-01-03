Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbYACPn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbYACPn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbYACPmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:42:22 -0500
Received: from ns2.suse.de ([195.135.220.15]:44483 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbYACPmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:42:18 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103442.621670000@suse.de>
In-Reply-To: <20080103442.621670000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH x86] [3/16] Turn irq debugging options into module params
Message-Id: <20080103154216.D5C2514DDB@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:42:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This allows to change them at runtime using sysfs. No need to 
reboot to set them.

I only added aliases (kernel.noirqdebug etc.) so the old options 
still work.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 kernel/irq/spurious.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux/kernel/irq/spurious.c
===================================================================
--- linux.orig/kernel/irq/spurious.c
+++ linux/kernel/irq/spurious.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/kallsyms.h>
 #include <linux/interrupt.h>
+#include <linux/moduleparam.h>
 
 static int irqfixup __read_mostly;
 
@@ -225,6 +226,8 @@ int noirqdebug_setup(char *str)
 }
 
 __setup("noirqdebug", noirqdebug_setup);
+module_param(noirqdebug, bool, 0644);
+MODULE_PARM_DESC(noirqdebug, "Disable irq lockup detection when true");
 
 static int __init irqfixup_setup(char *str)
 {
@@ -236,6 +239,8 @@ static int __init irqfixup_setup(char *s
 }
 
 __setup("irqfixup", irqfixup_setup);
+module_param(irqfixup, int, 0644);
+MODULE_PARM_DESC("irqfixup", "0: No fixup, 1: irqfixup mode 2: irqpoll mode");
 
 static int __init irqpoll_setup(char *str)
 {
