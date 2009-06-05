Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304AbZFEKCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbZFEKCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 06:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZFEKCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 06:02:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:59057 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbZFEKCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 06:02:37 -0400
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Subject: [PATCH] x86: quirk for reboot stalls on a Dell Optiplex 360
Date: Fri, 5 Jun 2009 12:02:38 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Steve Conklin <steve.conklin@canonical.com>,
       Leann Ogasawara <leann.ogasawara@canonical.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906051202.38311.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Dell Optiplex 360 hangs on reboot, just like the Optiplex 330, so
the same quirk is needed.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Leann Ogasawara <leann.ogasawara@canonical.com>
Cc: Steve Conklin <steve.conklin@canonical.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/reboot.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- linux-2.6.30-rc8.orig/arch/x86/kernel/reboot.c	2009-06-03 10:06:32.000000000 +0200
+++ linux-2.6.30-rc8/arch/x86/kernel/reboot.c	2009-06-05 11:19:28.000000000 +0200
@@ -192,6 +192,15 @@ static struct dmi_system_id __initdata r
 			DMI_MATCH(DMI_BOARD_NAME, "0KP561"),
 		},
 	},
+	{   /* Handle problems with rebooting on Dell Optiplex 360 with 0T656F */
+		.callback = set_bios_reboot,
+		.ident = "Dell OptiPlex 360",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 360"),
+			DMI_MATCH(DMI_BOARD_NAME, "0T656F"),
+		},
+	},
 	{	/* Handle problems with rebooting on Dell 2400's */
 		.callback = set_bios_reboot,
 		.ident = "Dell PowerEdge 2400",

-- 
Jean Delvare
Suse L3
