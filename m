Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbXI0JVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbXI0JVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 05:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbXI0JUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 05:20:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbXI0JUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 05:20:51 -0400
Message-ID: <46FB7574.7060608@redhat.com>
Date: Thu, 27 Sep 2007 11:18:44 +0200
From: Michal Schmidt <mschmidt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070718)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: john.cagle@hp.com, Matt Domsch <Matt_Domsch@dell.com>,
       Andy Gospodarek <andy@greyhouse.net>
Subject: [PATCH] pci: use pci=bfsort for HP DL385 G2, DL585 G2
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=979FF3AA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

HP ProLiant systems DL385 G2 and DL585 G2 need pci=bfsort to enumerate PCI
devices in the expected order.

(John, can you please confirm and ACK this?)

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

diff --git a/arch/i386/pci/common.c b/arch/i386/pci/common.c
index ebc6f3c..8737c53 100644
--- a/arch/i386/pci/common.c
+++ b/arch/i386/pci/common.c
@@ -287,6 +287,22 @@ static struct dmi_system_id __devinitdata pciprobe_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL685c G1"),
 		},
 	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant DL385 G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL385 G2"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant DL585 G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL585 G2"),
+		},
+	},
 	{}
 };
 


