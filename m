Return-Path: <linux-kernel-owner+w=401wt.eu-S1753620AbZCNKmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbZCNKmU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 06:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbZCNKmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 06:42:10 -0400
Received: from relay3-v.mail.gandi.net ([217.70.178.77]:49949 "EHLO
	relay3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbZCNKmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 06:42:09 -0400
Date: Sat, 14 Mar 2009 11:42:04 +0100
From: Mathieu Chouquet-Stringer <mchouque@free.fr>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: Len Brown <lenb@kernel.org>, ibm-acpi-devel@lists.sourceforge.net,
       linux-acpi@vger.kernel.org, stable@kernel.org,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH] thinkpad-acpi: fix module autoloading for older models
Message-ID: <20090314104204.GA11226@mobydick>
Mail-Followup-To: Mathieu Chouquet-Stringer <mchouque@free.fr>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	Len Brown <lenb@kernel.org>, ibm-acpi-devel@lists.sourceforge.net,
	linux-acpi@vger.kernel.org, stable@kernel.org,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Face: %JOeya=Dg!}[/#Go&*&cQ+)){p1c8}u\Fg2Q3&)kothIq|JnWoVzJtCFo~4X<uJ\9cHK
	'.w 3:{EoxBR
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello Linus,

Looks like this one liner patch never made it...  Hopefully, it'll go in
before you release rc9 or 2.6.29.

Best,
Mathieu

----- Forwarded message from Henrique de Moraes Holschuh <hmh@hmh.eng.br> -----

Delivered-To: online.fr-mchouque@free.fr
X-Sasl-enc: J0pR0vt90JACc2icrP/7acPg7Vn8fC4jw2hSyELrb8PJ 1234704353
X-Virus-Scanned: Debian amavisd-new at khazad-dum.debian.net
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Len Brown <lenb@kernel.org>
Cc: ibm-acpi-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
	Mathieu Chouquet-Stringer <mchouque@free.fr>, stable@kernel.org
Subject: [PATCH] thinkpad-acpi: fix module autoloading for older models
Date: Sun, 15 Feb 2009 10:25:51 -0300
X-Mailer: git-send-email 1.5.6.5
X-CRM114-Version: 20070301-BlameBaltar ( TRE 0.7.5 (LGPL) ) MF-F8A122EB [pR: -2.3502]
X-CRM114-CacheID: sfid-20090215_142656_606015_D7CAAB9F 
X-CRM114-Status: UNSURE (-2.3502) This message is 'unsure'; please train it! 

From: Mathieu Chouquet-Stringer <mchouque@free.fr>

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

Signed-off-by: Mathieu Chouquet-Stringer <mchouque@free.fr>
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: stable@kernel.org
---
 drivers/platform/x86/thinkpad_acpi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


Len, please consider this for 2.6.29.  It is an obvious one-liner.

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 91ae159..d218ecb 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -7524,7 +7524,7 @@ MODULE_ALIAS(TPACPI_DRVR_SHORTNAME);
  * if it is not there yet.
  */
 #define IBM_BIOS_MODULE_ALIAS(__type) \
-	MODULE_ALIAS("dmi:bvnIBM:bvr" __type "ET??WW")
+	MODULE_ALIAS("dmi:bvnIBM:bvr" __type "ET??WW*")
 
 /* Non-ancient thinkpads */
 MODULE_ALIAS("dmi:bvnIBM:*:svnIBM:*:pvrThinkPad*:rvnIBM:*");
-- 
1.5.6.5


