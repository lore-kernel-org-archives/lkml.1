Return-Path: <linux-kernel-owner+w=401wt.eu-S1423474AbXD3QBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423474AbXD3QBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423502AbXD3P4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:56:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423454AbXD3Ptr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:49:47 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: fernando@oss.ntt.co.jp, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [14/34] i386: Use safe_apic_wait_icr_idle in  safe_apic_wait_icr_idle - i386
Message-Id: <20070430154946.94274151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:46 +0200 (CEST)
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
 arch/i386/kernel/smp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux/arch/i386/kernel/smp.c
===================================================================
--- linux.orig/arch/i386/kernel/smp.c
+++ linux/arch/i386/kernel/smp.c
@@ -175,7 +175,10 @@ static inline void __send_IPI_dest_field
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
