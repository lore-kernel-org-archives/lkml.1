Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbYGMKrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbYGMKrA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 06:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYGMKqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 06:46:52 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:32193 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbYGMKqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 06:46:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WRgtPixqPllKNjUfWlnA9eX9yS1Nc0Oq8mvlIexJnOGjUTXud37O9RYmYYO6Hhz6Vu
         5oKBzeWFssPzFAzXghh7Kncv08jaRPxR8/FPcrrgtvRkLr7lquzhXr1/qe0fjxA4JrSe
         kx/HGI55jKtbHlI318tnjfHOD6mv6UG9rLs58=
From: tom.leiming@gmail.com
To: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] PCI:pciehp:remove unnecessary volatile in struct controller
Date: Sun, 13 Jul 2008 18:46:42 +0800
Message-Id: <1215946002-4775-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.5.6.rc2.45.gdc92c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

Proper memory barriers have been added to order accesses
to ->cmd_busy, so volatile declaration for cmd_busy can
be removed.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/pci/hotplug/pciehp.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index 79c9dda..5e2becd 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -96,7 +96,7 @@ struct controller {
 	u32 slot_cap;
 	u8 cap_base;
 	struct timer_list poll_timer;
-	volatile int cmd_busy;
+	int cmd_busy;
 	unsigned int no_cmd_complete:1;
 };
 
-- 
1.5.6.rc2.45.gdc92c

