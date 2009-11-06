Return-Path: <linux-kernel-owner+w=401wt.eu-S933137AbZKFWlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137AbZKFWlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932386AbZKFWlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:41:40 -0500
Received: from www.tglx.de ([62.245.132.106]:53958 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933106AbZKFWlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:41:36 -0500
Message-Id: <20091106223806.601092947@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 06 Nov 2009 22:41:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 05/16] pci: Replace old style lock initializer
References: <20091106223547.784916750@linutronix.de>
Content-Disposition: inline; filename=pci-replace-old-style-lock-init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCKED is deprecated. Use DEFINE_SPINLOCK instead.

Make the lock static while at it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -2590,7 +2590,7 @@ int pci_set_vga_state(struct pci_dev *de
 
 #define RESOURCE_ALIGNMENT_PARAM_SIZE COMMAND_LINE_SIZE
 static char resource_alignment_param[RESOURCE_ALIGNMENT_PARAM_SIZE] = {0};
-spinlock_t resource_alignment_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(resource_alignment_lock);
 
 /**
  * pci_specified_resource_alignment - get resource alignment specified by user.


