Return-Path: <linux-kernel-owner+w=401wt.eu-S933541AbXEEVRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541AbXEEVRZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 17:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933613AbXEEVRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 17:17:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:34707 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933541AbXEEVRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 17:17:24 -0400
Date: Sat, 5 May 2007 23:17:13 +0200
From: Olaf Hering <olh@suse.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: krh@redhat.com, linux-kernel@vger.kernel.org,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       akpm@linux-foundation.org, linux1394-devel@lists.sourceforge.net,
       torvalds@linux-foundation.org
Subject: Re: [git pull] New firewire stack
Message-ID: <20070505211713.GA4016@suse.de>
References: <200705030004.l4304l8h012587@turbo.physics.adelaide.edu.au> <46399BDE.4040605@s5r6.in-berlin.de> <20070503114854.GA12731@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070503114854.GA12731@suse.de>
X-DOS: I got your 640K Real Mode Right Here Buddy!
X-Homeland-Security: You are not supposed to read this line! You are a terrorist!
User-Agent: Mutt und vi sind doch schneller als Notes (und GroupWise)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, Olaf Hering wrote:

> On Thu, May 03, Stefan Richter wrote:
> 
> > 	ieee1394-old
> 
> Noone will seriously ship two firewire stacks, so that cant be the
> issue (for distributors). 
> 
> Once there is a way to easily switch between kernel releases, I'm ok
> with whatever module names you pick. 

This patch loads fw-sbp2 if sbp2 is still in the config file. So one can
go back and forth between releases without worry about the root
filesystem drivers.

Index: linux-2.6.21/drivers/firewire/fw-ohci.c
===================================================================
--- linux-2.6.21.orig/drivers/firewire/fw-ohci.c
+++ linux-2.6.21/drivers/firewire/fw-ohci.c
@@ -1881,6 +1881,9 @@ static struct pci_driver fw_ohci_pci_dri
 MODULE_AUTHOR("Kristian Hoegsberg <krh@bitplanet.net>");
 MODULE_DESCRIPTION("Driver for PCI OHCI IEEE1394 controllers");
 MODULE_LICENSE("GPL");
+#ifndef CONFIG_IEEE1394_OHCI1394_MODULE
+MODULE_ALIAS("ohci1394");
+#endif
 
 static int __init fw_ohci_init(void)
 {
Index: linux-2.6.21/drivers/firewire/fw-sbp2.c
===================================================================
--- linux-2.6.21.orig/drivers/firewire/fw-sbp2.c
+++ linux-2.6.21/drivers/firewire/fw-sbp2.c
@@ -1150,6 +1150,9 @@ MODULE_AUTHOR("Kristian Hoegsberg <krh@b
 MODULE_DESCRIPTION("SCSI over IEEE1394");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(ieee1394, sbp2_id_table);
+#ifndef CONFIG_IEEE1394_SBP2_MODULE
+MODULE_ALIAS("sbp2");
+#endif
 
 static int __init sbp2_init(void)
 {

