Return-Path: <linux-kernel-owner+w=401wt.eu-S1758488AbZA2Vdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488AbZA2Vdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 16:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbZA2VdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 16:33:24 -0500
Received: from relay1.sgi.com ([192.48.179.29]:60975 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751344AbZA2VdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 16:33:23 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: UV fix uv_flush_send_and_wait
Cc: mingo@elte.hu, tj@kernel.org
Message-Id: <E1LSeXm-0007ck-9j@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Thu, 29 Jan 2009 15:35:26 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Cliff Wickman <cpw@sgi.com>

uv_flush_send_and_wait() should return a pointer if the broadcast
remote tlb shootdown requests fail. That causes the conventional IPI
method of shootdown to be used.

Diffed against 2.6.29-rc2
  (Ingo's tree)

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/tlb_uv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c
+++ linux/arch/x86/kernel/tlb_uv.c
@@ -259,7 +259,7 @@ const struct cpumask *uv_flush_send_and_
 		 * the cpu's, all of which are still in the mask.
 		 */
 		__get_cpu_var(ptcstats).ptc_i++;
-		return 0;
+		return flush_mask;
 	}
 
 	/*
