Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935076Ab0CMAYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:24:49 -0500
Received: from kroah.org ([198.145.64.141]:32895 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935071Ab0CMAVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:21:13 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:15 2010
Message-Id: <20100313001515.642272234@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 120/123] sched: Fix sched_mv_power_savings for !SMT
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

commit 28f5318167adf23b16c844b9c2253f355cb21796 upstream.

Fix for sched_mc_powersavigs for pre-Nehalem platforms.
Child sched domain should clear SD_PREFER_SIBLING if parent will have
SD_POWERSAVINGS_BALANCE because they are contradicting.

Sets the flags correctly based on sched_mc_power_savings.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100208100555.GD2931@dirshya.in.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/sched.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -878,7 +878,10 @@ static inline int sd_balance_for_mc_powe
 	if (sched_smt_power_savings)
 		return SD_POWERSAVINGS_BALANCE;
 
-	return SD_PREFER_SIBLING;
+	if (!sched_mc_power_savings)
+		return SD_PREFER_SIBLING;
+
+	return 0;
 }
 
 static inline int sd_balance_for_package_power(void)


