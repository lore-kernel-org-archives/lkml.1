Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbXFLHtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbXFLHtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbXFLHtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:49:10 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:55138 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751279AbXFLHtJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:49:09 -0400
Message-Id: <466E6C46.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 12 Jun 2007 09:49:58 +0200
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: [PATCH] x86: smp-alt-once option is only useful with
	HOTPLUG_CPU
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hence remove its handling in the opposite case.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/i386/kernel/alternative.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

--- linux-2.6.22-rc4/arch/i386/kernel/alternative.c	2007-06-11 18:09:52.000000000 +0200
+++ 2.6.22-rc4-x86-smp-alt/arch/i386/kernel/alternative.c	2007-06-11 09:10:41.000000000 +0200
@@ -5,9 +5,8 @@
 #include <asm/alternative.h>
 #include <asm/sections.h>
 
-static int noreplace_smp     = 0;
-static int smp_alt_once      = 0;
-static int debug_alternative = 0;
+#ifdef CONFIG_HOTPLUG_CPU
+static int smp_alt_once;
 
 static int __init bootonly(char *str)
 {
@@ -15,6 +14,11 @@ static int __init bootonly(char *str)
 	return 1;
 }
 __setup("smp-alt-boot", bootonly);
+#else
+#define smp_alt_once 1
+#endif
+
+static int debug_alternative;
 
 static int __init debug_alt(char *str)
 {
@@ -23,6 +27,8 @@ static int __init debug_alt(char *str)
 }
 __setup("debug-alternative", debug_alt);
 
+static int noreplace_smp;
+
 static int __init setup_noreplace_smp(char *str)
 {
 	noreplace_smp = 1;
@@ -376,8 +382,6 @@ void __init alternative_instructions(voi
 #ifdef CONFIG_HOTPLUG_CPU
 	if (num_possible_cpus() < 2)
 		smp_alt_once = 1;
-#else
-	smp_alt_once = 1;
 #endif
 
 #ifdef CONFIG_SMP



