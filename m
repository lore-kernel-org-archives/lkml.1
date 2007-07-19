Return-Path: <linux-kernel-owner+w=401wt.eu-S935241AbXGSNuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935241AbXGSNuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933209AbXGSNsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761605AbXGSNsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:33 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: James.Jarvis@ed.ac.uk, ak@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [4/48] i386: DMI_MATCH patch in reboot.c for SFF Dell OptiPlex 745 - fixes hang on reboot
Message-Id: <20070719134832.D3C6814E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: James Jarvis <James.Jarvis@ed.ac.uk>

The following patch enables reboot through BIOS on the Dell Optiplex 745
Small Form Factor base, on which reboot hangs.  The larger form factor does
not require this, hence the match on DMI_BOARD_NAME.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/reboot.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux/arch/i386/kernel/reboot.c
===================================================================
--- linux.orig/arch/i386/kernel/reboot.c
+++ linux/arch/i386/kernel/reboot.c
@@ -113,6 +113,15 @@ static struct dmi_system_id __initdata r
 			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 300/"),
 		},
 	},
+	{       /* Handle problems with rebooting on Dell Optiplex 745's SFF*/
+		.callback = set_bios_reboot,
+		.ident = "Dell OptiPlex 745",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
+			DMI_MATCH(DMI_BOARD_NAME, "0WF810"),
+		},
+	},
 	{	/* Handle problems with rebooting on Dell 2400's */
 		.callback = set_bios_reboot,
 		.ident = "Dell PowerEdge 2400",
