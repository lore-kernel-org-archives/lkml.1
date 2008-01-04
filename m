Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbYADVOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbYADVOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 16:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbYADVN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 16:13:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:37216 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbYADVNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 16:13:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=fsIPwx23qhPwWb9i1/Id/VaT/YwXZm2p1pKOW1W60vxFZFs/i/nHBreZOCXmJqlg3+G0mEbVl8CMGSKMiK5V++JmPiWGlJ5AAn4iNsFlmS3JrdDN4Z14Tuyu6HbunHhBiux2jGbJXEGuPyhI+lDQ+wX8aeLlDgcOY/aRGHUC06o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 04 Jan 2008 22:25:01 +0100
Message-Id: <20080104212501.6978.42272.sendpatchset@localhost.localdomain>
In-Reply-To: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
References: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/15] ide: remove unused ide_hwgroup_t fields
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/ide.h |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -628,8 +628,7 @@ typedef int (ide_expiry_t)(ide_drive_t *
 typedef struct hwgroup_s {
 		/* irq handler, if active */
 	ide_startstop_t	(*handler)(ide_drive_t *);
-		/* irq handler, suspended if active */
-	ide_startstop_t	(*handler_save)(ide_drive_t *);
+
 		/* BOOL: protects all fields below */
 	volatile int busy;
 		/* BOOL: wake us up on timer expiry */
@@ -644,25 +643,18 @@ typedef struct hwgroup_s {
 		/* ptr to current hwif in linked-list */
 	ide_hwif_t *hwif;
 
-		/* for pci chipsets */
-	struct pci_dev *pci_dev;
-
 		/* current request */
 	struct request *rq;
+
 		/* failsafe timer */
 	struct timer_list timer;
-		/* local copy of current write rq */
-	struct request wrq;
 		/* timeout value during long polls */
 	unsigned long poll_timeout;
 		/* queried upon timeouts */
 	int (*expiry)(ide_drive_t *);
-		/* ide_system_bus_speed */
-	int pio_clock;
+
 	int req_gen;
 	int req_gen_timer;
-
-	unsigned char cmd_buf[4];
 } ide_hwgroup_t;
 
 typedef struct ide_driver_s ide_driver_t;
