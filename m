Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbZBJLPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbZBJLPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 06:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbZBJLPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 06:15:25 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:50781 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbZBJLPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 06:15:23 -0500
Message-ID: <499161C3.2070407@in.ibm.com>
Date: Tue, 10 Feb 2009 16:45:15 +0530
From: "Sachin P. Sant" <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: linux-s390@vger.kernel.org
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, Mel Gorman <mel@csn.ul.ie>
Subject: [Patch] [s390] Fix init irq proc build break.
References: <20090210194121.80256b72.sfr@canb.auug.org.au> <4991573C.8000609@in.ibm.com>
In-Reply-To: <4991573C.8000609@in.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------080908080101070106080007"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080908080101070106080007
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

* Embed init_irq_proc(s390) within CONFIG_PROC_FS to fix a build break.

Signed-off-by : Sachin Sant <sachinp@in.ibm.com>
---

Thanks
-Sachin



--------------080908080101070106080007
Content-Type: text/x-patch;
 name="fix-init-irq-proc-build-break-on-s390.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-init-irq-proc-build-break-on-s390.patch"

* Embed init_irq_proc(s390) within CONFIG_PROC_FS to fix a build break.

Signed-off-by : Sachin Sant <sachinp@in.ibm.com>
---

diff -Naurp a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
--- a/arch/s390/kernel/irq.c	2009-02-10 18:30:01.000000000 +0530
+++ b/arch/s390/kernel/irq.c	2009-02-10 19:01:44.000000000 +0530
@@ -95,6 +95,7 @@ asmlinkage void do_softirq(void)
 	local_irq_restore(flags);
 }
 
+#ifdef CONFIG_PROC_FS
 void init_irq_proc(void)
 {
 	struct proc_dir_entry *root_irq_dir;
@@ -102,3 +103,4 @@ void init_irq_proc(void)
 	root_irq_dir = proc_mkdir("irq", NULL);
 	create_prof_cpu_mask(root_irq_dir);
 }
+#endif

--------------080908080101070106080007--
