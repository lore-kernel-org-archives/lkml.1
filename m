Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbZAOPuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbZAOPuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 10:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbZAOPtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 10:49:53 -0500
Received: from relay3.sgi.com ([192.48.171.31]:41877 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752675AbZAOPtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 10:49:52 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] UV: cpu_relax in uv_wait_completion
Cc: mingo@elte.hu
Message-Id: <E1LNUV6-00025f-Q7@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Thu, 15 Jan 2009 09:51:20 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Cliff Wickman <cpw@sgi.com>

The function uv_wait_completion() spins on reads of a memory-mapped
register, waiting for completion of BAU hardware replies.
It should call "cpu_relax()" between those reads to improve performance
on hyperthreaded configurations.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Acked-by: Jack Steiner <steiner@sgi.org>

---
 arch/x86/kernel/tlb_uv.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c
+++ linux/arch/x86/kernel/tlb_uv.c
@@ -200,6 +200,7 @@ static int uv_wait_completion(struct bau
 				destination_timeouts = 0;
 			}
 		}
+		cpu_relax();
 	}
 	return FLUSH_COMPLETE;
 }
