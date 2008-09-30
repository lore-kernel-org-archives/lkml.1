Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbYI3OxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbYI3OxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 10:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbYI3OxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 10:53:07 -0400
Received: from faui2k3.org ([213.95.10.24]:60421 "EHLO casella.faui2k3.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbYI3OxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 10:53:06 -0400
X-Greylist: delayed 2757 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Sep 2008 10:53:06 EDT
Date: Tue, 30 Sep 2008 16:06:58 +0200
From: Wolfgang Kroener <lkml@azog.de>
To: benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Message-ID: <20080930140658.GL10156@casella.faui2k3.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: lkml@azog.de
Subject: [PATCH] suspend/resume for ATI Mobility Radeon RV350
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on casella.faui2k3.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have a ATI Mobility Radeon RV350 and similar problems with radeonfb
described in http://kernel.org/doc/Documentation/power/s2ram.txt
Adding the device to radeon_workaround_list solves the Problem.
Please accept the following patch:

--8<--
--- drivers/video/aty/radeon_pm.c.orig	2008-09-30 15:00:40.988111330 +0200
+++ drivers/video/aty/radeon_pm.c	2008-09-30 15:14:10.941524474 +0200
@@ -89,6 +89,9 @@
 	BUGFIX("Acer Aspire 2010",
 	       PCI_VENDOR_ID_AI, 0x0061,
 	       radeon_pm_off, radeon_reinitialize_M10),
+	BUGFIX("Acer Travelmate 290D/292LMi",
+	       PCI_VENDOR_ID_AI, 0x005a,
+	       radeon_pm_off, radeon_reinitialize_M10),
 	{ .ident = NULL }
 };

-->8--
Kind regards,
Wolfgang

P. S. please CC me, because I'm not subscribed to the lkml
