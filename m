Return-Path: <linux-kernel-owner+w=401wt.eu-S932566AbXCENzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566AbXCENzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:55:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932642AbXCENzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:55:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54049 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932566AbXCENzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:55:11 -0500
Date: Mon, 5 Mar 2007 14:46:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: [patch] paravirt: re-enable COMPAT_VDSO
Message-ID: <20070305134630.GB30315@elte.hu>
References: <20070305120631.GA14105@elte.hu> <1173101297.26165.39.camel@localhost.localdomain> <20070305143437.GF22829@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305143437.GF22829@bingen.suse.de>
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

Subject: [patch] paravirt: re-enable COMPAT_VDSO
From: Ingo Molnar <mingo@elte.hu>

CONFIG_PARAVIRT broke old glibc bootup: it silently turned off the 
selectability of CONFIG_COMPAT_VDSO and thus rendered distro kernels 
unbootable on old-style VDSO glibc setups.

the proper solution is to keep COMPAT_VDSO available - if a hypervisor 
needs any modification of that concept then we'll judge those changes in 
full context, once those changes are submitted.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/i386/Kconfig |    1 -
 1 file changed, 1 deletion(-)

Index: linux/arch/i386/Kconfig
===================================================================
--- linux.orig/arch/i386/Kconfig
+++ linux/arch/i386/Kconfig
@@ -897,7 +897,6 @@ config HOTPLUG_CPU
 config COMPAT_VDSO
 	bool "Compat VDSO support"
 	default y
-	depends on !PARAVIRT
 	help
 	  Map the VDSO to the predictable old-style address too.
 	---help---
