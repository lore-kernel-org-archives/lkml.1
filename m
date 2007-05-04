Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbXEDNbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbXEDNbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 09:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbXEDNbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 09:31:40 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:38824 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235AbXEDNbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 09:31:38 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Fri, 4 May 2007 19:01:08 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: linux-kernel@vger.kernel.org
cc: akpm@linux-foundation.org, rpjday@mindspring.com,
       james.bottomley@steeleye.com, linux-scsi@vger.kernel.org,
       dledford@redhat.com
Subject: [PATCH] drivers/scsi/aic7xxx_old.c: remove redundant GFP_ATOMIC from
 kmalloc
Message-ID: <Pine.LNX.4.64.0705041858260.13758@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/scsi/aic7xxx_old.c:aic7xxx_slave_alloc() unnecessarily passes 
GFP_ATOMIC (along with GFP_KERNEL) to kmalloc() from a context that is not 
atomic. Remove the pointless GFP_ATOMIC.

 	Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>

---

diff -ruNp linux-2.6.21.1/drivers/scsi/aic7xxx_old.c linux-2.6.21.1~patch/drivers/scsi/aic7xxx_old.c
--- linux-2.6.21.1/drivers/scsi/aic7xxx_old.c	2007-04-26 08:38:32.000000000 +0530
+++ linux-2.6.21.1~patch/drivers/scsi/aic7xxx_old.c	2007-05-04 17:47:26.000000000 +0530
@@ -6581,7 +6581,7 @@ aic7xxx_slave_alloc(struct scsi_device *
    struct aic7xxx_host *p = (struct aic7xxx_host *)SDptr->host->hostdata;
    struct aic_dev_data *aic_dev;

-  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
+  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_KERNEL);
    if(!aic_dev)
      return 1;
    /*
