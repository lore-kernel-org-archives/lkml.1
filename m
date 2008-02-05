Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbYBEILQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbYBEILQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 03:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYBEILA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 03:11:00 -0500
Received: from mexforward.lss.emc.com ([128.222.32.20]:12066 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbYBEIK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 03:10:59 -0500
From: Ballabio_Dario@emc.com
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH][drivers/scsi/u14-34f.c] duplicate test 'SCpnt->sc_data_direction == DMA_FROM_DEVICE'
Date: Tue, 5 Feb 2008 03:09:47 -0500
Message-ID: <59E10AE3DC203E4AAA41B001A2FF2AB8087E25C0@CORPUSMX30B.corp.emc.com>
In-Reply-To: <47A7937C.7040701@tiscali.nl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH][drivers/scsi/u14-34f.c] duplicate test 'SCpnt->sc_data_direction == DMA_FROM_DEVICE'
Thread-Index: Achnfm+dsPQNe224TrWR5acy00t5KgAT7wKQ
References: <47A7937C.7040701@tiscali.nl>
To: <12o3l@tiscali.nl>
Cc: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 05 Feb 2008 08:10:47.0920 (UTC) FILETIME=[9D3FFF00:01C867CE]
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.30.53115
X-PerlMx-Spam: Gauge=, SPAM=1%, Reason='EMC_FROM_0+ -3, NO_REAL_NAME 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __IMS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
X-Tablus-Inspected: yes
X-Tablus-Classifications: public
X-Tablus-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Good to know that somebody still uses the Ultrastor 14f board :).....
Yes, this typo was introduced by somebody doing massive editing to all
scsi drivers long ago.
Cheers,
--db
 

-----Original Message-----
From: Roel Kluin [mailto:12o3l@tiscali.nl] 
Sent: Monday, February 04, 2008 11:37 PM
To: Ballabio, Dario
Cc: linux-scsi@vger.kernel.org; lkml
Subject: [PATCH][drivers/scsi/u14-34f.c] duplicate test
'SCpnt->sc_data_direction == DMA_FROM_DEVICE'

It should be like this I guess? this patch was not yet tested, please
confirm.
--
Note the duplicate test 'SCpnt->sc_data_direction == DMA_FROM_DEVICE'

from Documentation/DMA-API.txt:
DMA_TO_DEVICE         = PCI_DMA_TODEVICE      data is going from the
                                              memory to the device
DMA_FROM_DEVICE       = PCI_DMA_FROMDEVICE    data is coming from
                                              the device to the

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 662c004..1e704f9 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1208,15 +1208,15 @@ static void scsi_to_dev_dir(unsigned int i,
unsigned int j) {
       };
 
    struct mscp *cpp;
    struct scsi_cmnd *SCpnt;
 
    cpp = &HD(j)->cp[i]; SCpnt = cpp->SCpnt;
 
-   if (SCpnt->sc_data_direction == DMA_FROM_DEVICE) {
+   if (SCpnt->sc_data_direction == DMA_TO_DEVICE) {
       cpp->xdir = DTD_IN;
       return;
       }
    else if (SCpnt->sc_data_direction == DMA_FROM_DEVICE) {
       cpp->xdir = DTD_OUT;
       return;
       }


