Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbYBUC3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbYBUC3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 21:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbYBUC3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 21:29:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54557 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbYBUC3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 21:29:21 -0500
X-Greylist: delayed 929 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Feb 2008 21:29:21 EST
Message-ID: <47BCDDC8.3020703@intellitree.com>
Date: Wed, 20 Feb 2008 21:11:20 -0500
From: Coleman Kane <ckane@intellitree.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20080123)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: hpa@zytor.com
Subject: [PATCH] Add the DFF (Desktop Form Factor) Dell Optiplex 745 to the
 reboot errata list, where the SFF one lives right now
Content-Type: multipart/mixed;
 boundary="------------010201020209030308060300"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010201020209030308060300
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

We recently got some of the "Desktop Form Factor" Optiplex 745's in. I
noticed that there's an entry for the SFF one's, but the BIOS model
number of the DFF differs from that of the SFF. We have been reliably
experiencing the same (as far as I can tell) reboot bug as the SFF boxes.

Please accept the attached patch (made against 2.6.23.16 sources) for
review.

--
Coleman Kane
IntelliTree Solutions llc



--------------010201020209030308060300
Content-Type: text/x-patch;
 name="reboot.c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="reboot.c.patch"

--- linux-2.6.23.16/arch/i386/kernel/reboot.c.orig	2008-02-20 19:18:53.000000000 -0500
+++ linux-2.6.23.16/arch/i386/kernel/reboot.c	2008-02-20 19:20:00.000000000 -0500
@@ -122,6 +122,15 @@
 			DMI_MATCH(DMI_BOARD_NAME, "0WF810"),
 		},
 	},
+	{       /* Handle problems with rebooting on Dell Optiplex 745's DFF*/
+		.callback = set_bios_reboot,
+		.ident = "Dell OptiPlex 745",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
+			DMI_MATCH(DMI_BOARD_NAME, "0MM599"),
+		},
+	},
 	{	/* Handle problems with rebooting on Dell 2400's */
 		.callback = set_bios_reboot,
 		.ident = "Dell PowerEdge 2400",

--------------010201020209030308060300--
