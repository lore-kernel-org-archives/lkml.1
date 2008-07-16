Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbYGPOzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbYGPOzD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbYGPOyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:54:41 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:38639 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185AbYGPOyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:54:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qIgKATgVaeFG/ejdXp2/i7rQ7DLdIydwxDDz6jsz63l2vj99s4GWr0nCU9T/9Rsl9K
         PbO3PFJ59OMzqNUHT5Iz5hCuGufJfq59kRIoM8FTm1ITXJzlV0FjEhb9oQlO6x11fQPS
         oNqgbfdFqcyB4OW2q2eq+Xf8e4FhWcqSesrDQ=
From: tom.leiming@gmail.com
To: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH/RESEND] PCI:pciehp:remove unnecessary volatile in struct controller
Date: Wed, 16 Jul 2008 22:54:30 +0800
Message-Id: <1216220070-4246-1-git-send-email-tom.leiming@gmail.com>
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

