Return-Path: <linux-kernel-owner+w=401wt.eu-S1762857AbYAKXEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762857AbYAKXEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 18:04:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbYAKXEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 18:04:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59226 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759062AbYAKXEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 18:04:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: Change unnecessary dependencies on CONFIG_PM
Date: Sat, 12 Jan 2008 00:06:46 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andi Kleen <ak@suse.de>, Adrian Bunk <bunk@kernel.org>,
       Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
References: <20080103442.621670000@suse.de> <200801101242.53504.ak@suse.de> <200801101817.23522.rjw@sisk.pl>
In-Reply-To: <200801101817.23522.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801120006.47592.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo, this patch applies on top of the mm branch, please add.]
---
From: Rafael J. Wysocki <rjw@sisk.pl>

CONFIG_PM_CPUINIT should depend on CONFIG_PM_SLEEP rather than
on CONFIG_PM, because it only is needed for suspend and
hibernation.  Also, it's not necessary to compile
arch/x86/power/cpu.c if CONFIG_PM_SLEEP is not set, for the same
reason.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/Kconfig        |    2 +-
 arch/x86/power/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -150,7 +150,7 @@ config GENERIC_PENDING_IRQ
 
 config PM_CPUINIT
 	bool
-	depends on PM
+	depends on PM_SLEEP
 	default y
 
 config X86_SMP
Index: linux-2.6/arch/x86/power/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/power/Makefile
+++ linux-2.6/arch/x86/power/Makefile
@@ -1,2 +1,2 @@
-obj-$(CONFIG_PM)		+= cpu.o
+obj-$(CONFIG_PM_SLEEP)		+= cpu.o
 obj-$(CONFIG_HIBERNATION)	+= swsusp.o suspend.o
