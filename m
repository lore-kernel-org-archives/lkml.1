Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbZLWI6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbZLWI6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 03:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbZLWI5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 03:57:34 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:58838 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609AbZLWI5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 03:57:32 -0500
Message-Id: <20091223085552.225938423@vergenet.net>
User-Agent: quilt/0.48-1
Date: Wed, 23 Dec 2009 19:54:50 +1100
Subject: [patch 2/7] [patch] rt2870: rtusb_probe() should be in section __devinit
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
From: Simon Horman <horms@verge.net.au>
References: <20091223085448.619253793@vergenet.net>
Content-Disposition: inline; filename=rt2870-setction-missmatch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ make CONFIG_DEBUG_SECTION_MISMATCH=y
WARNING: drivers/staging/rt2870/rt2870sta.o(.text+0x2f4c5): Section
mismatch in reference from the function rtusb_probe() to the function .devinit.text:rt2870_probe()
The function rtusb_probe() references
the function __devinit rt2870_probe().
This is often because rtusb_probe lacks a __devinit 
annotation or the annotation of rt2870_probe is wrong.

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: gregkh-2.6/drivers/staging/rt2860/usb_main_dev.c
===================================================================
--- gregkh-2.6.orig/drivers/staging/rt2860/usb_main_dev.c	2009-12-23 18:33:00.000000000 +1100
+++ gregkh-2.6/drivers/staging/rt2860/usb_main_dev.c	2009-12-23 18:42:34.000000000 +1100
@@ -296,7 +296,7 @@ static BOOLEAN USBDevConfigInit(IN struc
 
 }
 
-static int rtusb_probe(struct usb_interface *intf,
+static int __devinit rtusb_probe(struct usb_interface *intf,
 		       const struct usb_device_id *id)
 {
 	struct rt_rtmp_adapter *pAd;

