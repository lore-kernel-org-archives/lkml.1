Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbYGOOO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbYGOOO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 10:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755662AbYGOOOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 10:14:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087AbYGOOOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:14:17 -0400
Date: Tue, 15 Jul 2008 10:14:12 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@devserv.devel.redhat.com
To: torvalds@linux-foundation.org
cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] BUG_ON on kernel misbehavior on A100U2W driver
In-Reply-To: <Pine.LNX.4.64.0807151011350.24544@devserv.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.0807151012200.24544@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0807151008370.24544@devserv.devel.redhat.com>
 <Pine.LNX.4.64.0807151011350.24544@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With broken Sparc64 IOMMU accounting, the kernel submits larger requests 
then allowed. Better to crash on BUG than corrupt memory. This needs to be 
fixed in sparc64 code.

For description of the crashes, see: 
http://www.uwsg.indiana.edu/hypermail/linux/kernel/0807.1/1465.html

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
  drivers/scsi/a100u2w.c |    1 +
  1 file changed, 1 insertion(+)

Index: linux-2.6.26-devel/drivers/scsi/a100u2w.c
===================================================================
--- linux-2.6.26-devel.orig/drivers/scsi/a100u2w.c	2008-07-14 20:03:43.000000000 +0200
+++ linux-2.6.26-devel/drivers/scsi/a100u2w.c	2008-07-15 00:46:02.000000000 +0200
@@ -866,6 +866,7 @@ static void inia100_build_scb(struct orc

  	count_sg = scsi_dma_map(cmd);
  	BUG_ON(count_sg < 0);
+	BUG_ON(count_sg > TOTAL_SG_ENTRY);

  	/* Build the scatter gather lists */
  	if (count_sg) {
