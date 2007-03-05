Return-Path: <linux-kernel-owner+w=401wt.eu-S933069AbXCELhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069AbXCELhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 06:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933074AbXCELhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 06:37:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48716 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933069AbXCELhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 06:37:38 -0500
Date: Mon, 5 Mar 2007 12:29:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>
Subject: [patch] paravirt: allow NO_HZ, remove NO_IDLE_HZ dependency
Message-ID: <20070305112928.GA27042@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [patch] paravirt: remove NO_IDLE_HZ dependency
From: Ingo Molnar <mingo@elte.hu>

PARAVIRT forces CONFIG_NO_HZ off - this is bad and prevents sane 
paravirtual guests like KVM from being able to use dynticks-enabled 
Linux guests. Remove this. Vmi-timer needs to be updated properly to 
make use of dynticks.

furthermore, remove the mistaken turning on of NO_IDLE_HZ on 
x86+PARAVIRT kernels, it's an obsolete, limited form of dynticks.

must-have for v2.6.21.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/i386/Kconfig |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

Index: linux/arch/i386/Kconfig
===================================================================
--- linux.orig/arch/i386/Kconfig
+++ linux/arch/i386/Kconfig
@@ -224,7 +224,7 @@ config PARAVIRT
 
 config VMI
 	bool "VMI Paravirt-ops support"
-	depends on PARAVIRT && !NO_HZ
+	depends on PARAVIRT
 	default y
 	help
 	  VMI provides a paravirtualized interface to multiple hypervisors
@@ -1291,12 +1291,3 @@ config X86_TRAMPOLINE
 config KTIME_SCALAR
 	bool
 	default y
-
-config NO_IDLE_HZ
-	bool
-	depends on PARAVIRT
-	default y
-	help
-	  Switches the regular HZ timer off when the system is going idle.
-	  This helps a hypervisor detect that the Linux system is idle,
-	  reducing the overhead of idle systems.
