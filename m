Return-Path: <linux-kernel-owner+w=401wt.eu-S1946665AbXBIQol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946665AbXBIQol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946659AbXBIQoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:44:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51707 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946651AbXBIQjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:39:21 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] misc NULL noise removal
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HFYmO-0006pG-ND@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:39:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/i386/mm/pageattr.c         |    2 +-
 drivers/char/watchdog/machzwd.c |    2 +-
 drivers/kvm/mmu.c               |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/i386/mm/pageattr.c b/arch/i386/mm/pageattr.c
index ad91528..e223b1d 100644
--- a/arch/i386/mm/pageattr.c
+++ b/arch/i386/mm/pageattr.c
@@ -224,7 +224,7 @@ void global_flush_tlb(void)
 	list_replace_init(&df_list, &l);
 	spin_unlock_irq(&cpa_lock);
 	if (!cpu_has_clflush)
-		flush_map(0);
+		flush_map(NULL);
 	list_for_each_entry_safe(pg, next, &l, lru) {
 		if (cpu_has_clflush)
 			flush_map(page_address(pg));
diff --git a/drivers/char/watchdog/machzwd.c b/drivers/char/watchdog/machzwd.c
index 276577d..4d730fd 100644
--- a/drivers/char/watchdog/machzwd.c
+++ b/drivers/char/watchdog/machzwd.c
@@ -325,7 +325,7 @@ static int zf_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			return put_user(0, p);
 
 		case WDIOC_KEEPALIVE:
-			zf_ping(0);
+			zf_ping(NULL);
 			break;
 
 		default:
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 22c426c..be79377 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -333,7 +333,7 @@ static void rmap_desc_remove_entry(struct kvm_vcpu *vcpu,
 	for (j = RMAP_EXT - 1; !desc->shadow_ptes[j] && j > i; --j)
 		;
 	desc->shadow_ptes[i] = desc->shadow_ptes[j];
-	desc->shadow_ptes[j] = 0;
+	desc->shadow_ptes[j] = NULL;
 	if (j != 0)
 		return;
 	if (!prev_desc && !desc->more)
-- 
1.5.0-rc2.GIT


