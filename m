Return-Path: <linux-kernel-owner+w=401wt.eu-S1760112AbXKDML1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112AbXKDML1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 07:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbXKDMLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 07:11:19 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:42206 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbXKDMLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 07:11:19 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 4 Nov 2007 13:10:14 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/3 2.6.24-rc1-gitX] firewire: fw-sbp2: s/g list fix
To: linux1394-devel@lists.sourceforge.net
cc: Jens Axboe <jens.axboe@oracle.com>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.fc4a4bf7c1e55a2c@s5r6.in-berlin.de>
Message-ID: <tkrat.e7c46ab309702d72@s5r6.in-berlin.de>
References: <64bb37e0711021503x4844b905yba1e9a681c4e788a@mail.gmail.com> 
 <472BA567.8040301@s5r6.in-berlin.de> 
 <64bb37e0711030614q4be3a2b6j5d3c55b26cb07030@mail.gmail.com> 
 <472C88E9.60103@s5r6.in-berlin.de> <20071103160404.GH28340@kernel.dk> 
 <20071104084456.GJ28340@kernel.dk>
 <64bb37e0711040251w4d08ac83n1e090a8fab19d3d8@mail.gmail.com>
 <tkrat.e565b61745a1b175@s5r6.in-berlin.de>
 <tkrat.fc4a4bf7c1e55a2c@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don't panic on chained s/g lists.  Only compile-tested.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -1100,9 +1100,9 @@ sbp2_map_scatterlist(struct sbp2_command
 	 * elements larger than 65535 bytes, some IOMMUs may merge sg elements
 	 * during DMA mapping, and Linux currently doesn't prevent this.
 	 */
-	for (i = 0, j = 0; i < count; i++) {
-		sg_len = sg_dma_len(sg + i);
-		sg_addr = sg_dma_address(sg + i);
+	for (i = 0, j = 0; i < count; i++, sg = sg_next(sg)) {
+		sg_len = sg_dma_len(sg);
+		sg_addr = sg_dma_address(sg);
 		while (sg_len) {
 			/* FIXME: This won't get us out of the pinch. */
 			if (unlikely(j >= ARRAY_SIZE(orb->page_table))) {

-- 
Stefan Richter
-=====-=-=== =-== --=--
http://arcgraph.de/sr/

