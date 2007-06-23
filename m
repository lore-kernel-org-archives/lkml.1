Return-Path: <linux-kernel-owner+w=401wt.eu-S1757115AbXFWNac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115AbXFWNac (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbXFWNWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:22:33 -0400
Received: from www.osadl.org ([213.239.205.134]:59324 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758233AbXFWNWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:22:18 -0400
Message-Id: <20070623124031.260485116@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 23 Jun 2007 13:32:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch -mm 25/28] x86_64: restore restore nohpet cmdline
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
--- linux-2.6.22-rc4-mm.orig/arch/i386/kernel/hpet.c	2007-06-23 14:39:00.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/i386/kernel/hpet.c	2007-06-23 14:39:00.000000000 +0200
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

