Return-Path: <linux-kernel-owner+w=401wt.eu-S1761046AbYELKXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761046AbYELKXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 06:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759091AbYELKXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 06:23:00 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:38701 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440AbYELKW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 06:22:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=tdiBy4RIVFQm3MyD7yLmXBX3zwXac4yedLrwTOxzExQW4afLvKj82jM+5g/KsSBhDDODNx7tkUYMzqka8PpMhqOi2GMbC+q8fHwVO5R4836tPMbJkr1r6krTTYAvMVvfVR3CdDib9mNQtZwsND4fcKbjgSqFx/p8col5HSceEAg=
From: Bryan Wu <cooloney@kernel.org>
To: marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] [bluetooth]: fix bug - kernel warning detected if built in Bluetooth CF driver
Date: Mon, 12 May 2008 18:22:59 +0800
Message-Id: <1210587779-10257-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

https://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=2650

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/bluetooth/bluecard_cs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/bluetooth/bluecard_cs.c b/drivers/bluetooth/bluecard_cs.c
index bcf5792..3b330a0 100644
--- a/drivers/bluetooth/bluecard_cs.c
+++ b/drivers/bluetooth/bluecard_cs.c
@@ -867,7 +867,7 @@ static int bluecard_probe(struct pcmcia_device *link)
 
 	link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
 	link->io.NumPorts1 = 8;
-	link->irq.Attributes = IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;
+	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING | IRQ_HANDLE_PRESENT;
 	link->irq.IRQInfo1 = IRQ_LEVEL_ID;
 
 	link->irq.Handler = bluecard_interrupt;
-- 
1.5.5

