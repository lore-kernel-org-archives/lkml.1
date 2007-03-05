Return-Path: <linux-kernel-owner+w=401wt.eu-S933236AbXCEMOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236AbXCEMOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 07:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933266AbXCEMOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 07:14:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55466 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933236AbXCEMOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 07:14:37 -0500
Date: Mon, 5 Mar 2007 13:06:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Andi Kleen <ak@suse.de>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch] paravirt: VDSO page is essential
Message-ID: <20070305120631.GA14105@elte.hu>
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

Subject: [patch] paravirt: VDSO page is essential
From: Ingo Molnar <mingo@elte.hu>

commit 3bbf54725467d604698721384d858b5983b87e8f disables the VDSO for 
CONFIG_PARAVIRT kernels. This #ifdeffery was a bad change: the VDSO is 
an essential component of Linux, and this change forces all of them to 
use int $0x80 - including sane ones like KVM. (If a hypervisor does not 
handle the VDSO properly then it can work things around via the vdso=0 
boot option. Or CONFIG_PARAVIRT should not have been merged. But in any 
case, it is a basic taste issue: we DO NOT #ifdef around core features 
like this!)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/i386/kernel/sysenter.c |    4 ----
 1 file changed, 4 deletions(-)

Index: linux/arch/i386/kernel/sysenter.c
===================================================================
--- linux.orig/arch/i386/kernel/sysenter.c
+++ linux/arch/i386/kernel/sysenter.c
@@ -27,11 +27,7 @@
  * Should the kernel map a VDSO page into processes and pass its
  * address down to glibc upon exec()?
  */
-#ifdef CONFIG_PARAVIRT
-unsigned int __read_mostly vdso_enabled = 0;
-#else
 unsigned int __read_mostly vdso_enabled = 1;
-#endif
 
 EXPORT_SYMBOL_GPL(vdso_enabled);
 
