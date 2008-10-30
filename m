Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbYJ3XaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbYJ3XaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 19:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbYJ3X3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 19:29:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60920 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbYJ3X3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 19:29:51 -0400
Date: Fri, 31 Oct 2008 00:29:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] core kernel fixes
Message-ID: <20081030232936.GA14280@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Suresh Siddha (1):
      resources: fix x86info results ioremap.c:226 __ioremap_caller+0xf2/0x2d6() WARNINGs


 kernel/resource.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 7fec0e4..6aac5c6 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -17,6 +17,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/device.h>
+#include <linux/pfn.h>
 #include <asm/io.h>
 
 
@@ -849,7 +850,8 @@ int iomem_map_sanity_check(resource_size_t addr, unsigned long size)
 			continue;
 		if (p->end < addr)
 			continue;
-		if (p->start <= addr && (p->end >= addr + size - 1))
+		if (PFN_DOWN(p->start) <= PFN_DOWN(addr) &&
+		    PFN_DOWN(p->end) >= PFN_DOWN(addr + size - 1))
 			continue;
 		printk(KERN_WARNING "resource map sanity check conflict: "
 		       "0x%llx 0x%llx 0x%llx 0x%llx %s\n",
