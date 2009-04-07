Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbZDGPIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbZDGPIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756349AbZDGPHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:07:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48815 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbZDGPHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:07:01 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407506.675031434@firstfloor.org>
In-Reply-To: <20090407506.675031434@firstfloor.org>
To: ying.huang@intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Subject: [PATCH] [4/4] x86: MCE: Fix EIPV behaviour with !PCC
Message-Id: <20090407150657.61C4E1D046E@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:06:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Huang Ying <ying.huang@intel.com>

Impact: Spec compliance

When tolerant == 0, system should go panic instead of send SIGBUS even
for a MCE with EPIV && !PCC on user space.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:14.000000000 +0200
@@ -401,7 +401,7 @@
 		 * force_sig() takes an awful lot of locks and has a slight
 		 * risk of deadlocking.
 		 */
-		if (user_space) {
+		if (user_space && tolerant > 0) {
 			force_sig(SIGBUS, current);
 		} else if (panic_on_oops || tolerant < 2) {
 			mce_panic("Uncorrected machine check",
