Return-Path: <linux-kernel-owner+w=401wt.eu-S1751797AbXBAPgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbXBAPgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:36:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbXBAPgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:36:07 -0500
Received: from styx.suse.cz ([82.119.242.94]:34353 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751784AbXBAPgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:36:01 -0500
Date: Thu, 1 Feb 2007 16:36:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/10] POWERPC-Powermac: local_irq_disable() is redundant
 after local_irq_save()
In-Reply-To: <Pine.LNX.4.64.0702011609090.13648@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0702011616080.13648@jikos.suse.cz>
References: <Pine.LNX.4.64.0702011609090.13648@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

POWERPC-Powermac: local_irq_disable() is redundant after local_irq_save()

arch/powerpc/platforms/powermac/smp.c::smp_core99_kick_cpu() contains
local_irq_disable() call after local_irq_save(). This looks
redundant.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

---

 arch/powerpc/platforms/powermac/smp.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/powermac/smp.c b/arch/powerpc/platforms/powermac/smp.c
index eeb2ae5..d73fb73 100644
--- a/arch/powerpc/platforms/powermac/smp.c
+++ b/arch/powerpc/platforms/powermac/smp.c
@@ -795,7 +795,6 @@ static void __devinit smp_core99_kick_cpu(int nr)
 		ppc_md.progress("smp_core99_kick_cpu", 0x346);
 
 	local_irq_save(flags);
-	local_irq_disable();
 
 	/* Save reset vector */
 	save_vector = *vector;
