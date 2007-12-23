Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbXLWOwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbXLWOwO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbXLWOvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:51:39 -0500
Received: from il.qumranet.com ([82.166.9.18]:35867 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbXLWOvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:37 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 03/50] KVM: x86 emulator: remove unused functions
Date: Sun, 23 Dec 2007 16:50:48 +0200
Message-Id: <1198421495-31481-4-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

Remove #ifdef functions never used

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |   39 ---------------------------------------
 1 files changed, 0 insertions(+), 39 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index f12bc2c..9ea82f8 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1639,42 +1639,3 @@ cannot_emulate:
 	DPRINTF("Cannot emulate %02x\n", b);
 	return -1;
 }
-
-#ifdef __XEN__
-
-#include <asm/mm.h>
-#include <asm/uaccess.h>
-
-int
-x86_emulate_read_std(unsigned long addr,
-		     unsigned long *val,
-		     unsigned int bytes, struct x86_emulate_ctxt *ctxt)
-{
-	unsigned int rc;
-
-	*val = 0;
-
-	if ((rc = copy_from_user((void *)val, (void *)addr, bytes)) != 0) {
-		propagate_page_fault(addr + bytes - rc, 0);	/* read fault */
-		return X86EMUL_PROPAGATE_FAULT;
-	}
-
-	return X86EMUL_CONTINUE;
-}
-
-int
-x86_emulate_write_std(unsigned long addr,
-		      unsigned long val,
-		      unsigned int bytes, struct x86_emulate_ctxt *ctxt)
-{
-	unsigned int rc;
-
-	if ((rc = copy_to_user((void *)addr, (void *)&val, bytes)) != 0) {
-		propagate_page_fault(addr + bytes - rc, PGERR_write_access);
-		return X86EMUL_PROPAGATE_FAULT;
-	}
-
-	return X86EMUL_CONTINUE;
-}
-
-#endif
-- 
1.5.3.7

