Return-Path: <linux-kernel-owner+w=401wt.eu-S1762101AbXHALR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762101AbXHALR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 07:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbXHALRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 07:17:18 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:53396 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbXHALRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 07:17:17 -0400
Date: Wed, 1 Aug 2007 13:16:44 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH] fix slown down printk on boot compile error
Message-ID: <20070801111644.GB12124@osiris.boeblingen.de.ibm.com>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731230932.a9459617.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

The slow-down-printk-during-boot patch depends on preset_lpj being
available. That's not the case for architectures that have it's own
calibrate_delay() function.

kernel/sched.c:3840: undefined reference to `preset_lpj'

Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Dave Jones <davej@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 lib/Kconfig.debug |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22/lib/Kconfig.debug
===================================================================
--- linux-2.6.22.orig/lib/Kconfig.debug
+++ linux-2.6.22/lib/Kconfig.debug
@@ -436,7 +436,7 @@ config FORCED_INLINING
 
 config BOOT_PRINTK_DELAY
 	bool "Delay each boot printk message by N milliseconds"
-	depends on DEBUG_KERNEL && PRINTK
+	depends on DEBUG_KERNEL && PRINTK && GENERIC_CALIBRATE_DELAY
 	help
 	  This build option allows you to read kernel boot messages
 	  by inserting a short delay after each one.  The delay is
