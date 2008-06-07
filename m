Return-Path: <linux-kernel-owner+w=401wt.eu-S1760315AbYFGBUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760315AbYFGBUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760418AbYFGBJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:31 -0400
Received: from sous-sol.org ([216.99.217.87]:42510 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844AbYFGBJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:23 -0400
Message-Id: <20080607010603.257412553@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:31 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 16/50] i386: fix asm constraint in do_IRQ()
Content-Disposition: inline; filename=i386-fix-asm-constraint-in-do_irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jan Beulich <jbeulich@novell.com>

upstream commit: 5065dbafc299507f16731434e95b91dadff03006

i386: fix asm constraint in do_IRQ()

Two prior changes resulted in the "ecx" clobber being lost.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/irq_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -134,7 +134,7 @@ unsigned int do_IRQ(struct pt_regs *regs
 			: "=a" (arg1), "=d" (arg2), "=b" (bx)
 			:  "0" (irq),   "1" (desc),  "2" (isp),
 			   "D" (desc->handle_irq)
-			: "memory", "cc"
+			: "memory", "cc", "ecx"
 		);
 	} else
 #endif

-- 
