Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbYIDBSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbYIDBSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 21:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYIDBSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 21:18:04 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:44117 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607AbYIDBSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 21:18:02 -0400
Subject: [PATCH] Change warning message in TSC calibration.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Michael Buesch <mb@bu3sch.de>, Dan Hecht <dhecht@vmware.com>
In-Reply-To: <alpine.LFD.1.10.0809031103090.3243@apollo.tec.linutronix.de>
References: <48BB2116.1060904@lwfinger.net>
	 <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de>
	 <48BC2A03.9000104@lwfinger.net>
	 <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809021918450.3243@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0809021120120.3210@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809022358370.3243@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0809021906250.3259@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809031103090.3243@apollo.tec.linutronix.de>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 03 Sep 2008 18:18:01 -0700
Message-Id: <1220491081.22734.86.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: Change warning message in TSC calibration.

From: Alok N Kataria <akataria@vmware.com>

When calibration against PIT fails, the warning that we print is misleading.
In a virtualized environment the VM may get descheduled while calibration
or, the check in PIT calibration may fail due to other virtualization
overheads.

The warning message explicitly assumes that calibration failed due to SMI's
which may not be the case. Change that to something proper.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
---

 arch/x86/kernel/tsc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)


diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index d74b3ef..9d4aeec 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -271,8 +271,7 @@ unsigned long native_calibrate_tsc(void)
 	 */
 	if (tsc_pit_min == ULONG_MAX) {
 		/* PIT gave no useful value */
-		printk(KERN_WARNING "TSC: PIT calibration failed due to "
-		       "SMI disturbance.\n");
+		printk(KERN_WARNING "TSC: Unable to calibrate against PIT\n");
 
 		/* We don't have an alternative source, disable TSC */
 		if (!hpet && !pm1 && !pm2) {


