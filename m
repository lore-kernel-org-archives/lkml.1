Return-Path: <linux-kernel-owner+w=401wt.eu-S934665AbXEUTiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934665AbXEUTiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765435AbXEUTWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:22:37 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46540 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765562AbXEUTWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:22:35 -0400
Message-Id: <20070521191756.918560000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:17:19 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 67/69] CPUFREQ: Correct revision mask for powernow-k8
Content-Disposition: inline; filename=correct-revision-mask-for-powernow-k8.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Dave Jones <davej@redhat.com>

Mark Langsdorf points out that the correct define for this
revision bump is 0x80000.  Also to save us having to keep
renaming the #define, give it a more meaningful name.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/i386/kernel/cpu/cpufreq/powernow-k8.c |    2 +-
 arch/i386/kernel/cpu/cpufreq/powernow-k8.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/i386/kernel/cpu/cpufreq/powernow-k8.c b/arch/i386/kernel/cpu/cpufreq/powernow-k8.c
index 5c715f1..4ade55c 100644
--- a/arch/i386/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/i386/kernel/cpu/cpufreq/powernow-k8.c
@@ -521,7 +521,7 @@ static int check_supported_cpu(unsigned int cpu)
 
 	if ((eax & CPUID_XFAM) == CPUID_XFAM_K8) {
 		if (((eax & CPUID_USE_XFAM_XMOD) != CPUID_USE_XFAM_XMOD) ||
-		    ((eax & CPUID_XMOD) > CPUID_XMOD_REV_H)) {
+		    ((eax & CPUID_XMOD) > CPUID_XMOD_REV_MASK)) {
 			printk(KERN_INFO PFX "Processor cpuid %x not supported\n", eax);
 			goto out;
 		}
diff --git a/arch/i386/kernel/cpu/cpufreq/powernow-k8.h b/arch/i386/kernel/cpu/cpufreq/powernow-k8.h
index ae2d9da..b06c812 100644
--- a/arch/i386/kernel/cpu/cpufreq/powernow-k8.h
+++ b/arch/i386/kernel/cpu/cpufreq/powernow-k8.h
@@ -46,7 +46,7 @@ struct powernow_k8_data {
 #define CPUID_XFAM			0x0ff00000	/* extended family */
 #define CPUID_XFAM_K8			0
 #define CPUID_XMOD			0x000f0000	/* extended model */
-#define CPUID_XMOD_REV_H		0x00070000
+#define CPUID_XMOD_REV_MASK		0x00080000
 #define CPUID_XFAM_10H			0x00100000	/* family 0x10 */
 #define CPUID_USE_XFAM_XMOD		0x00000f00
 #define CPUID_GET_MAX_CAPABILITIES	0x80000000

-- 
