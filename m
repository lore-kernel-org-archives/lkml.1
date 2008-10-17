Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbYJQOwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbYJQOwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 10:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbYJQOwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 10:52:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42905 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbYJQOwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 10:52:15 -0400
From: Madhu Chikkature <madhu.cr@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Cc: Madhusudhan Chikkature <madhu.cr@ti.com>
Subject: [Resending PATCH 1/4] W1: export w1_read_8 function
Date: Fri, 17 Oct 2008 20:21:55 +0530
Message-Id: <1224255115-21614-1-git-send-email-madhu.cr@ti.com>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Madhusudhan Chikkature <madhu.cr@ti.com>

This patch exports the w1_read_8 function for use of drivers.
The OMAP HDQ driver(drivers/w1/masters/omap_hdq.c) uses this function.

Signed-off-by: Madhusudhan Chikkature<madhu.cr@ti.com>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
The OMAP HDQ add device patch is dropped from the series
as it has already gone upstream through the linux omap tree

 drivers/w1/w1.h    |    1 +
 drivers/w1/w1_io.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/w1/w1_io.c
===================================================================
--- linux-2.6.orig/drivers/w1/w1_io.c	2008-10-17 08:14:23.000000000 +0530
+++ linux-2.6/drivers/w1/w1_io.c	2008-10-17 17:59:13.021464129 +0530
@@ -217,7 +217,7 @@ u8 w1_triplet(struct w1_master *dev, int
  * @param dev     the master device
  * @return        the byte read
  */
-static u8 w1_read_8(struct w1_master * dev)
+u8 w1_read_8(struct w1_master * dev)
 {
 	int i;
 	u8 res = 0;
@@ -230,6 +230,7 @@ static u8 w1_read_8(struct w1_master * d
 
 	return res;
 }
+EXPORT_SYMBOL_GPL(w1_read_8);
 
 /**
  * Writes a series of bytes.
Index: linux-2.6/drivers/w1/w1.h
===================================================================
--- linux-2.6.orig/drivers/w1/w1.h	2008-10-17 08:14:23.000000000 +0530
+++ linux-2.6/drivers/w1/w1.h	2008-10-17 17:59:13.022464098 +0530
@@ -206,6 +206,7 @@ void w1_slave_detach(struct w1_slave *sl
 
 u8 w1_triplet(struct w1_master *dev, int bdir);
 void w1_write_8(struct w1_master *, u8);
+u8 w1_read_8(struct w1_master *);
 int w1_reset_bus(struct w1_master *);
 u8 w1_calc_crc8(u8 *, int);
 void w1_write_block(struct w1_master *, const u8 *, int);
