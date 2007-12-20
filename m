Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbXLTExN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbXLTExN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 23:53:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbXLTEw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 23:52:59 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:43801 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbXLTEw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 23:52:58 -0500
Date: Wed, 19 Dec 2007 20:57:02 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: not needed patch
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Message-id: <200712192057.02500.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo.

commit fbdcf18df73758b2e187ab94678b30cd5f6ff9f9  is not needed. 
another patch  (by you !! commit 699d934d5f958d7944d195c03c334f28cc0b3669  x86: fixup cpu_info array conversion)
already removed clearing of c->cpu_index. in identify_cpu

also it is not consisent to smpboot_32.c. (it will assign id to cpu_index right after 
 	*c = boot_cpu_data;
)

by revert commit fbdcf18df73758b2e187ab94678b30cd5f6ff9f9, we could use c->cpu_index in identify_cpu.

YH

commit fbdcf18df73758b2e187ab94678b30cd5f6ff9f9
Author: Mike Travis <travis@sgi.com>
Date:   Wed Dec 19 23:20:19 2007 +0100

    x86: fix show cpuinfo cpu number always zero
    
    when called by setup_arch) after smp_store_cpu_info() had set it to the
    correct value.
    
    The error shows up in 'cat /proc/cpuinfo' will all cpus = 0.
    
    Signed-off-by: Mike Travis <travis@sgi.com>
    Cc: Andi Kleen <ak@suse.de>
    Cc: Christoph Lameter <clameter@sgi.com>
    Cc: Jack Steiner <steiner@sgi.com>
    Cc: Suresh B Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 500670c..5948895 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -141,8 +141,8 @@ static void __cpuinit smp_store_cpu_info(int id)
 	struct cpuinfo_x86 *c = &cpu_data(id);
 
 	*c = boot_cpu_data;
-	c->cpu_index = id;
 	identify_cpu(c);
+	c->cpu_index = id;
 	print_cpu_info(c);
 }
 
