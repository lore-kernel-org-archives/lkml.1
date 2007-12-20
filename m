Return-Path: <linux-kernel-owner+w=401wt.eu-S932257AbXLTOt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257AbXLTOt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760303AbXLTOs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:48:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:33154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760112AbXLTOs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:48:57 -0500
Date: Thu, 20 Dec 2007 15:40:09 +0100
From: Bernhard Walle <bwalle@suse.de>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, clemens@ladisch.de
Subject: [PATCH] Fix RTC_AIE with CONFIG_HPET_EMULATE_RTC
Message-ID: <20071220144009.GA29859@suse.de>
Mail-Followup-To: akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, clemens@ladisch.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current code, RTC_AIE doesn't work if the RTC relies on
CONFIG_HPET_EMULATE_RTC because the code sets the RTC_AIE flag
in hpet_set_rtc_irq_bit(). The interrupt handles does accidentally
check for RTC_PIE and not RTC_AIE when comparing the time
which was set in hpet_set_alarm_time().

This patch is against 2.6.24-rc5-mm1.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 arch/x86/kernel/hpet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -657,7 +657,7 @@ irqreturn_t hpet_rtc_interrupt(int irq, 
 		hpet_pie_count = 0;
 	}
 
-	if (hpet_rtc_flags & RTC_PIE &&
+	if (hpet_rtc_flags & RTC_AIE &&
 	    (curr_time.tm_sec == hpet_alarm_time.tm_sec) &&
 	    (curr_time.tm_min == hpet_alarm_time.tm_min) &&
 	    (curr_time.tm_hour == hpet_alarm_time.tm_hour))
