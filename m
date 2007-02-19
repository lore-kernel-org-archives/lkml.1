Return-Path: <linux-kernel-owner+w=401wt.eu-S932228AbXBSN0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbXBSN0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 08:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932229AbXBSN0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 08:26:55 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:43421 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbXBSN0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 08:26:54 -0500
Date: Mon, 19 Feb 2007 05:26:52 -0800 (PST)
From: Zwane Mwaikambo <zwane@infradead.org>
Subject: Re: "compat_agp_ioctl" [drivers/char/agp/agpgart.ko] undefined!
In-reply-to: <20070219122959.GA2612@aepfle.de>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org, davej@codemonkey.org.uk
Message-id: <Pine.LNX.4.64.0702190526190.26450@montezuma.fsmlabs.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20070219122959.GA2612@aepfle.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Feb 2007, Olaf Hering wrote:

> 
> 2.6.20-git14
> 
> cp arch/powerpc/configs/g5_defconfig ../O-linus/.config
> time env LC_ALL=C make -k O=../O-linus 
> ...
> Building modules, stage 2.
> MODPOST 127 modules
> WARNING: "compat_agp_ioctl" [drivers/char/agp/agpgart.ko] undefined!
> make[2]: *** [__modpost] Error 1

Fixed in Andrew's tree;

Index: drivers/char/agp/Makefile
===================================================================
RCS file: /home/cvsroot/linux-2.6.20-rc3/drivers/char/agp/Makefile,v
retrieving revision 1.1.1.1
diff -u -p -B -r1.1.1.1 Makefile
--- drivers/char/agp/Makefile	8 Jan 2007 06:36:24 -0000	1.1.1.1
+++ drivers/char/agp/Makefile	16 Feb 2007 06:29:10 -0000
@@ -1,5 +1,7 @@
 agpgart-y := backend.o frontend.o generic.o isoch.o
 
+agpgart-$(CONFIG_COMPAT)			+= compat_ioctl.o
+
 obj-$(CONFIG_AGP)		+= agpgart.o
 obj-$(CONFIG_AGP_ALI)		+= ali-agp.o
 obj-$(CONFIG_AGP_ATI)		+= ati-agp.o
