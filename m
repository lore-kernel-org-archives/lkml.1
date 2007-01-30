Return-Path: <linux-kernel-owner+w=401wt.eu-S965675AbXA3SIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965675AbXA3SIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 13:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965674AbXA3SIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 13:08:23 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:39785 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965675AbXA3SIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 13:08:22 -0500
Date: Tue, 30 Jan 2007 13:08:19 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Soeren Sonnenburg <kernel@nn7.de>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] 2.6.20-rc6 SCSI error: I/O error - trouble
 with mass storage devices ?!
In-Reply-To: <1169909796.2462.56.camel@localhost>
Message-ID: <Pine.LNX.4.44L0.0701301300050.7522-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jan 2007, Soeren Sonnenburg wrote:

> Dear all,
> 
> I am trying to use a P990 phone in via mass storage under linux. I was
> able to copy data to/from the phone without trouble under winxp but
> receive millions of I/O errors (see below (*), basically on any sector).
> As this was also happening on a casio camera (and working on winxp) I
> tried a couple of things to nail this down:

...

> 4) I enabled usb mass storage verbose debug output and collected 2 runs
> of I/O once with the sandisk and one with the P990 (attached as sandisk
> and p990)

...

> Now I am clueless what could have gone wrong (as I *think* this was all
> working at some point at least before firmware updates) and what the
> difference between these mass storage devices is.

The log revealed that the phone's firmware returns garbage values in the 
Residue field for some WRITEs.  This patch should take care of it.

Alan Stern



Index: usb-2.6/drivers/usb/storage/unusual_devs.h
===================================================================
--- usb-2.6.orig/drivers/usb/storage/unusual_devs.h
+++ usb-2.6/drivers/usb/storage/unusual_devs.h
@@ -1318,12 +1318,13 @@ UNUSUAL_DEV(  0x0fce, 0xe031, 0x0000, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY ),
 
-/* Reported by Jan Mate <mate@fiit.stuba.sk> */
+/* Reported by Jan Mate <mate@fiit.stuba.sk>
+ * and by Soeren Sonnenburg <kernel@nn7.de> */
 UNUSUAL_DEV(  0x0fce, 0xe030, 0x0000, 0x0000,
 		"Sony Ericsson",
 		"P990i",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
-		US_FL_FIX_CAPACITY ),
+		US_FL_FIX_CAPACITY | US_FL_IGNORE_RESIDUE ),
 
 /* Reported by Kevin Cernekee <kpc-usbdev@gelato.uiuc.edu>
  * Tested on hardware version 1.10.

