Return-Path: <linux-kernel-owner+w=401wt.eu-S1423582AbXD3QBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423582AbXD3QBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423436AbXD3Pzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:55:54 -0400
Received: from ns1.suse.de ([195.135.220.2]:45001 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423455AbXD3Pts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:49:48 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: fernando@oss.ntt.co.jp, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [15/34] x86_64: Use safe_apic_wait_icr_idle in __send_IPI_dest_field  - x86_64
Message-Id: <20070430154947.A3ABB151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Fernando Luis [** ISO-8859-1 charset **] VázquezCao <fernando@oss.ntt.co.jp>
Use safe_apic_wait_icr_idle to check ICR idle bit if the vector is
NMI_VECTOR to avoid potential hangups in the event of crash when kdump
tries to stop the other CPUs.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Andi Kleen <ak@suse.de>

---

---
 include/asm-x86_64/ipi.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux/include/asm-x86_64/ipi.h
===================================================================
--- linux.orig/include/asm-x86_64/ipi.h
+++ linux/include/asm-x86_64/ipi.h
@@ -85,7 +85,10 @@ static inline void __send_IPI_dest_field
 	/*
 	 * Wait for idle.
 	 */
-	apic_wait_icr_idle();
+	if (unlikely(vector == NMI_VECTOR))
+		safe_apic_wait_icr_idle();
+	else
+		apic_wait_icr_idle();
 
 	/*
 	 * prepare target chip field
