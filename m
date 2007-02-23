Return-Path: <linux-kernel-owner+w=401wt.eu-S932387AbXBWOOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387AbXBWOOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 09:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932395AbXBWOOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 09:14:06 -0500
Received: from mail-gw3.adaptec.com ([216.52.22.36]:55921 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387AbXBWOOF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 09:14:05 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Patch] bug in gdth.c crashing machine
Date: Fri, 23 Feb 2007 15:13:46 +0100
Message-ID: <D0623D6A71405C429DBFB3928CDC9E29013163@mtce2k301.adaptec.com>
In-Reply-To: <20070223132955.GQ3250@Redstar.dorchain.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Patch] bug in gdth.c crashing machine
Thread-Index: AcdXTsF2u8CuYG2nTVeDd/24cKP//wABd/Hg
From: "Leubner, Achim" <Achim_Leubner@adaptec.com>
To: "Joerg Dorchain" <joerg@dorchain.net>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

You are right, this patch should be added to a bugfix release as soon as
possible. 

Thanks,
Achim

=======================
Achim Leubner
Software Engineer / RAID drivers
ICP vortex GmbH / Adaptec Inc.
Phone: +49-351-8718291
 

-----Original Message-----
From: Joerg Dorchain [mailto:joerg@dorchain.net] 
Sent: Freitag, 23. Februar 2007 14:30
To: Leubner, Achim
Cc: linux-kernel@vger.kernel.org
Subject: [Patch] bug in gdth.c crashing machine

Hello Achim,

wrt to your mail to the lkml from 13 Oct 2006 Message-ID:
<EF6AF37986D67948AD48624A3E5D93AFE72291@mtce2k01.adaptec.com>,
I'd be pleased if you could integrate the derived patch into a bugfix
release of the driver asap.

This bug kept me busy for three days, endangering  backup to tapes.

Patch is against vanilla 2.6.20.

Kind regards,

Joerg

Signed-off-by: Joerg Dorchain <joerg@dorchain.net>

--- gdth.c.orig	2007-02-23 12:48:56.000000000 +0100
+++ gdth.c	2007-02-23 12:51:44.000000000 +0100
@@ -3092,6 +3092,7 @@
             cmdp->u.raw64.direction  = 
                 gdth_direction_tab[scp->cmnd[0]]==DOU ?
GDTH_DATA_OUT:GDTH_DATA_IN;
             memcpy(cmdp->u.raw64.cmd,scp->cmnd,16);
+            cmdp->u.raw64.sg_ranz    = 0;
         } else {
             cmdp->u.raw.reserved   = 0;
             cmdp->u.raw.mdisc_time = 0;
@@ -3108,6 +3109,7 @@
             cmdp->u.raw.direction  = 
                 gdth_direction_tab[scp->cmnd[0]]==DOU ?
GDTH_DATA_OUT:GDTH_DATA_IN;
             memcpy(cmdp->u.raw.cmd,scp->cmnd,12);
+            cmdp->u.raw.sg_ranz    = 0;
         }
 
         if (scp->use_sg) {
