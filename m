Return-Path: <linux-kernel-owner+w=401wt.eu-S1762699AbZLKWYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762699AbZLKWYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761569AbZLKWYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:24:53 -0500
Received: from kroah.org ([198.145.64.141]:60986 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761563AbZLKWYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:24:52 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Altobelli <david.altobelli@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/27] hpilo: add locking comment
Date: Fri, 11 Dec 2009 14:24:23 -0800
Message-Id: <1260570289-6997-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211212642.GA6624@kroah.com>
References: <20091211212642.GA6624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Altobelli <david.altobelli@hp.com>

Add explanation about lock nesting and purpose of each lock in hpilo.

Signed-off-by: David Altobelli <david.altobelli@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/hpilo.h |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/hpilo.h b/drivers/misc/hpilo.h
index 3857605..247eb38 100644
--- a/drivers/misc/hpilo.h
+++ b/drivers/misc/hpilo.h
@@ -44,9 +44,20 @@ struct ilo_hwinfo {
 
 	struct pci_dev *ilo_dev;
 
+	/*
+	 * open_lock      serializes ccb_cnt during open and close
+	 * [ irq disabled ]
+	 * -> alloc_lock  used when adding/removing/searching ccb_alloc,
+	 *                which represents all ccbs open on the device
+	 * --> fifo_lock  controls access to fifo queues shared with hw
+	 *
+	 * Locks must be taken in this order, but open_lock and alloc_lock
+	 * are optional, they do not need to be held in order to take a
+	 * lower level lock.
+	 */
+	spinlock_t open_lock;
 	spinlock_t alloc_lock;
 	spinlock_t fifo_lock;
-	spinlock_t open_lock;
 
 	struct cdev cdev;
 };
-- 
1.6.5.5

