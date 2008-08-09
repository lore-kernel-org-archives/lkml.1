Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbYHIW52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbYHIW52 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 18:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbYHIW5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 18:57:01 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:55948 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbYHIW5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 18:57:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=g+FsAXSL1ehAeD4o9bx4crYufG5vCcn467zplSACoHWx5ln2dLU3kFVrp4fg06HzHI
         I+MrhtF1mv3BzVeInga2JB9YI9/H+b0F66bN5TF0aD4mfi2avUcq9aMiZxJlGv8RQeDk
         zQk2oOLaF2+AW7B8Rx2m6lLnYTdVQIu3Z5k9U=
Subject: [PATCH] x86: fix shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 09 Aug 2008 15:57:00 -0700
Message-Id: <1218322620.24441.8.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/pvclock.c:102:6: warning: symbol 'tsc_khz' shadows an earlier one
include/asm/tsc.h:18:21: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Introduced between next-20080729 and next-20080808

 arch/x86/kernel/pvclock.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 1c54b5f..4f9c55f 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -99,14 +99,14 @@ static unsigned pvclock_get_time_values(struct pvclock_shadow_time *dst,
 
 unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src)
 {
-	u64 tsc_khz = 1000000ULL << 32;
+	u64 pv_tsc_khz = 1000000ULL << 32;
 
-	do_div(tsc_khz, src->tsc_to_system_mul);
+	do_div(pv_tsc_khz, src->tsc_to_system_mul);
 	if (src->tsc_shift < 0)
-		tsc_khz <<= -src->tsc_shift;
+		pv_tsc_khz <<= -src->tsc_shift;
 	else
-		tsc_khz >>= src->tsc_shift;
-	return tsc_khz;
+		pv_tsc_khz >>= src->tsc_shift;
+	return pv_tsc_khz;
 }
 
 cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
-- 
1.6.0.rc1.278.g9c632


