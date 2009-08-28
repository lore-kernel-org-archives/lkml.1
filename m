Return-Path: <linux-kernel-owner+w=401wt.eu-S1752350AbZH1L0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbZH1L0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 07:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZH1L0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 07:26:40 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56181 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbZH1L0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 07:26:39 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 28 Aug 2009 13:26:03 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/2] firewire: ohci: fix Ricoh R5C832, video reception
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Samuel Audet <samuel.audet@gmail.com>,
       Jonathan Cameron <jic23@cam.ac.uk>
In-Reply-To: <tkrat.9dcf6c9a7dfd35fd@s5r6.in-berlin.de>
Message-ID: <tkrat.ffc1d728eaa9a4a4@s5r6.in-berlin.de>
References: <tkrat.9dcf6c9a7dfd35fd@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In dual-buffer DMA mode, no video frames are ever received from R5C832
by libdc1394.  Fallback to packet-per-buffer DMA works reliably.
http://thread.gmane.org/gmane.linux.kernel.firewire.devel/13393/focus=13476

Reported-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6.31-rc8/drivers/firewire/ohci.c
===================================================================
--- linux-2.6.31-rc8.orig/drivers/firewire/ohci.c
+++ linux-2.6.31-rc8/drivers/firewire/ohci.c
@@ -2431,6 +2431,11 @@ static int __devinit pci_probe(struct pc
 	    dev->device == PCI_DEVICE_ID_AGERE_FW643)
 		ohci->use_dualbuffer = false;
 
+	/* dual-buffer mode is broken */
+	if (dev->vendor == PCI_VENDOR_ID_RICOH &&
+	    dev->device == PCI_DEVICE_ID_RICOH_R5C832)
+		ohci->use_dualbuffer = false;
+
 /* x86-32 currently doesn't use highmem for dma_alloc_coherent */
 #if !defined(CONFIG_X86_32)
 	/* dual-buffer mode is broken with descriptor addresses above 2G */

-- 
Stefan Richter
-=====-==--= =--- ===--
http://arcgraph.de/sr/

