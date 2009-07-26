Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbZGZIXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbZGZIXo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbZGZIXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:23:42 -0400
Received: from www.tglx.de ([62.245.132.106]:34080 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbZGZIXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:23:41 -0400
Message-Id: <20090726081555.073502498@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:18:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [Patch RFC 14/37] scsi: aacraid semaphore cleanup
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline; filename=driver-scsi-aacraid-sema-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of these "mutex"es is non obvious and probably completions
in some places. Make it them semaphores.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/aacraid/commctrl.c |    2 +-
 drivers/scsi/aacraid/commsup.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/drivers/scsi/aacraid/commctrl.c
===================================================================
--- linux-2.6-tip.orig/drivers/scsi/aacraid/commctrl.c
+++ linux-2.6-tip/drivers/scsi/aacraid/commctrl.c
@@ -190,7 +190,7 @@ static int open_getadapter_fib(struct aa
 		/*
 		 *	Initialize the mutex used to wait for the next AIF.
 		 */
-		init_MUTEX_LOCKED(&fibctx->wait_sem);
+		semaphore_init_locked(&fibctx->wait_sem);
 		fibctx->wait = 0;
 		/*
 		 *	Initialize the fibs and set the count of fibs on
Index: linux-2.6-tip/drivers/scsi/aacraid/commsup.c
===================================================================
--- linux-2.6-tip.orig/drivers/scsi/aacraid/commsup.c
+++ linux-2.6-tip/drivers/scsi/aacraid/commsup.c
@@ -124,7 +124,7 @@ int aac_fib_setup(struct aac_dev * dev)
 		fibptr->hw_fib_va = hw_fib;
 		fibptr->data = (void *) fibptr->hw_fib_va->data;
 		fibptr->next = fibptr+1;	/* Forward chain the fibs */
-		init_MUTEX_LOCKED(&fibptr->event_wait);
+		semaphore_init_locked(&fibptr->event_wait);
 		spin_lock_init(&fibptr->event_lock);
 		hw_fib->header.XferState = cpu_to_le32(0xffffffff);
 		hw_fib->header.SenderSize = cpu_to_le16(dev->max_fib_size);


