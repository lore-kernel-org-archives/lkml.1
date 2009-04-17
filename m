Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbZDQFLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbZDQFLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 01:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbZDQFLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 01:11:31 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:16301 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZDQFLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 01:11:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :user-agent;
        b=L7WTrtmbeccEzX7sPxjr0bKxbK5/GHYnvKL2suDvXJeRgWFDKL7wcdAp3x5Qr7bpuO
         V7pNtBrRbzLNmw/YEMCe4Rev3AqwMmwIWDwRp3Hk59TJ34qircYVGMW/loqxC4k887gu
         xwekeyUiubTGZL5bawlML++2liueF3Mh8g6sc=
Date: Fri, 17 Apr 2009 13:09:59 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: [PATCH] fix error on drivers/ata/pata_legacy.c
Message-ID: <20090417050959.GA5717@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix those errors:

drivers/ata/pata_legacy.c: In function ‘pdc_data_xfer_vlb’:
drivers/ata/pata_legacy.c:289: error: ‘ap’ undeclared (first use in this function)
drivers/ata/pata_legacy.c:289: error: (Each undeclared identifier is reported only once
drivers/ata/pata_legacy.c:289: error: for each function it appears in.)
drivers/ata/pata_legacy.c: At top level:
drivers/ata/pata_legacy.c:869: error: ‘ATA_PFLAG_PIO32_CHANGE’ undeclared here (not in a function)
make[2]: *** [drivers/ata/pata_legacy.o] Error 1
make[1]: *** [drivers/ata] Error 2


>From 9aa998af4bdcd49ef8e5c5572ded1434ab4acb98 Mon Sep 17 00:00:00 2001
From: Zhenwen Xu <Helight.Xu@gmail.com>
Date: Fri, 17 Apr 2009 13:04:50 +0800
Subject: [PATCH] fix error ong drivers/ata/pata_legacy.c

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
---
 drivers/ata/pata_legacy.c |    3 ++-
 include/linux/libata.h    |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 6f985be..58e3855 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -285,10 +285,11 @@ static unsigned int pdc_data_xfer_vlb(struct ata_device *dev,
 			unsigned char *buf, unsigned int buflen, int rw)
 {
 	int slop = buflen & 3;
+	struct ata_port *ap = dev->link->ap;
+
 	/* 32bit I/O capable *and* we need to write a whole number of dwords */
 	if (ata_id_has_dword_io(dev->id) && (slop == 0 || slop == 3)
 					&& (ap->pflags & ATA_PFLAG_PIO32)) {
-		struct ata_port *ap = dev->link->ap;
 		unsigned long flags;
 
 		local_irq_save(flags);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 3d501db..1fdd3eb 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -227,7 +227,7 @@ enum {
 	ATA_PFLAG_INIT_GTM_VALID = (1 << 19), /* initial gtm data valid */
 
 	ATA_PFLAG_PIO32		= (1 << 20),  /* 32bit PIO */
-	ATA_PFLAG_PIO32CHANGE	= (1 << 21),  /* 32bit PIO can be turned on/off */
+	ATA_PFLAG_PIO32_CHANGE	= (1 << 21),  /* 32bit PIO can be turned on/off */
 
 	/* struct ata_queued_cmd flags */
 	ATA_QCFLAG_ACTIVE	= (1 << 0), /* cmd not yet ack'd to scsi lyer */
-- 
1.5.6.5

-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org
My Studio:	http://dim4.cn
