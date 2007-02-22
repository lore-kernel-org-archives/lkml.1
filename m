Return-Path: <linux-kernel-owner+w=401wt.eu-S1751501AbXBVInf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbXBVInf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 03:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbXBVInf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 03:43:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56881 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbXBVIne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 03:43:34 -0500
Date: Thu, 22 Feb 2007 09:38:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch] x86: add -freg-struct-return to CFLAGS
Message-ID: <20070222083822.GB15068@elte.hu>
References: <45DCF1C5.4030006@goop.org> <1172131463.3531.226.camel@laptopd505.fenrus.org> <45DD4FA0.5030205@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DD4FA0.5030205@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4910]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [patch] x86: add -freg-struct-return to CFLAGS
From: Ingo Molnar <mingo@elte.hu>

Jeremy Fitzhardinge suggested the use of -freg-struct-return, which does 
structure-returns (such as when using pte_t) in registers instead of on 
the stack.

that is indeed so, and this option reduced the kernel size a bit:

    text    data     bss     dec     hex filename
 4799506  543456 3760128 9103090  8ae6f2 vmlinux.before
 4798117  543456 3760128 9101701  8ae185 vmlinux.after

the resulting kernel booted fine on my testbox. Lets go for it.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/i386/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/Makefile
===================================================================
--- linux.orig/arch/i386/Makefile
+++ linux/arch/i386/Makefile
@@ -31,7 +31,7 @@ LDFLAGS_vmlinux := --emit-relocs
 endif
 CHECKFLAGS	+= -D__i386__
 
-CFLAGS += -pipe -msoft-float -mregparm=3
+CFLAGS += -pipe -msoft-float -mregparm=3 -freg-struct-return
 
 # prevent gcc from keeping the stack 16 byte aligned
 CFLAGS += $(call cc-option,-mpreferred-stack-boundary=2)
