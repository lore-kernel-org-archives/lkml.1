Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbXI1LWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbXI1LWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 07:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbXI1LWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 07:22:08 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:15662 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbXI1LWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 07:22:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=HGh5FrpgGEzEa295H6jmGyy3s4S3SPG03d2b2Oo/w8U+8GEur4flhE7Xtgghj3zh4qa/wODJtt/6EFI/prtQ0WlwERAzHdB5cyseDrFdyg1llhvMiSHBsAy3f8FLGBoWOM0gMJsTK2hjE/+pE7ioBYE8tV/KTjxA4hzeOKp7dfw=
Message-ID: <8b67d60709280422p5778dcc9x5462961f3bd87faf@mail.gmail.com>
Date: Fri, 28 Sep 2007 12:22:04 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: [PATCH] Add TV (RGB) support to Dreamcast PVR driver
Cc: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net,
       "Paul Mundt" <lethal@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for RGB output to the Dreamcast PVR2 frame buffer driver.

Signed-off by Adrian McMenamin <adrian@mcmen.demon.co.uk>


--- drivers/video/pvr2fb.c	2007/09/22 18:34:42	1.6
+++ drivers/video/pvr2fb.c	2007/09/23 00:04:31	1.7
@@ -667,6 +667,8 @@ static int pvr2_init_cable(void)
 	  related */
 	if (cable_type == CT_COMPOSITE)
 		fb_writel(3 << 8, VOUTC);
+	else if (cable_type == CT_RGB)
+		fb_writel(1 << 9, VOUTC);
 	else
 		fb_writel(0, VOUTC);
