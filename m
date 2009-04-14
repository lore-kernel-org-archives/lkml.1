Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbZDNPxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbZDNPxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbZDNPvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:51:48 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45974 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755013AbZDNPvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:51:45 -0400
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 04/14] [VOYAGER] x86: use boot_cpu_id instead of zero for checking boot processor
Date: Tue, 14 Apr 2009 10:51:30 -0500
Message-Id: <1239724300-16371-5-git-send-email-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1239724300-16371-4-git-send-email-James.Bottomley@HansenPartnership.com>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-2-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-3-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-4-git-send-email-James.Bottomley@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function smp_store_cpu_info() checks zero to see if it's
identifying a secondary.  It should check boot_cpu_id.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/kernel/smpboot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 58d24ef..0567c0a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -357,7 +357,7 @@ void __cpuinit smp_store_cpu_info(int id)
 
 	copy_cpuinfo_x86(c, &boot_cpu_data);
 	c->cpu_index = id;
-	if (id != 0)
+	if (id != boot_cpu_id)
 		identify_secondary_cpu(c);
 }
 
-- 
1.6.2.1

