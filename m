Return-Path: <linux-kernel-owner+w=401wt.eu-S966156AbZLHU5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966156AbZLHU5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966137AbZLHU5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:57:30 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:43980 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966123AbZLHU52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:57:28 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] vbus: fix lots of sparse "dubious signed bitfield" warnings
Date: Tue,  8 Dec 2009 12:57:30 -0800
Message-Id: <1260305854-31472-2-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.6.0.rc1.71.gfba5.dirty
In-Reply-To: <1260305854-31472-1-git-send-email-iws@ovro.caltech.edu>
References: <1260305854-31472-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Tue, 08 Dec 2009 12:57:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sparse utility gave tons of warnings about signed bitfields. A simple
inspection shows that they are all used as booleans, so convert them to the
correct type.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/vbus/pci-bridge.c |    2 +-
 include/linux/ioq.h       |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vbus/pci-bridge.c b/drivers/vbus/pci-bridge.c
index 9e37df1..aa683ae 100644
--- a/drivers/vbus/pci-bridge.c
+++ b/drivers/vbus/pci-bridge.c
@@ -43,7 +43,7 @@ struct vbus_pci {
 	struct vbus_pci_regs     *regs;
 	struct vbus_pci_signals  *signals;
 	int                       irq;
-	int                       enabled:1;
+	bool                      enabled;
 	struct {
 		struct dentry    *fs;
 		int               events;
diff --git a/include/linux/ioq.h b/include/linux/ioq.h
index eba1021..f04dfb4 100644
--- a/include/linux/ioq.h
+++ b/include/linux/ioq.h
@@ -112,9 +112,9 @@ struct ioq_iterator {
 	struct ioq_ring_idx   *idx;
 	u32                    pos;
 	struct ioq_ring_desc  *desc;
-	int                    update:1;
-	int                    dualidx:1;
-	int                    flipowner:1;
+	bool                   update;
+	bool                   dualidx;
+	bool                   flipowner;
 };
 
 struct ioq_notifier {
-- 
1.5.4.3

