Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbYHPD1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbYHPD1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 23:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbYHPD1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 23:27:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60208 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbYHPD1E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 23:27:04 -0400
Message-Id: <200808160326.m7G3QR1G012726@terminus.zytor.com>
MIME-Version: 1.0
content-class: 
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: RE: [PATCH] pci: change msi-x vector to 32bit
Date: Fri, 15 Aug 2008 20:26:33 -0700
Importance: normal
X-Priority: 3
To: Yinghai Lu <yhlu.kernel@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 28 bits aren't enough, are they: we need domain as well (and surely we can have more than 16 domains?)

    -hpa

-- 
Sent from my mobile phone (pardon any lack of formatting)


-----Original Message-----
From: Yinghai Lu <yhlu.kernel@gmail.com>
Sent: Friday, August 15, 2008 19:36
To: Jesse Barnes <jbarnes@virtuousgeek.org>; James Bottomley <James.Bottomley@hansenpartnership.com>; Ingo Molnar <mingo@elte.hu>; Thomas Gleixner <tglx@linutronix.de>; H. Peter Anvin <hpa@zytor.com>; Eric W. Biederman <ebiederm@xmission.com>; Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org; Yinghai Lu <yhlu.kernel@gmail.com>; Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] pci: change msi-x vector to 32bit

we are using 28bit pci (bus/dev/fn + 12 bits) as irq number, so the
cache for irq number should be 32 bit too.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

---
 drivers/scsi/qla2xxx/qla_def.h |    2 +-
 include/linux/pci.h            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/scsi/qla2xxx/qla_def.h
===================================================================
--- linux-2.6.orig/drivers/scsi/qla2xxx/qla_def.h
+++ linux-2.6/drivers/scsi/qla2xxx/qla_def.h
@@ -2109,7 +2109,7 @@ struct scsi_qla_host;
 
 struct qla_msix_entry {
 	int have_irq;
-	uint16_t msix_vector;
+	uint32_t msix_vector;
 	uint16_t msix_entry;
 };
 
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -730,7 +730,7 @@ enum pci_dma_burst_strategy {
 };
 
 struct msix_entry {
-	u16 	vector;	/* kernel uses to write allocated vector */
+	u32	vector;	/* kernel uses to write allocated vector */
 	u16	entry;	/* driver uses to specify entry, OS writes */
 };
 

