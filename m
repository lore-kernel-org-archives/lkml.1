Return-Path: <linux-kernel-owner+w=401wt.eu-S1759038AbXFJJhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbXFJJhu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 05:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbXFJJb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 05:31:26 -0400
Received: from www.osadl.org ([213.239.205.134]:43131 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754227AbXFJJbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 05:31:12 -0400
Message-Id: <20070610092447.113317867@inhelltoy.tec.linutronix.de>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 10 Jun 2007 09:44:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 20/23] x86_64: restore restore nohpet cmdline
Content-Disposition: inline; filename=x86_64-restore-nohpet-cmdline.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

Lost when merged with i386.  Happy to drop, but I suspect Andi would
rather not break existing users (I noticed because it was part of my
testing).  If dropped, Documentation needs updating.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/hpet.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6.22-rc4-mm/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/i386/kernel/hpet.c	2007-06-10 10:44:39.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/i386/kernel/hpet.c	2007-06-10 10:44:40.000000000 +0200
@@ -89,6 +89,13 @@ static int __init hpet_setup(char* str)
 }
 __setup("hpet=", hpet_setup);
 
+static int __init disable_hpet(char *str)
+{
+	boot_hpet_disable = 1;
+	return 1;
+}
+__setup("nohpet", disable_hpet);
+
 static inline int is_hpet_capable(void)
 {
 	return (!boot_hpet_disable && hpet_address);

-- 

