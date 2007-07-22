Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbXGVArN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbXGVArN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 20:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbXGVAq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 20:46:58 -0400
Received: from ozlabs.org ([203.10.76.45]:42789 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbXGVAq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 20:46:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18082.43262.487474.356610@cargo.ozlabs.ibm.com>
Date: Sun, 22 Jul 2007 10:46:54 +1000
From: Paul Mackerras <paulus@samba.org>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Don't compile the PMU power driver on 64-bit PowerPC
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As reported by Stephen Rothwell, an allmodconfig build on 64-bit
PowerPC reports these errors:

ERROR: "pmu_batteries" [drivers/power/pmu_battery.ko] undefined!
ERROR: "pmu_battery_count" [drivers/power/pmu_battery.ko] undefined!
ERROR: "pmu_power_flags" [drivers/power/pmu_battery.ko] undefined!

This fixes the problem by not building pmu_battery.ko on ppc64.  There
are no battery-powered ppc64 machines with an Apple PMU, and we can be
reasonably confident there never will be.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 3f6e176..58c806e 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -38,7 +38,7 @@ config BATTERY_DS2760
 
 config BATTERY_PMU
 	tristate "Apple PMU battery"
-	depends on ADB_PMU
+	depends on PPC32 && ADB_PMU
 	help
 	  Say Y here to expose battery information on Apple machines
 	  through the generic battery class.
