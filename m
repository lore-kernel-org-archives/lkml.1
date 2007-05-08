Return-Path: <linux-kernel-owner+w=401wt.eu-S934837AbXEHJsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934837AbXEHJsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934653AbXEHJsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:48:10 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:57861 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934655AbXEHJsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:48:06 -0400
Date: Tue, 8 May 2007 02:47:37 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Wright <chrisw@sous-sol.org>, LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/5] x86_64: restore restore nohpet cmdline
Message-ID: <20070508094737.GX3505@sequoia.sous-sol.org>
References: <1178485128.31213.98.camel@localhost.localdomain> <20070507163110.GP3505@sequoia.sous-sol.org> <1178556361.3042.16.camel@localhost.localdomain> <20070508093957.GS3505@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508093957.GS3505@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lost when merged with i386.  Happy to drop, but I suspect Andi would
rather not break existing users (I noticed because it was part of my
testing).  If dropped, Documentation needs updating.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/i386/kernel/hpet.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- tglx.orig/arch/i386/kernel/hpet.c
+++ tglx/arch/i386/kernel/hpet.c
@@ -78,6 +78,14 @@ static int __init hpet_setup(char* str)
 	return 1;
 }
 __setup("hpet=", hpet_setup);
+#ifdef CONFIG_X86_64
+static int __init disable_hpet(char *str)
+{
+	boot_hpet_disable = 1;
+	return 1;
+}
+__setup("nohpet", disable_hpet);
+#endif
 
 static inline int is_hpet_capable(void)
 {
