Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbZCHQt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbZCHQt6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 12:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbZCHQsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 12:48:43 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52183 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753411AbZCHQsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 12:48:42 -0400
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 04/13] [VOYAGER] x86: use boot_cpu_id instead of zero for checking boot processor
Date: Sun,  8 Mar 2009 11:48:17 -0500
Message-Id: <1236530906-7175-5-git-send-email-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236530906-7175-4-git-send-email-James.Bottomley@HansenPartnership.com>
References: <1236530906-7175-1-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-2-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-3-git-send-email-James.Bottomley@HansenPartnership.com>
 <1236530906-7175-4-git-send-email-James.Bottomley@HansenPartnership.com>
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
index 249334f..070fa13 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -421,7 +421,7 @@ void __cpuinit smp_store_cpu_info(int id)
 
 	*c = boot_cpu_data;
 	c->cpu_index = id;
-	if (id != 0)
+	if (id != boot_cpu_id)
 		identify_secondary_cpu(c);
 	smp_apply_quirks(c);
 }
-- 
1.6.1.3

