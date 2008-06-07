Return-Path: <linux-kernel-owner+w=401wt.eu-S1762058AbYFGBQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762058AbYFGBQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758235AbYFGBJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:17 -0400
Received: from sous-sol.org ([216.99.217.87]:42434 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760165AbYFGBJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:09 -0400
Message-Id: <20080607010613.092515468@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:38 -0700
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
       Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 23/50] x86: dont read maxlvt before checking if APIC is mapped
Content-Disposition: inline; filename=x86-don-t-read-maxlvt-before-checking-if-apic-is-mapped.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Chuck Ebbert <cebbert@redhat.com>

upstream commit: 2584a82deed7196f48066f1b1a7fad4ec5bea961

A check for unmapped apic was added before reading maxlvt but the early
read of maxlvt wasn't removed.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kernel/apic_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -524,7 +524,7 @@ int setup_profiling_timer(unsigned int m
  */
 void clear_local_APIC(void)
 {
-	int maxlvt = lapic_get_maxlvt();
+	int maxlvt;
 	u32 v;
 
 	/* APIC hasn't been mapped yet */

-- 
