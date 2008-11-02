Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbYKBQFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbYKBQFR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 11:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbYKBQE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 11:04:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:39422 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbYKBQE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 11:04:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=uM2dfDrwPtxUo/tJUC35i1OCqFL3QqLR8Zz9DLz5L3vZk+vSZKCDHrJiGKTQgGw0NY
         00U6AwIk5/BhTSXtHHu+5nXnom1C7/dM41m37qoSQHwGRHN/Bxrofej030HNufa/uI8q
         jBfraAc7XpV66GraS5G4bp6OZAp/ZhR7dQpXU=
From: Matt Fleming <mjf@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, venkatesh.pallipadi@intel.com,
       Matt Fleming <mjf@gentoo.org>
Subject: [PATCH 1/3] HPET: Convert WARN_ON to WARN_ON_ONCE
Date: Sun,  2 Nov 2008 16:04:18 +0000
Message-Id: <1225641860-6120-1-git-send-email-mjf@gentoo.org>
X-Mailer: git-send-email 1.5.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to flood the console with call traces if the WARN_ON
condition is true because of the frequency with which this function is
called.

Signed-off-by: Matt Fleming <mjf@gentoo.org>
---
 arch/x86/kernel/hpet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 77017e8..f10f946 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -322,7 +322,7 @@ static int hpet_next_event(unsigned long delta,
 	 * what we wrote hit the chip before we compare it to the
 	 * counter.
 	 */
-	WARN_ON((u32)hpet_readl(HPET_T0_CMP) != cnt);
+	WARN_ON_ONCE((u32)hpet_readl(HPET_T0_CMP) != cnt);
 
 	return (s32)((u32)hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
 }
-- 
1.5.6.4

