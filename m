Return-Path: <linux-kernel-owner+w=401wt.eu-S1752354Ab0AGLXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab0AGLXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 06:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648Ab0AGLXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 06:23:40 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64018 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752245Ab0AGLXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 06:23:38 -0500
Subject: [PATCH] Fix level of isp1760 Reloading ptd error message
To: linux-kernel@vger.kernel.org
From: Colin Tuckley <colin.tuckley@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, trivial@kernel.org
Date: Thu, 07 Jan 2010 11:22:47 +0000
Message-ID: <20100107112246.13276.69712.stgit@ARM03585.cambridge.arm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jan 2010 11:22:47.0466 (UTC) FILETIME=[BD6BB8A0:01CA8F8B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This error message is not actually an error, it's an information
message. It is triggered when a transfer which ended in a NAQ is
retried successfully by the hardware.

Signed-off-by: Colin Tuckley <colin.tuckley@arm.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
---
 drivers/usb/host/isp1760-hcd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/isp1760-hcd.c b/drivers/usb/host/isp1760-hcd.c
index 9600a58..27b8f7c 100644
--- a/drivers/usb/host/isp1760-hcd.c
+++ b/drivers/usb/host/isp1760-hcd.c
@@ -1039,12 +1039,12 @@ static void do_atl_int(struct usb_hcd *usb_hcd)
 		if (!nakcount && (dw3 & DW3_QTD_ACTIVE)) {
 			u32 buffstatus;
 
-			/* XXX
+			/*
 			 * NAKs are handled in HW by the chip. Usually if the
 			 * device is not able to send data fast enough.
-			 * This did not trigger for a long time now.
+			 * This happens mostly on slower hardware.
 			 */
-			printk(KERN_ERR "Reloading ptd %p/%p... qh %p readed: "
+			printk(KERN_NOTICE "Reloading ptd %p/%p... qh %p read: "
 					"%d of %zu done: %08x cur: %08x\n", qtd,
 					urb, qh, PTD_XFERRED_LENGTH(dw3),
 					qtd->length, done_map,

