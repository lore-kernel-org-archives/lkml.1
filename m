Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbZBRUeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbZBRUeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 15:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbZBRUd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 15:33:56 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:44685 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525AbZBRUdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 15:33:55 -0500
Subject: x86, vmi: TSC going backwards check in vmi clocksource
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Zachary Amsden <zach@vmware.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 18 Feb 2009 12:33:55 -0800
Message-Id: <1234989235.7991.2.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alok N Kataria <akataria@vmware.com>

Similar to the check for TSC going backwards in the TSC clocksource, we also
need this check for VMI clocksource.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Cc: stable@kernel.org
---

 arch/x86/kernel/vmiclock_32.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)


diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
index c4c1f9e..bde106c 100644
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -283,10 +283,13 @@ void __devinit vmi_time_ap_init(void)
 #endif
 
 /** vmi clocksource */
+static struct clocksource clocksource_vmi;
 
 static cycle_t read_real_cycles(void)
 {
-	return vmi_timer_ops.get_cycle_counter(VMI_CYCLES_REAL);
+	cycle_t ret = (cycle_t)vmi_timer_ops.get_cycle_counter(VMI_CYCLES_REAL);
+	return ret >= clocksource_vmi.cycle_last ?
+		ret : clocksource_vmi.cycle_last;
 }
 
 static struct clocksource clocksource_vmi = {


