Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbYKBQEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbYKBQEw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 11:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbYKBQE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 11:04:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:45184 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbYKBQE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 11:04:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=jrkU2TvrvzQ8Kgt8c/6LZ0QJwhabq9eu9CbAdSGzreXu89uAYtPefm6VtxOEX8Bqx2
         hf+v2oJ+Cfmovjl/Mp8DVRGWRy8usbASne+P1x0FkxDfwgVjXmCdls7e6otEpUHu7YLT
         5Yd6OLknmzObNAeuF4T0UPTs5hAEirFoXvHsU=
From: Matt Fleming <mjf@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, venkatesh.pallipadi@intel.com,
       Matt Fleming <mjf@gentoo.org>
Subject: [PATCH 3/3] HPET: Read from HPET_Tn_CMP() not HPET_T0_CMP
Date: Sun,  2 Nov 2008 16:04:20 +0000
Message-Id: <1225641860-6120-3-git-send-email-mjf@gentoo.org>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1225641860-6120-2-git-send-email-mjf@gentoo.org>
References: <1225641860-6120-1-git-send-email-mjf@gentoo.org>
 <1225641860-6120-2-git-send-email-mjf@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In hpet_next_event() we check that the value we just wrote to
HPET_Tn_CMP(timer) has reached the chip. Currently, we're checking that
the value we wrote to HPET_Tn_CMP(timer) is in HPET_T0_CMP, which, if
timer is anything other than timer 0, is likely to fail.

Signed-off-by: Matt Fleming <mjf@gentoo.org>
---
 arch/x86/kernel/hpet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index c28fff2..76feb2e 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -322,7 +322,7 @@ static int hpet_next_event(unsigned long delta,
 	 * what we wrote hit the chip before we compare it to the
 	 * counter.
 	 */
-	WARN_ON_ONCE((u32)hpet_readl(HPET_T0_CMP) != cnt);
+	WARN_ON_ONCE((u32)hpet_readl(HPET_Tn_CMP(timer)) != cnt);
 
 	return (s32)((u32)hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
 }
-- 
1.5.6.4

