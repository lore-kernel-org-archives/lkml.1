Return-Path: <linux-kernel-owner+w=401wt.eu-S1751798AbXBAPgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbXBAPgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:36:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbXBAPgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:36:08 -0500
Received: from styx.suse.cz ([82.119.242.94]:34347 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751778AbXBAPfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:35:51 -0500
Date: Thu, 1 Feb 2007 16:36:04 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/10] POWERPC-86xx: local_irq_disable() is redundant after
 local_irq_save()
In-Reply-To: <Pine.LNX.4.64.0702011609090.13648@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0702011615570.13648@jikos.suse.cz>
References: <Pine.LNX.4.64.0702011609090.13648@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

POWERPC-86xx: local_irq_disable() is redundant after local_irq_save()

arch/powerpc/platforms/86xx/mpc86xx_smp.c::smp_86xx_kick_cpu() contains
local_irq_disable() call after local_irq_save(). This looks
redundant.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

---

 arch/powerpc/platforms/86xx/mpc86xx_smp.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/86xx/mpc86xx_smp.c b/arch/powerpc/platforms/86xx/mpc86xx_smp.c
index bb7fb41..7ef0c68 100644
--- a/arch/powerpc/platforms/86xx/mpc86xx_smp.c
+++ b/arch/powerpc/platforms/86xx/mpc86xx_smp.c
@@ -65,7 +65,6 @@ smp_86xx_kick_cpu(int nr)
 	pr_debug("smp_86xx_kick_cpu: kick CPU #%d\n", nr);
 
 	local_irq_save(flags);
-	local_irq_disable();
 
 	/* Save reset vector */
 	save_vector = *vector;
