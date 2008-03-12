Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbYCLPvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbYCLPvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 11:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbYCLPvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 11:51:15 -0400
Received: from mpadmx-1.MPA-Garching.MPG.DE ([130.183.82.41]:54189 "EHLO
	mpadmx-1.MPA-Garching.MPG.DE" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750863AbYCLPvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 11:51:14 -0400
X-Greylist: delayed 1331 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Mar 2008 11:51:13 EDT
Message-ID: <47D7F67C.5040406@MPA-Garching.MPG.DE>
Date: Wed, 12 Mar 2008 16:27:56 +0100
From: Heinz-Ado Arnolds <arnolds@MPA-Garching.MPG.DE>
User-Agent: Thunderbird 1.5.0.13 (X11/20070809)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Douglas_Warzecha@dell.com
Subject: Reboot problem with Dell Optiplex 745 on 2.6.23/24
Content-Type: multipart/mixed;
 boundary="------------060409070407010708060006"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060409070407010708060006
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi there,

we have seen a little problem in rebooting Dell Optiplex 745 with the
0KW626 board. A small patch for 2.6.23 enabling reboot with this board is
attached.

Kind regards,

Ado

--
________________________________________________________________________

Dipl.-Ing. Heinz-Ado Arnolds

MPI fuer Astrophysik
Karl-Schwarzschild-Strasse 1
D-85748 Garching
Phone:  +49/89/30000-2217
FAX  :  +49/89/30000-2388
email:  arnolds[at]MPA-Garching.MPG.DE
________________________________________________________________________

--------------060409070407010708060006
Content-Type: text/plain;
 name="reboot-dell-0kw626-linux-2.6.23"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="reboot-dell-0kw626-linux-2.6.23"

--- linux-2.6.23/arch/i386/kernel/reboot.c.orig	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/arch/i386/kernel/reboot.c	2008-02-25 16:26:11.000000000 +0100
@@ -122,6 +122,15 @@
 			DMI_MATCH(DMI_BOARD_NAME, "0WF810"),
 		},
 	},
+	{       /* Handle problems with rebooting on Dell Optiplex 745 with 0KW626 */
+		.callback = set_bios_reboot,
+		.ident = "Dell OptiPlex 745",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
+			DMI_MATCH(DMI_BOARD_NAME, "0KW626"),
+		},
+	},
 	{	/* Handle problems with rebooting on Dell 2400's */
 		.callback = set_bios_reboot,
 		.ident = "Dell PowerEdge 2400",

--------------060409070407010708060006--
