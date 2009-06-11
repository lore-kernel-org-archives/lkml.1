Return-Path: <linux-kernel-owner+w=401wt.eu-S1761526AbZFKKAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761526AbZFKKAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761080AbZFKKAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:00:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:54750 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760297AbZFKKAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:00:21 -0400
Subject: [PATCH 1/2 -tip] x86: perf_counter check AMD performance
 monitoring support
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 15:28:09 +0530
Message-Id: <1244714289.6923.0.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


AMD supports performance monitoring from K7.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/perf_counter.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 57ae1be..719a7d5 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1452,6 +1452,10 @@ static int intel_pmu_init(void)
 
 static int amd_pmu_init(void)
 {
+	/* performance-monitoring supported from K7 */
+	if (boot_cpu_data.x86 < 6)
+		return -ENODEV;
+
 	x86_pmu = amd_pmu;
 
 	switch (boot_cpu_data.x86) {
-- 
1.6.0.6



