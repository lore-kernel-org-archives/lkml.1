Return-Path: <linux-kernel-owner+w=401wt.eu-S1759763AbZDQHel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763AbZDQHel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 03:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759327AbZDQHeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 03:34:31 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:25349 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbZDQHea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 03:34:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :user-agent;
        b=ZKEGpQVEN2N+/akhY+vmb0XmeUA5tHW/uIpn/2wjRgyKXIUDV192bqNtd45YkXSwxb
         /STXyc87uHRysyanMrMDy2cqgU1ON13oA2xErxqWlldidgujLTpF2OhOG5+WqjSm4Dgw
         An+S7BHE228S0RG1ansMFZuxb7X78eoNeT0yo=
Date: Fri, 17 Apr 2009 15:32:59 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: [PATCH] v3 fix error on drivers/ata/pata_legacy.c
Message-ID: <20090417073259.GA6366@helight>
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
drivers/ata/pata_legacy.c:869: error: ‘ATA_PFLAG_PIO32_CHANGE’ undeclared here (not in a
+function)
make[2]: *** [drivers/ata/pata_legacy.o] Error 1
make[1]: *** [drivers/ata] Error 2




>From 171dedab9e29534e911e0f4d23ea0a183edf75e9 Mon Sep 17 00:00:00 2001
From: Zhenwen Xu <Helight.Xu@gmail.com>
Date: Fri, 17 Apr 2009 15:30:54 +0800
Subject: [PATCH] fix error on drivers/ata/pata_legacy.c

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
---
 drivers/ata/pata_legacy.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 6f985be..f72c6c5 100644
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
@@ -866,7 +867,7 @@ static struct legacy_controller controllers[] = {
 			0,			0,			NULL },
 	{"PDC20230",	&pdc20230_port_ops,	0x7,
 			ATA_FLAG_NO_IORDY,
-			ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32_CHANGE,	NULL },
+			ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE,	NULL },
 	{"HT6560A",	&ht6560a_port_ops,	0x07,
 			ATA_FLAG_NO_IORDY,	0,			NULL },
 	{"HT6560B",	&ht6560b_port_ops,	0x1F,
@@ -877,13 +878,13 @@ static struct legacy_controller controllers[] = {
 			0,			0,			NULL },
 	{"QDI6500",	&qdi6500_port_ops,	0x07,
 			ATA_FLAG_NO_IORDY,
-			ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32_CHANGE,    qdi_port },
+			ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE,    qdi_port },
 	{"QDI6580",	&qdi6580_port_ops,	0x1F,
-			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32_CHANGE, qdi_port },
+			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE, qdi_port },
 	{"QDI6580DP",	&qdi6580dp_port_ops,	0x1F,
-			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32_CHANGE, qdi_port },
+			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE, qdi_port },
 	{"W83759A",	&winbond_port_ops,	0x1F,
-			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32_CHANGE,
+			0, ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE,
 								winbond_port }
 };
 
-- 
1.5.6.5

-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org
My Studio:	http://dim4.cn
