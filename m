Return-Path: <linux-kernel-owner+w=401wt.eu-S1760126AbYBEUlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126AbYBEUlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761270AbYBEUlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:41:04 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:24457 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761262AbYBEUlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:41:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bFHfnCl6BnVQbcOHCeRuINwm+JEUF8nIbRn/xJDMq87+vTVTShSGq3glOm67iUwmmzFG2C7P8OSlyLf161P1TMjL/I9mS4cbuu9Y2YllQSD+zu7wWkQwXx3qZMJtaEPVdNHdQPaVxllIttbFrasbsKXqRrzrYrPG13qDvidZpQI=
Subject: [PATCH 3/8] x86: dubious one-bit signed bitfield in cpuidle.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 12:40:58 -0800
Message-Id: <1202244058.18081.32.camel@brick>
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


