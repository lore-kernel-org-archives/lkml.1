Return-Path: <linux-kernel-owner+w=401wt.eu-S1030474AbXDJNRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030474AbXDJNRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 09:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030490AbXDJNRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 09:17:08 -0400
Received: from shadow.prohost.de ([216.71.84.228]:18959 "EHLO
	shadow.prohost.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030474AbXDJNRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 09:17:06 -0400
X-Greylist: delayed 1864 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Apr 2007 09:17:06 EDT
Message-ID: <461B86F2.4070907@antcom.de>
Date: Tue, 10 Apr 2007 14:45:38 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: Antcom IT
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] epson1355fb.c, kernel 2.6.21-rc6-git3
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------010600040606070404080307"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010600040606070404080307
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

I'm attaching a fix for the error handling code in epson1355fb.c.

Roland

--------------010600040606070404080307
Content-Type: text/x-patch;
 name="epson1355fb.c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="epson1355fb.c.patch"

epson1355fb.c: Fixes error handling code

--- drivers/video/epson1355fb.c.orig	2007-04-10 14:01:48.000000000 +0200
+++ drivers/video/epson1355fb.c	2007-04-10 14:02:17.000000000 +0200
@@ -650,9 +650,10 @@
 	}
 
 	info = framebuffer_alloc(sizeof(struct epson1355_par) + sizeof(u32) * 256, &dev->dev);
-	if (!info)
+	if (!info) {
 		rc = -ENOMEM;
 		goto bail;
+	}
 
 	default_par = info->par;
 	default_par->reg_addr = (unsigned long) ioremap(EPSON1355FB_REGS_PHYS, EPSON1355FB_REGS_LEN);

--------------010600040606070404080307--
