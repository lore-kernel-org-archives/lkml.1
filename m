Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYJHH3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYJHH3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 03:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbYJHH26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 03:28:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60553 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbYJHH25 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 03:28:57 -0400
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: "johnpol@2ka.mipt.ru" <johnpol@2ka.mipt.ru>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>
Date: Wed, 8 Oct 2008 12:55:25 +0530
Subject: [PATCH 4/5] W1: Export w1_read_8 function
Thread-Topic: [PATCH 4/5] W1: Export w1_read_8 function
Thread-Index: AckpFwfRX/MmeudqRFiihm0naWvutQ==
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02D6107AF6@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Madhusudhan Chikkature <madhu.cr@ti.com>

This patch exports the w1_read_8 function for use of drivers.

Signed-off-by: Madhusudhan Chikkature <madhu.cr@ti.com>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/w1.h    |    1 +
 drivers/w1/w1_io.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/w1/w1_io.c
===================================================================
--- linux-2.6.orig/drivers/w1/w1_io.c	2008-09-19 13:39:41.000000000 +0530
+++ linux-2.6/drivers/w1/w1_io.c	2008-09-26 16:39:31.000000000 +0530
@@ -177,7 +177,7 @@ u8 w1_triplet(struct w1_master *dev, int
  * @param dev     the master device
  * @return        the byte read
  */
-static u8 w1_read_8(struct w1_master * dev)
+u8 w1_read_8(struct w1_master * dev)
 {
 	int i;
 	u8 res = 0;
@@ -190,6 +190,7 @@ static u8 w1_read_8(struct w1_master * d
 
 	return res;
 }
+EXPORT_SYMBOL_GPL(w1_read_8);
 
 /**
  * Writes a series of bytes.
Index: linux-2.6/drivers/w1/w1.h
===================================================================
--- linux-2.6.orig/drivers/w1/w1.h	2008-09-19 13:39:41.000000000 +0530
+++ linux-2.6/drivers/w1/w1.h	2008-09-26 16:42:45.000000000 +0530
@@ -189,6 +189,7 @@ struct w1_master *w1_search_master_id(u3
 
 u8 w1_triplet(struct w1_master *dev, int bdir);
 void w1_write_8(struct w1_master *, u8);
+u8 w1_read_8(struct w1_master *);
 int w1_reset_bus(struct w1_master *);
 u8 w1_calc_crc8(u8 *, int);
 void w1_write_block(struct w1_master *, const u8 *, int);