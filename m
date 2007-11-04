Return-Path: <linux-kernel-owner+w=401wt.eu-S1759646AbXKDM17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759646AbXKDM17 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 07:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757435AbXKDM1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 07:27:52 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:42812 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757378AbXKDM1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 07:27:51 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 4 Nov 2007 13:27:33 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 2/3 2.6.24-rc1-gitX] ieee1394: sbp2: s/g list fix
To: linux1394-devel@lists.sourceforge.net
cc: Jens Axboe <jens.axboe@oracle.com>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.fc4a4bf7c1e55a2c@s5r6.in-berlin.de>
Message-ID: <tkrat.157c403547b58840@s5r6.in-berlin.de>
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
Update:
 The loop body doesn't honor the 80 columns limit either.
 Can be cleaned up later by renaming a variable.

 drivers/ieee1394/sbp2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -1489,7 +1489,7 @@ static void sbp2_prep_command_orb_sg(str
 
 		/* loop through and fill out our SBP-2 page tables
 		 * (and split up anything too large) */
-		for (i = 0, sg_count = 0 ; i < count; i++, sgpnt++) {
+		for (i = 0, sg_count = 0; i < count; i++, sgpnt = sg_next(sgpnt)) {
 			sg_len = sg_dma_len(sgpnt);
 			sg_addr = sg_dma_address(sgpnt);
 			while (sg_len) {

-- 
Stefan Richter
-=====-=-=== =-== --=--
http://arcgraph.de/sr/

