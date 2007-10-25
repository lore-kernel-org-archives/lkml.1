Return-Path: <linux-kernel-owner+w=401wt.eu-S1761043AbXJYSkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761043AbXJYSkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbXJYSkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:40:32 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:56739 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbXJYSkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:40:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:subject:message-id:mime-version:content-type:con
	tent-disposition:user-agent;
	b=HMDOd5ynWwBGm923WPnUIsMYzJTF/W2O5IyUIBWJuhUAIRavTwk16YqglxW2e
	mm+OFxV0+6h/wq9zgabKeHzeg==
Date: Thu, 25 Oct 2007 20:40:29 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] pci: get rid of pci_dev::{vendor,device}_compatible fields
Message-ID: <20071025184029.GO7543@xi.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The vendor_compatible and device_compatible fields in struct
pci_dev aren't used anywhere, and are somewhat pointless.  Assuming
that these are historical artifacts, remove them.

Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5d2281f..d503ef1 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -66,7 +66,6 @@ enum pci_mmap_state {
 #define PCI_DMA_FROMDEVICE	2
 #define PCI_DMA_NONE		3
 
-#define DEVICE_COUNT_COMPATIBLE	4
 #define DEVICE_COUNT_RESOURCE	12
 
 typedef int __bitwise pci_power_t;
@@ -159,10 +158,6 @@ struct pci_dev {
 	pci_channel_state_t error_state;	/* current connectivity state */
 	struct	device	dev;		/* Generic device interface */
 
-	/* device is compatible with these IDs */
-	unsigned short vendor_compatible[DEVICE_COUNT_COMPATIBLE];
-	unsigned short device_compatible[DEVICE_COUNT_COMPATIBLE];
-
 	int		cfg_size;	/* Size of configuration space */
 
 	/*
