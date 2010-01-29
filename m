Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157Ab0A2QF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0A2QF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762Ab0A2QFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:05:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:45357 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab0A2QFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:05:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=I5svhypPJC1DrqEq9rdXvZSCuqofcUP0VOZJGe6+Qty1cnBM+gCEhjf4lExCGHnDiV
         wr0jlpChDRGeGOBx8MNTuwPiqs+u0tQF057TIb3bVHo+IGIUGxhOaklpKDC5kEq8bf6p
         gBtZB0XUCswTfczszr/rtoYeCZiv4YiSumx1w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:05:12 +0100
Message-Id: <20100129160512.21495.75268.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 19/68] ide: add hwif->port_no field
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: add hwif->port_no field

Add port_no field to ide_hwif_t matching port_no field used in
struct ata_port.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/ide.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -682,7 +682,12 @@ typedef struct hwif_s {
 
 	u8 major;	/* our major number */
 	u8 index;	/* 0 for ide0; 1 for ide1; ... */
-	u8 channel;	/* for dual-port chips: 0=primary, 1=secondary */
+
+	union {
+		/* for dual-port chips: 0=primary, 1=secondary */
+		u8 channel;
+		u8 port_no;
+	};
 
 	u32 host_flags;
 
