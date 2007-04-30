Return-Path: <linux-kernel-owner+w=401wt.eu-S1031452AbXD3Ihg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031452AbXD3Ihg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 04:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031459AbXD3Ihf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 04:37:35 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:33884 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031452AbXD3Ihe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 04:37:34 -0400
X-Originating-Ip: 74.109.98.66
Date: Mon, 30 Apr 2007 04:37:22 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] SCSI: Remove redundant GFP_KERNEL type flag in kmalloc().
Message-ID: <Pine.LNX.4.64.0704300434460.3703@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the apparently redundant GFP_KERNEL type flag in the call to
kmalloc().

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index a988d5a..765ded0 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -6581,7 +6581,7 @@ aic7xxx_slave_alloc(struct scsi_device *SDptr)
   struct aic7xxx_host *p = (struct aic7xxx_host *)SDptr->host->hostdata;
   struct aic_dev_data *aic_dev;

-  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
+  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC);
   if(!aic_dev)
     return 1;
   /*
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
