Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbYDJHep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbYDJHep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 03:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbYDJHeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 03:34:37 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:52452 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbYDJHeg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 03:34:36 -0400
X-IronPort-AV: E=Sophos;i="4.25,634,1199682000"; 
   d="scan'208";a="51682368"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] blackfin: bfin_reset_controller() busy flag appears cleared when it is not
Date: Thu, 10 Apr 2008 15:35:02 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA01C82658@chinexm1.ad.analog.com>
In-Reply-To: <47FC8F8F.5050200@tiscali.nl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] blackfin: bfin_reset_controller() busy flag appears cleared when it is not
Thread-Index: AciaJhHoa07na6i/TAOqzVBwrgjqfQAtyS8Q
References: <47FC8F8F.5050200@tiscali.nl>
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: "Roel Kluin" <12o3l@tiscali.nl>, <sonic.zhang@analog.com>
Cc: <uclinux-dist-devel@blackfin.uclinux.org>,
       "lkml" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Apr 2008 07:34:34.0962 (UTC) FILETIME=[52EAAB20:01C89ADD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Sonic Zhang <sonic.zhang@analog.com> 

-----Original Message-----
From: Roel Kluin [mailto:12o3l@tiscali.nl] 
Sent: Wednesday, April 09, 2008 5:43 PM
To: sonic.zhang@analog.com
Cc: uclinux-dist-devel@blackfin.uclinux.org; lkml
Subject: [PATCH] blackfin: bfin_reset_controller() busy flag appears
cleared when it is not

When count reaches 0 the postfix decrement still subtracts (to -1), so
bfin_reset_controller() returns as if the busy flag was cleared while it
was not.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c index
7f87f10..4208c49 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1442,15 +1442,15 @@ static int bfin_reset_controller(struct ata_host
*host)
 	ATAPI_SET_CONTROL(base, ATAPI_GET_CONTROL(base) & ~DEV_RST);
 	msleep(2);
 
 	/* Wait on Busy flag to clear */
 	count = 10000000;
 	do {
 		status = read_atapi_register(base, ATA_REG_STATUS);
-	} while (count-- && (status & ATA_BUSY));
+	} while (--count && (status & ATA_BUSY));
 
 	/* Enable only ATAPI Device interrupt */
 	ATAPI_SET_INT_MASK(base, 1);
 	SSYNC();
 
 	return (!count);
 }
