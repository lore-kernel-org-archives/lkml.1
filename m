Return-Path: <linux-kernel-owner+w=401wt.eu-S1161622AbXBOWto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161622AbXBOWto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161624AbXBOWto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:49:44 -0500
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:55667 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161622AbXBOWtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:49:43 -0500
Date: Thu, 15 Feb 2007 22:49:23 +0000
From: Ben Dooks <ben@fluff.org.uk>
To: openmoko-kernel@lists.openmoko.org,
       linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] s3c2410fb: fix un-initialised dev field
Message-ID: <20070215224922.GA7156@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: I speak for me, myself, and the other one of me.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The current driver is not setting the dev
field in the private data structure, which
can lead to an OOPS if the driver tries to
report an error.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

--- linux-2.6.20/drivers/video/s3c2410fb.c	2007-02-04 18:44:54.000000000 +0000
+++ linux-2.6.20-fbfix1/drivers/video/s3c2410fb.c	2007-02-15 22:42:51.000000000 +0000
@@ -791,6 +791,8 @@ static int __init s3c2410fb_probe(struct
 
 	info = fbinfo->par;
 	info->fb = fbinfo;
+	info->dev = &pdev->dev;
+
 	platform_set_drvdata(pdev, fbinfo);
 
 	dprintk("devinit\n");
