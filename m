Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbYBECvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbYBECvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 21:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYBECvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 21:51:43 -0500
Received: from hs-out-0708.google.com ([64.233.178.251]:29429 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750884AbYBECvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 21:51:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AMbuha70OvSyMoQcUmk87HQFqnsWzHiLITPzn/JRiBqn0PBdxybY0zdyUVCsR39DssD1tLLMY6TKipMvmfxWgYR0lgYgoPOROrRGaTVidrOcWT8nhcK6cvmSF2gwmUnab3GMkVqzmhxCdc0e4nQVUKpqhP7qhSqYT+6ic2x6M6A=
Subject: [PATCH] x86: dubious one-bit signed bitfield in cpuidle.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 18:51:35 -0800
Message-Id: <1202179895.6452.15.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a minimal, stupid, fix, move to unsigned bitfield.  These errors
are hiding sparse warnings in any file that includes it....below is a
sample.

  CHECK   arch/x86/kernel/acpi/cstate.c
include/linux/cpuidle.h:82:17: error: dubious one-bit signed bitfield
  CHECK   arch/x86/kernel/acpi/processor.c
include/linux/cpuidle.h:82:17: error: dubious one-bit signed bitfield
  CHECK   arch/x86/kernel/cpu/cpufreq/powernow-k7.c
include/linux/cpuidle.h:82:17: error: dubious one-bit signed bitfield
  CHECK   arch/x86/kernel/cpu/cpufreq/powernow-k8.c
include/linux/cpuidle.h:82:17: error: dubious one-bit signed bitfield
  CHECK   arch/x86/kernel/cpu/cpufreq/longhaul.c
include/linux/cpuidle.h:82:17: error: dubious one-bit signed bitfield
  CHECK   arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
include/linux/cpuidle.h:82:17: error: dubious one-bit signed bitfield

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/cpuidle.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index c4e0016..b0fd85a 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -79,7 +79,7 @@ struct cpuidle_state_kobj {
 };
 
 struct cpuidle_device {
-	int			enabled:1;
+	unsigned int		enabled:1;
 	unsigned int		cpu;
 
 	int			last_residency;
-- 
1.5.4.rc5.1138.g2602



