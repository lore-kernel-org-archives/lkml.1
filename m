Return-Path: <linux-kernel-owner+w=401wt.eu-S1761113AbYFGBLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761113AbYFGBLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760651AbYFGBIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:08:53 -0400
Received: from sous-sol.org ([216.99.217.87]:42300 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760618AbYFGBIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:08:51 -0400
Message-Id: <20080607010616.942955087@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:43 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 28/50] x86: disable TSC for sched_clock() when calibration failed
Content-Disposition: inline; filename=x86-disable-tsc-for-sched_clock-when-calibration-failed.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Thomas Gleixner <tglx@linutronix.de>

upstream commit: 74dc51a3de06aa516e3b9fdc4017b2aeb38bf44b

When the TSC calibration fails then TSC is still used in
sched_clock(). Disable it completely in that case.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@kernel.org
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kernel/tsc_32.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -401,6 +401,11 @@ void __init tsc_init(void)
 
 	if (!cpu_khz) {
 		mark_tsc_unstable("could not calculate TSC khz");
+		/*
+		 * We need to disable the TSC completely in this case
+		 * to prevent sched_clock() from using it.
+		 */
+		tsc_disabled = 1;
 		return;
 	}
 

-- 
