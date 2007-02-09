Return-Path: <linux-kernel-owner+w=401wt.eu-S1946546AbXBIPnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946546AbXBIPnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946550AbXBIPep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:34:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:2693 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946561AbXBIPej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:34:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=MxMbB/EwRR9KMZzBxkGEtx7y42HXarpIoik7hO42FeJTthcWco1wCtH2B4AWP/x4+lKlPK8oSW6X7beiWiBVpOCWIbnIzFOlHVdZ+GUBhUcsQbTaik2mpTl7BoBVS8wpXxCgf6U8fAOoLCJDd/GVBxujrgnik5RadTlowi7Tv2s=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
Subject: [PATCH 14/34] __initdata cleanup - s390
Date: Fri, 9 Feb 2007 17:22:04 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091722.04603.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

**NOT TESTED***

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/arch/s390/kernel/setup.c linux-2.6.20-rc6-mm3/arch/s390/kernel/setup.c
--- linux-2.6.20-rc6-mm3.org/arch/s390/kernel/setup.c
+++ linux-2.6.20-rc6-mm3/arch/s390/kernel/setup.c
@@ -74,9 +74,9 @@ unsigned int console_devno = -1;
 unsigned int console_irq = -1;
 unsigned long machine_flags = 0;
 
-struct mem_chunk __initdata memory_chunk[MEMORY_CHUNKS];
+struct mem_chunk __initdata memory_chunk[MEMORY_CHUNKS] = {{0}};
 volatile int __cpu_logical_map[NR_CPUS]; /* logical cpu to cpu address */
-static unsigned long __initdata memory_end;
+static unsigned long __initdata memory_end = 0l;
 
 /*
  * This is set up by the setup-routine at boot-time
diff -urNp linux-2.6.20-rc6-mm3.org/arch/s390/kernel/smp.c linux-2.6.20-rc6-mm3/arch/s390/kernel/smp.c
--- linux-2.6.20-rc6-mm3.org/arch/s390/kernel/smp.c
+++ linux-2.6.20-rc6-mm3/arch/s390/kernel/smp.c
@@ -603,8 +603,8 @@ __cpu_up(unsigned int cpu)
 	return 0;
 }
 
-static unsigned int __initdata additional_cpus;
-static unsigned int __initdata possible_cpus;
+static unsigned int __initdata additional_cpus = 0;
+static unsigned int __initdata possible_cpus = 0;
 
 void __init smp_setup_cpu_possible_map(void)
 {
diff -urNp linux-2.6.20-rc6-mm3.org/drivers/s390/block/xpram.c linux-2.6.20-rc6-mm3/drivers/s390/block/xpram.c
--- linux-2.6.20-rc6-mm3.org/drivers/s390/block/xpram.c
+++ linux-2.6.20-rc6-mm3/drivers/s390/block/xpram.c
@@ -63,7 +63,7 @@ static int xpram_devs;
  * Parameter parsing functions.
  */
 static int __initdata devs = XPRAM_DEVS;
-static char __initdata *sizes[XPRAM_MAX_DEVS];
+static char __initdata *sizes[XPRAM_MAX_DEVS] = {0};
 
 module_param(devs, int, 0);
 module_param_array(sizes, charp, NULL, 0);
