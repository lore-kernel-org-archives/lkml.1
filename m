Return-Path: <linux-kernel-owner+w=401wt.eu-S1756947AbZKMPQC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbZKMPQC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 10:16:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756876AbZKMPP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 10:15:56 -0500
Received: from mtagate4.de.ibm.com ([195.212.17.164]:36465 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009AbZKMPJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 10:09:05 -0500
Message-Id: <20091113150912.928971346@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 13 Nov 2009 16:08:45 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Stefan Weinhuber <wein@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 21/52] [PATCH] dasd: enable prefix independent of pav support
References: <20091113150824.351347652@de.ibm.com>
Content-Disposition: inline; filename=120-dasd-enable-prefix.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Weinhuber <wein@de.ibm.com>

The DASD device driver needs to explicitly enable the prefix command
on the storage server, before it can be used. Originally we enabled
this command along with others only if we wanted to support PAV.
However, today we require this command for other features like
High Performance FICON as well, so we need to always enable prefix.

Signed-off-by: Stefan Weinhuber <wein@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/block/dasd_eckd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: quilt-2.6/drivers/s390/block/dasd_eckd.c
===================================================================
--- quilt-2.6.orig/drivers/s390/block/dasd_eckd.c	2009-11-13 16:08:14.000000000 +0100
+++ quilt-2.6/drivers/s390/block/dasd_eckd.c	2009-11-13 16:08:16.000000000 +0100
@@ -1011,9 +1011,9 @@
 	}
 	psf_ssc_data = (struct dasd_psf_ssc_data *)cqr->data;
 	psf_ssc_data->order = PSF_ORDER_SSC;
-	psf_ssc_data->suborder = 0x40;
+	psf_ssc_data->suborder = 0xc0;
 	if (enable_pav) {
-		psf_ssc_data->suborder |= 0x88;
+		psf_ssc_data->suborder |= 0x08;
 		psf_ssc_data->reserved[0] = 0x88;
 	}
 	ccw = cqr->cpaddr;

