Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbXFVUrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbXFVUrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 16:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbXFVUrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 16:47:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:46013 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbXFVUrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 16:47:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,452,1175497200"; 
   d="scan'208";a="242277699"
Date: Fri, 22 Jun 2007 13:42:52 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6/7] ICH Force HPET: ICH5 fix a bug with suspend/resume
Message-ID: <20070622204252.GF22807@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



A bugfix in ich5 hpet force detect which caused resumes to fail.
Thanks to Udo A Steinberg for reporting the problem.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/i386/kernel/quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22-rc5/arch/i386/kernel/quirks.c
===================================================================
--- linux-2.6.22-rc5.orig/arch/i386/kernel/quirks.c	2007-06-17 08:52:10.000000000 +0200
+++ linux-2.6.22-rc5/arch/i386/kernel/quirks.c	2007-06-17 08:52:10.000000000 +0200
@@ -199,7 +199,6 @@ static void old_ich_force_enable_hpet(st
 		force_hpet_address = 0xFED00000 | (val << 12);
 		printk(KERN_DEBUG "HPET at base address 0x%lx\n",
 			       force_hpet_address);
-		cached_dev = dev;
 		return;
 	}
 
@@ -221,6 +220,7 @@ static void old_ich_force_enable_hpet(st
 		force_hpet_address = 0xFED00000 | (val << 12);
 		printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
 			       force_hpet_address);
+		cached_dev = dev;
 		force_hpet_resume_type = OLD_ICH_FORCE_HPET_RESUME;
 		return;
 	}
