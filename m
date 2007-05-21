Return-Path: <linux-kernel-owner+w=401wt.eu-S1765407AbXEUTVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765407AbXEUTVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764814AbXEUTVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:21:05 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46204 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764313AbXEUTVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:21:02 -0400
Message-Id: <20070521191756.528589000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:17:18 -0700
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
Subject: [patch 66/69] CPUFREQ: Support rev H AMD64s in powernow-k8
Content-Disposition: inline; filename=support-rev-h-amd64s-in-powernow-k8.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Dave Jones <davej@redhat.com>

---
 arch/i386/kernel/cpu/cpufreq/powernow-k8.c |    2 +-
 arch/i386/kernel/cpu/cpufreq/powernow-k8.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.21.1.orig/arch/i386/kernel/cpu/cpufreq/powernow-k8.c
+++ linux-2.6.21.1/arch/i386/kernel/cpu/cpufreq/powernow-k8.c
@@ -521,7 +521,7 @@ static int check_supported_cpu(unsigned 
 
 	if ((eax & CPUID_XFAM) == CPUID_XFAM_K8) {
 		if (((eax & CPUID_USE_XFAM_XMOD) != CPUID_USE_XFAM_XMOD) ||
-		    ((eax & CPUID_XMOD) > CPUID_XMOD_REV_G)) {
+		    ((eax & CPUID_XMOD) > CPUID_XMOD_REV_H)) {
 			printk(KERN_INFO PFX "Processor cpuid %x not supported\n", eax);
 			goto out;
 		}
--- linux-2.6.21.1.orig/arch/i386/kernel/cpu/cpufreq/powernow-k8.h
+++ linux-2.6.21.1/arch/i386/kernel/cpu/cpufreq/powernow-k8.h
@@ -46,8 +46,8 @@ struct powernow_k8_data {
 #define CPUID_XFAM			0x0ff00000	/* extended family */
 #define CPUID_XFAM_K8			0
 #define CPUID_XMOD			0x000f0000	/* extended model */
-#define CPUID_XMOD_REV_G		0x00060000
-#define CPUID_XFAM_10H 			0x00100000	/* family 0x10 */
+#define CPUID_XMOD_REV_H		0x00070000
+#define CPUID_XFAM_10H			0x00100000	/* family 0x10 */
 #define CPUID_USE_XFAM_XMOD		0x00000f00
 #define CPUID_GET_MAX_CAPABILITIES	0x80000000
 #define CPUID_FREQ_VOLT_CAPABILITIES	0x80000007

-- 
