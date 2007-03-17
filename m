Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbXCQTai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbXCQTai (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 15:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbXCQTai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 15:30:38 -0400
Received: from tag.witbe.net ([81.88.96.48]:49398 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbXCQTag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 15:30:36 -0400
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Alan Cox'" <alan@redhat.com>
Cc: "'Tejun Heo'" <htejun@gmail.com>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Jeff Garzik'" <jeff@garzik.org>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       <linux-ide@vger.kernel.org>, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: RE: [git patches] libata fixes
Date: Sat, 17 Mar 2007 20:29:53 +0100
Organization: AS2917.net
Message-ID: <00b701c768ca$a3919ca0$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <20070317185607.GC18870@devserv.devel.redhat.com>
Thread-Index: AcdoxfrdMr0aLpKDT/CWO2soIU/5SAAA/UPw
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> Please match the firmware version as well for the Maxtor drives
Ok.
 
> > --- linux-2.6.21-rc4/drivers/ata/libata-core.c  2007-03-17 
> 19:29:45.000000000
> > +0100
> > +++ linux-2.6.21-rc4-Maxtor/drivers/ata/libata-core.c   2007-03-17
> > 19:37:28.000000000 +0100
> > @@ -3359,6 +3359,8 @@
> >          { "WDC WD740ADFD-00",   NULL,          ATA_HORKAGE_NONCQ },
> >         /* http://thread.gmane.org/gmane.linux.ide/14907 */
> >         { "FUJITSU MHT2060BH",  NULL,           ATA_HORKAGE_NONCQ },
> > +       /* NCQ is broken */
> > +       { "Maxtor 6L250S0",     NULL,           
> ATA_HORKAGE_NONCQ }, 
> >  
> >         /* Devices with NCQ limits */
> >  
> > 
> > Signed-off-by: Paul Rolland <rol@as2917.net>
> 
> NAK - but add the firmware to the match and you can have an Ack 8)

Second try, compiled _and_ boot tested, of course.

dmesg says :
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: Maxtor 6L250S0, BANC1G10, max UDMA/133
ata1.00: 490234752 sectors, multi 0: LBA48 NCQ (not used)
ata1.00: configured for UDMA/133

--- linux-2.6.21-rc4/drivers/ata/libata-core.c  2007-03-17 19:47:49.000000000
+0100
+++ linux-2.6.21-rc4-Maxtor/drivers/ata/libata-core.c   2007-03-17
20:24:01.000000000 +0100
@@ -3359,6 +3359,8 @@
         { "WDC WD740ADFD-00",   NULL,          ATA_HORKAGE_NONCQ },
        /* http://thread.gmane.org/gmane.linux.ide/14907 */
        { "FUJITSU MHT2060BH",  NULL,           ATA_HORKAGE_NONCQ },
+       /* NCQ is broken */
+       { "Maxtor 6L250S0",     "BANC1G10",     ATA_HORKAGE_NONCQ }, 
 
        /* Devices with NCQ limits */

Signed-off-by: Paul Rolland <rol@as2917.net>

Regards,
Paul

