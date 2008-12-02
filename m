Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbYLBThy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbYLBThy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 14:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbYLBThq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 14:37:46 -0500
Received: from gate.crashing.org ([63.228.1.57]:54409 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442AbYLBThp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 14:37:45 -0500
From: Kumar Gala <galak@kernel.crashing.org>
To: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH][for 2.6.28] powerpc: Use physical cpu id when setting the processor affinity
Date: Tue,  2 Dec 2008 13:37:01 -0600
Message-Id: <1228246621-25622-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the CONFIG_SMP case the irq_choose_cpu() code was returning back
a logical cpu id not the physical id.  We were writing that directly
into the HW register.

We need to be calling get_hard_smp_processor_id() so irq_choose_cpu()
always returns a physical cpu id.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 arch/powerpc/sysdev/mpic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index b24e1d0..1890fb0 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -600,7 +600,7 @@ static int irq_choose_cpu(unsigned int virt_irq)
 		cpuid = first_cpu(tmp);
 	}
 
-	return cpuid;
+	return get_hard_smp_processor_id(cpuid);
 }
 #else
 static int irq_choose_cpu(unsigned int virt_irq)
-- 
1.5.6.5

