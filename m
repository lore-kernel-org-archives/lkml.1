Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933919Ab0CLOYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 09:24:22 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36128 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933212Ab0CLOYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 09:24:21 -0500
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
To: linux@arm.linux.org.uk, mroberto@cpti.cetuc.puc-rio.br
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ARM: mach-sa1100: Fix for compiler warning of uninitialized variable.
Date: Fri, 12 Mar 2010 11:23:46 -0300
Message-Id: <1268403827-16127-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fix for the compiler warning: 'new_ppcr' may be used
uninitialized in this function.

Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
---
 arch/arm/mach-sa1100/cpu-sa1100.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-sa1100/cpu-sa1100.c b/arch/arm/mach-sa1100/cpu-sa1100.c
index ef81787..a98712e 100644
--- a/arch/arm/mach-sa1100/cpu-sa1100.c
+++ b/arch/arm/mach-sa1100/cpu-sa1100.c
@@ -184,16 +184,15 @@ static int sa1100_target(struct cpufreq_policy *policy,
 {
 	unsigned int cur = sa11x0_getspeed(0);
 	unsigned int new_ppcr;
-
 	struct cpufreq_freqs freqs;
+
+	new_ppcr = sa11x0_freq_to_ppcr(target_freq);
 	switch(relation){
 	case CPUFREQ_RELATION_L:
-		new_ppcr = sa11x0_freq_to_ppcr(target_freq);
 		if (sa11x0_ppcr_to_freq(new_ppcr) > policy->max)
 			new_ppcr--;
 		break;
 	case CPUFREQ_RELATION_H:
-		new_ppcr = sa11x0_freq_to_ppcr(target_freq);
 		if ((sa11x0_ppcr_to_freq(new_ppcr) > target_freq) &&
 		    (sa11x0_ppcr_to_freq(new_ppcr - 1) >= policy->min))
 			new_ppcr--;
-- 
1.7.0.1

