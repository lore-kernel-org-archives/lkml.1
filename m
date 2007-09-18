Return-Path: <linux-kernel-owner+w=401wt.eu-S1761445AbXIRRoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761445AbXIRRoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759709AbXIRRoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:44:12 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42296 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760442AbXIRRoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:44:10 -0400
Date: Tue, 18 Sep 2007 18:44:08 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jason.wessel@windriver.com
Subject: Re: 2.6.23-rc6-mm1
Message-ID: <20070918174408.GC1804@skynet.ie>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070918011841.2381bd93.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

IA64 failed to build in kgdb with the messages

arch/ia64/kernel/kgdb.c: In function 'kgdb_arch_set_breakpoint':
arch/ia64/kernel/kgdb.c:555: warning: large integer implicitly truncated to unsigned type
arch/ia64/kernel/kgdb.c: At top level:
arch/ia64/kernel/kgdb.c:673: error: static declaration of 'kgdb_hwbreak_sstep' follows non-static declaration
include/asm/kgdb.h:33: error: previous declaration of 'kgdb_hwbreak_sstep' was here
make[1]: *** [arch/ia64/kernel/kgdb.o] Error 1
make: *** [arch/ia64/kernel] Error 2
make: *** Waiting for unfinished jobs....

It's buried in git-kgdb.patch and I've cc'd who might be the owner. A candidate
fix is below. The build error seems to be a simple case of a badly placed
static. The warning about large integer truncating does not have an obvious
fix and I didn't want to hide the warning with a real bug.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>

---
 kgdb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.23-rc6-mm1-010_fix_ehea_main/arch/ia64/kernel/kgdb.c linux-2.6.23-rc6-mm1-015_fix_ia64_kgdb/arch/ia64/kernel/kgdb.c
--- linux-2.6.23-rc6-mm1-010_fix_ehea_main/arch/ia64/kernel/kgdb.c	2007-09-18 11:29:26.000000000 +0100
+++ linux-2.6.23-rc6-mm1-015_fix_ia64_kgdb/arch/ia64/kernel/kgdb.c	2007-09-18 17:33:36.000000000 +0100
@@ -670,7 +670,7 @@ void kgdb_roundup_cpus(unsigned long fla
 		smp_send_nmi_allbutself();
 }
 
-static volatile int kgdb_hwbreak_sstep[NR_CPUS];
+volatile int kgdb_hwbreak_sstep[NR_CPUS];
 
 static int kgdb_notify(struct notifier_block *self, unsigned long cmd,
 	void *ptr)
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
