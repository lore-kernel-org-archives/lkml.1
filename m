Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbXJYIGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbXJYIGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 04:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbXJYIGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 04:06:15 -0400
Received: from havoc.gtf.org ([69.61.125.42]:42445 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbXJYIGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 04:06:13 -0400
To: LKML <linux-kernel@vger.kernel.org>
Message-Id: <a576b5944eb04a18d4df3dd27cd32e7f13601470.1193299380.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org
Subject: [PATCH] sound/oss/sb_common.c: fix casting warning
Date: Thu, 25 Oct 2007 04:06:12 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sound/oss/sb_common.c: In function 'probe_sbmpu':
sound/oss/sb_common.c:1231: warning: cast to pointer from integer of different size

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 sound/oss/sb_common.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/sound/oss/sb_common.c b/sound/oss/sb_common.c
index 07cbacf..77d0e5e 100644
--- a/sound/oss/sb_common.c
+++ b/sound/oss/sb_common.c
@@ -1228,7 +1228,8 @@ int probe_sbmpu(struct address_info *hw_config, struct module *owner)
 		}
 		attach_mpu401(hw_config, owner);
 		if (last_sb->irq == -hw_config->irq)
-			last_sb->midi_irq_cookie=(void *)hw_config->slots[1];
+			last_sb->midi_irq_cookie =
+				(void *)(long) hw_config->slots[1];
 		return 1;
 	}
 #endif
-- 
1.5.2.4

