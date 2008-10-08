Return-Path: <linux-kernel-owner+w=401wt.eu-S1757007AbYJHW2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007AbYJHW2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 18:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbYJHW2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 18:28:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58013 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144AbYJHW2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 18:28:46 -0400
Date: Wed, 8 Oct 2008 18:28:15 -0400
From: Dave Jones <davej@redhat.com>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: fsl_upm compile failure.
Message-ID: <20081008222815.GA20542@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Anton Vorontsov <avorontsov@ru.mvista.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton, 
 I tried reenabling CONFIG_MTD_NAND_FSL_UPM in the Fedora kernel
today (currently on 2.6.27-rc9-git1), and got the error below.

ERROR: "fsl_lbc_lock" [drivers/mtd/nand/fsl_upm.ko] undefined!

It seems that this isn't exported to modules.
diff below fixes this.  (Not tested yet, the Fedora ppc
 builders are a little slow).

	Dave

--- 

CONFIG_MTD_NAND_FSL_UPM can be built modular, but needs to
use fsl_lbc_lock, which isn't currently exported.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/powerpc/sysdev/fsl_lbc.c b/arch/powerpc/sysdev/fsl_lbc.c
index 422c8fa..1c6c522 100644
--- a/arch/powerpc/sysdev/fsl_lbc.c
+++ b/arch/powerpc/sysdev/fsl_lbc.c
@@ -16,6 +16,7 @@
 #include <asm/fsl_lbc.h>
 
 spinlock_t fsl_lbc_lock = __SPIN_LOCK_UNLOCKED(fsl_lbc_lock);
+EXPORT_SYMBOL(fsl_lbc_lock);
 
 struct fsl_lbc_regs __iomem *fsl_lbc_regs;
 EXPORT_SYMBOL(fsl_lbc_regs);
