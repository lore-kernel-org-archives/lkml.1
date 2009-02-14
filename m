Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbZBNWmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbZBNWmS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 17:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbZBNWmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 17:42:05 -0500
Received: from slow2-v.mail.gandi.net ([217.70.178.89]:42822 "EHLO
	slow2-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbZBNWmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:42:04 -0500
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Feb 2009 17:42:03 EST
Date: Sat, 14 Feb 2009 23:34:07 +0100
From: Mathieu Chouquet-Stringer <mchouque@free.fr>
To: ibm-acpi@hmh.eng.br
Cc: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATH] No Thinkpad Module Autoloading On T30
Message-ID: <20090214223407.GA3367@mobydick>
Mail-Followup-To: Mathieu Chouquet-Stringer <mchouque@free.fr>,
	ibm-acpi@hmh.eng.br, ibm-acpi-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Face: %JOeya=Dg!}[/#Go&*&cQ+)){p1c8}u\Fg2Q3&)kothIq|JnWoVzJtCFo~4X<uJ\9cHK
	'.w 3:{EoxBR
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello,

I'm running 2.6.29-rc5 on my aging T30 laptop (2366-21U) and just
realized thinkpad_acpi wasn't loaded.

Looking at the source, there seems to be a missing * to match my DMI
string.  I mean for newer IBM and Lenovo's laptops you match either one
of the following:
MODULE_ALIAS("dmi:bvnIBM:*:svnIBM:*:pvrThinkPad*:rvnIBM:*");
MODULE_ALIAS("dmi:bvnLENOVO:*:svnLENOVO:*:pvrThinkPad*:rvnLENOVO:*");

While for older Thinkpads, you do this (for instance):
IBM_BIOS_MODULE_ALIAS("1[0,3,6,8,A-G,I,K,M-P,S,T]");

with IBM_BIOS_MODULE_ALIAS being MODULE_ALIAS("dmi:bvnIBM:bvr" __type "ET??WW")

Note there's no * terminating the string.  As result, udev doesn't load
anything because modprobe cannot find anything matching this (my
machine actually):

udevtest: run: '/sbin/modprobe dmi:bvnIBM:bvr1IET71WW(2.10):bd06/16/2006:svnIBM:pn236621U:pvrNotAvailable:rvnIBM:rn236621U:rvrNotAvailable:cvnIBM:ct10:cvrNotAvailable:'

So here's my contribution...

Best,

Signed-off-by: Mathieu Chouquet-Stringer <mchouque@free.fr>
---
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index bcbc051..70e702a 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -7532,7 +7532,7 @@ MODULE_ALIAS(TPACPI_DRVR_SHORTNAME);
  * if it is not there yet.
  */
 #define IBM_BIOS_MODULE_ALIAS(__type) \
-	MODULE_ALIAS("dmi:bvnIBM:bvr" __type "ET??WW")
+	MODULE_ALIAS("dmi:bvnIBM:bvr" __type "ET??WW*")
 
 /* Non-ancient thinkpads */
 MODULE_ALIAS("dmi:bvnIBM:*:svnIBM:*:pvrThinkPad*:rvnIBM:*");
