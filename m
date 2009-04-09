Return-Path: <linux-kernel-owner+w=401wt.eu-S933551AbZDINQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551AbZDINQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 09:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757290AbZDINP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 09:15:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:42190 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003AbZDINPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 09:15:55 -0400
Subject: [PATCH -tip] x86: tsc.c rename tsc_khz shadow variable
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Alok Kataria <akataria@vmware.com>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 18:45:35 +0530
Message-Id: <1239282935.11859.23.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix sparse warning:
  arch/x86/kernel/tsc.c:387:50: warning: symbol 'tsc_khz' shadows an earlier one
  arch/x86/kernel/tsc.c:24:1: originally declared here

rename tsc_khz local variable to hv_tsc_khz to avoid shadow

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/tsc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 7a567eb..a8dc0d0 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -384,13 +384,13 @@ unsigned long native_calibrate_tsc(void)
 {
 	u64 tsc1, tsc2, delta, ref1, ref2;
 	unsigned long tsc_pit_min = ULONG_MAX, tsc_ref_min = ULONG_MAX;
-	unsigned long flags, latch, ms, fast_calibrate, tsc_khz;
+	unsigned long flags, latch, ms, fast_calibrate, hv_tsc_khz;
 	int hpet = is_hpet_enabled(), i, loopmin;
 
-	tsc_khz = get_hypervisor_tsc_freq();
-	if (tsc_khz) {
+	hv_tsc_khz = get_hypervisor_tsc_freq();
+	if (hv_tsc_khz) {
 		printk(KERN_INFO "TSC: Frequency read from the hypervisor\n");
-		return tsc_khz;
+		return hv_tsc_khz;
 	}
 
 	local_irq_save(flags);
-- 
1.6.0.6



