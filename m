Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbZLWI6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbZLWI6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 03:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbZLWI5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 03:57:35 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:58840 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbZLWI5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 03:57:32 -0500
Message-Id: <20091223085551.921624544@vergenet.net>
User-Agent: quilt/0.48-1
Date: Wed, 23 Dec 2009 19:54:49 +1100
Subject: [patch 1/7] [patch] DT3155: Use pci_get_device
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
From: Simon Horman <horms@verge.net.au>
References: <20091223085448.619253793@vergenet.net>
Content-Disposition: inline; filename=dt3155-pci_get_device.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of pci_find_device() is deprecated.

Signed-off-by: Simon Horman <horms@verge.net.au>

--- 

Compile tested only.

Alternatively, if pci_find_device() really needs to be used
then this code needs to depend on PCI_LEGACY.

Index: gregkh-2.6/drivers/staging/dt3155/dt3155_drv.c
===================================================================
--- gregkh-2.6.orig/drivers/staging/dt3155/dt3155_drv.c	2009-12-23 18:41:46.000000000 +1100
+++ gregkh-2.6/drivers/staging/dt3155/dt3155_drv.c	2009-12-23 18:42:29.000000000 +1100
@@ -963,7 +963,7 @@ static int find_PCI (void)
   unsigned long base;
   unsigned char irq;
 
-  while ((pci_dev = pci_find_device
+  while ((pci_dev = pci_get_device
 	  (DT3155_VENDORID, DT3155_DEVICEID, pci_dev)) != NULL)
     {
       pci_index ++;

