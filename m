Return-Path: <linux-kernel-owner+w=401wt.eu-S932318AbXIMTaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbXIMTaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 15:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758977AbXIMTao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 15:30:44 -0400
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111]:59058 "EHLO
	pne-smtpout3-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755341AbXIMTao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 15:30:44 -0400
X-Greylist: delayed 4148 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Sep 2007 15:30:43 EDT
Date: Thu, 13 Sep 2007 21:21:34 +0300 (EEST)
From: Juha Laiho <Juha.Laiho@iki.fi>
To: gregkh@suse.de
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] i386: Compaq EVO N800c needs PCI bus renumbering
Message-ID: <Pine.LNX.4.44.0709132041250.21287-100000@ichaos.ichaos-int>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Force PCI bus renumbering for Compaq EVO N800c laptop, in order to get
the cardbus slot recognised.

Signed-off-by: Juha Laiho <Juha.Laiho@iki.fi>
---

Please note that I'm not subscribed to linux-kernel, so please cc any
comments to my personal email.

The diff was done against version 2.6.22.6.


diff -upN arch/i386/pci/common.c.orig arch/i386/pci/common.c
--- arch/i386/pci/common.c.orig	2007-09-13 20:51:08.000000000 +0300
+++ arch/i386/pci/common.c	2007-07-17 12:09:53.000000000 +0300
@@ -287,6 +287,14 @@ static struct dmi_system_id __devinitdat
 			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL685c G1"),
 		},
 	},
+	{
+		.callback = assign_all_busses,
+		.ident = "Compaq EVO N800c",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Compaq"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "EVO N800c"),
+		},
+	},
 	{}
 };
 

