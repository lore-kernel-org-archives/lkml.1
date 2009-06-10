Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbZFJSsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbZFJSsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 14:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbZFJSsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 14:48:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:47532 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbZFJSsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 14:48:45 -0400
Subject: [PATCH -tip] x86: perf_counter AMD supports performance monitoring
 for K7
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 00:19:35 +0530
Message-Id: <1244659775.4255.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/perf_counter.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 240ca56..5d56742 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1436,6 +1436,10 @@ static int intel_pmu_init(void)
 
 static int amd_pmu_init(void)
 {
+	/* performance-monitoring supported from K7 */
+	if (boot_cpu_data.x86 < 7)
+		return -ENODEV;
+
 	x86_pmu = amd_pmu;
 
 	switch (boot_cpu_data.x86) {
-- 
1.6.1.1



