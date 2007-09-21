Return-Path: <linux-kernel-owner+w=401wt.eu-S1764129AbXIUUsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764129AbXIUUsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763138AbXIUUo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:44:56 -0400
Received: from mail.suse.de ([195.135.220.2]:50028 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763051AbXIUUoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:44:54 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [12/45] i386: Fix arch/i386/kernel/nmi.c - 'unknown_nmi_panic_callback' declared 'static' but never defined warning
Message-Id: <20070921204453.A6E6D14F09@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:44:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I get this warning when CONFIG_SYSCTL is not set :

...

arch/i386/kernel/nmi.c:52: warning: 'unknown_nmi_panic_callback' declared 'static' but never defined

...

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---

---
 arch/i386/kernel/nmi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/arch/i386/kernel/nmi.c
===================================================================
--- linux.orig/arch/i386/kernel/nmi.c
+++ linux/arch/i386/kernel/nmi.c
@@ -49,8 +49,9 @@ static unsigned int nmi_hz = HZ;
 static DEFINE_PER_CPU(short, wd_enabled);
 
 /* local prototypes */
+#ifdef CONFIG_SYSCTL
 static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu);
-
+#endif
 static int endflag __initdata = 0;
 
 #ifdef CONFIG_SMP
