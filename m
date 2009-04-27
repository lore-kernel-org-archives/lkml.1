Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbZD0RsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbZD0RsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 13:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbZD0Rr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 13:47:57 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:39274 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbZD0Rr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 13:47:56 -0400
Message-ID: <49F5EFC6.1030703@linux.vnet.ibm.com>
Date: Mon, 27 Apr 2009 14:47:50 -0300
From: Breno Leitao <leitao@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: alan@lxorguk.ukuu.org.uk
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: [PATCH] jsm: removing unused spinlock
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes bd_lock spinlock (inside jsm_board structure).
The lock is initialized in the probe function and not used anymore.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
---
 drivers/serial/jsm/jsm.h        |    2 --
 drivers/serial/jsm/jsm_driver.c |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/jsm/jsm.h b/drivers/serial/jsm/jsm.h
index 8871aaa..c0a3e27 100644
--- a/drivers/serial/jsm/jsm.h
+++ b/drivers/serial/jsm/jsm.h
@@ -130,8 +130,6 @@ struct jsm_board
 	struct pci_dev	*pci_dev;
 	u32		maxports;	/* MAX ports this board can handle */
 
-	spinlock_t	bd_lock;	/* Used to protect board */
-
 	spinlock_t	bd_intr_lock;	/* Used to protect the poller tasklet and
 					 * the interrupt routine from each other.
 					 */
diff --git a/drivers/serial/jsm/jsm_driver.c b/drivers/serial/jsm/jsm_driver.c
index d2d32a1..b3604aa 100644
--- a/drivers/serial/jsm/jsm_driver.c
+++ b/drivers/serial/jsm/jsm_driver.c
@@ -88,7 +88,6 @@ static int __devinit jsm_probe_one(struct pci_dev *pdev, const struct pci_device
 	else
 		brd->maxports = 2;
 
-	spin_lock_init(&brd->bd_lock);
 	spin_lock_init(&brd->bd_intr_lock);
 
 	/* store which revision we have */
-- 
1.6.0.2

