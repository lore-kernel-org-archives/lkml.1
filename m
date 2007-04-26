Return-Path: <linux-kernel-owner+w=401wt.eu-S933770AbXDZJUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770AbXDZJUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933771AbXDZJUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:20:55 -0400
Received: from lizzard.sbs.de ([194.138.37.39]:17623 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933770AbXDZJUx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:20:53 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] ide-cs: recognize 2GB CompactFlash from Transcend
Date: Thu, 26 Apr 2007 11:21:01 +0200
Message-ID: <D7810733513F4840B4EBAAFA64D9C6A4012D6188@stgw002a.ww002.siemens.net>
In-Reply-To: <20070425171533.22efa133.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ide-cs: recognize 2GB CompactFlash from Transcend
Thread-Index: AceHmBBXg88AlzzVR+6GbPtwTLxjuAASieIA
From: "Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-pcmcia@lists.infradead.org>, "lkml" <linux-kernel@vger.kernel.org>,
       "Dominik Brodowski" <linux@dominikbrodowski.net>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Aeschbacher, Fabrice" <Fabrice.Aeschbacher@siemens.com>
X-OriginalArrivalTime: 26 Apr 2007 09:20:18.0398 (UTC) FILETIME=[1B51AFE0:01C787E4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed to by Peter, and also as indicated by a judicious output in
dmesg, the 4th parameter should be 0x969aa4f2. Please find below the
corrected patch:

Signed-off-by: Fabrice Aeschbacher <fabrice.aeschbacher@siemens.com>

===================================================================
--- linux-2.6.20.7-orig/drivers/ide/legacy/ide-cs.c	2007-04-15
21:08:02.000000000 +0200
+++ linux-2.6.20.7/drivers/ide/legacy/ide-cs.c	2007-04-26
11:13:13.000000000 +0200
@@ -399,6 +399,7 @@
 	PCMCIA_DEVICE_PROD_ID12("TOSHIBA", "MK2001MPL", 0xb4585a1a,
0x3489e003),
 	PCMCIA_DEVICE_PROD_ID1("TRANSCEND    512M   ", 0xd0909443),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1,
0x2a54d4b1),
+	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1,
0x969aa4f2),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1,
0xf54a91c8),
 	PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 0x3e232852),
 	PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c,
0x212bb918),
===================================================================
 

> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org] 
> Sent: Donnerstag, 26. April 2007 02:16
> To: Aeschbacher, Fabrice
> Cc: linux-pcmcia@lists.infradead.org; lkml; Dominik 
> Brodowski; Bartlomiej Zolnierkiewicz
> Subject: Re: [PATCH] ide-cs: recognize 2GB CompactFlash from Transcend
> 
> On Wed, 25 Apr 2007 11:27:09 +0200 "Aeschbacher, Fabrice" 
> <Fabrice.Aeschbacher@siemens.com> wrote:
> 
> > Without the following patch, the kernel does not 
> automatically detect 
> > 2GB CompactFlash cards from Transcend.
> > 
> > I'm not sure which correct values must be assigned to the 
> 3th and 4th 
> > parameters (here: 0x709b1bf1, 0xf54a91c8). Anyway, the patch is 
> > working with these values. Tested on arch=mips.
> > 
> 
> Thanks.  Your patch was wordwrapped and had tabs replaced by 
> spaces, btw.
> 
> > 
> > ===================================================================
> > --- linux-2.6.20.7-orig/drivers/ide/legacy/ide-cs.c     2007-04-15
> > 21:08:02.000000000 +0200
> > +++ linux-2.6.20.7/drivers/ide/legacy/ide-cs.c  2007-04-25
> > 10:53:53.000000000 +0200
> > @@ -64,6 +64,7 @@
> >  
> >  #define INT_MODULE_PARM(n, v) static int n = v; 
> module_param(n, int, 
> > 0)
> >  
> > +#define PCMCIA_DEBUG 1
> >  #ifdef PCMCIA_DEBUG
> >  INT_MODULE_PARM(pc_debug, PCMCIA_DEBUG);  #define DEBUG(n, 
> args...) 
> > if (pc_debug>(n)) printk(KERN_DEBUG args)
> 
> I removed the above change
> 
> > @@ -399,6 +400,7 @@
> >         PCMCIA_DEVICE_PROD_ID12("TOSHIBA", "MK2001MPL", 0xb4585a1a, 
> > 0x3489e003),
> >         PCMCIA_DEVICE_PROD_ID1("TRANSCEND    512M   ", 0xd0909443),
> >         PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 
> 0x709b1bf1, 
> > 0x2a54d4b1),
> > +       PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 
> 0x709b1bf1,
> > 0xf54a91c8),
> >         PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 
> 0x709b1bf1, 
> > 0xf54a91c8),
> >         PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 
> 0x3e232852),
> >         PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c, 
> > 0x212bb918),
> 
> I'm never sure whether it's Bart or Dominik who handles 
> pcmcia-cs patches.
> 
