Return-Path: <linux-kernel-owner+w=401wt.eu-S1751826AbXBAPgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbXBAPgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbXBAPgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:36:11 -0500
Received: from styx.suse.cz ([82.119.242.94]:34356 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751784AbXBAPgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:36:07 -0500
Date: Thu, 1 Feb 2007 16:36:21 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/10] SCSI-BusLogic: local_irq_disable() is redundant after
 local_irq_save()
In-Reply-To: <Pine.LNX.4.64.0702011609090.13648@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0702011616210.13648@jikos.suse.cz>
References: <Pine.LNX.4.64.0702011609090.13648@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

SCSI-BusLogic: local_irq_disable() is redundant after local_irq_save()

drivers/scsi/BusLogic.c::BusLogic_Command() contains
local_irq_disable() call after local_irq_save(). This looks
redundant.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

---

 drivers/scsi/BusLogic.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 3075204..6272ec2 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -362,10 +362,8 @@ static int BusLogic_Command(struct BusLogic_HostAdapter *HostAdapter, enum BusLo
 	   interrupt could occur if the IRQ Channel was previously enabled by another
 	   BusLogic Host Adapter or another driver sharing the same IRQ Channel.
 	 */
-	if (!HostAdapter->IRQ_ChannelAcquired) {
+	if (!HostAdapter->IRQ_ChannelAcquired)
 		local_irq_save(ProcessorFlags);
-		local_irq_disable();
-	}
 	/*
 	   Wait for the Host Adapter Ready bit to be set and the Command/Parameter
 	   Register Busy bit to be reset in the Status Register.
