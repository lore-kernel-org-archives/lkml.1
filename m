Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbZDTUPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbZDTUPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbZDTUP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:15:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:27031 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483AbZDTUP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:15:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,219,1239001200"; 
   d="scan'208";a="449626031"
Message-Id: <20090420200450.425091000@linux-os.sc.intel.com>
References: <20090420200450.128993000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 20 Apr 2009 13:02:29 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Weidong Han <weidong.han@intel.com>
Subject: [patch 3/5] x2apic, IR: cleanup panic() with nox2apic boot option
Content-Disposition: inline; filename=fix_panic_msg.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of panic() ignore the "nox2apic" boot option when BIOS has
already enabled x2apic prior to OS handover.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Weidong Han <weidong.han@intel.com>
---

Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -142,8 +142,12 @@ static int x2apic_preenabled;
 static int disable_x2apic;
 static __init int setup_nox2apic(char *str)
 {
-	if (x2apic_enabled())
-		panic("Bios already enabled x2apic, can't enforce nox2apic");
+	if (x2apic_enabled()) {
+		pr_warning("Bios already enabled x2apic, "
+			   "can't enforce nox2apic");
+		return 0;
+	}
+
 	disable_x2apic = 1;
 	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 	return 0;

-- 

