Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab0CEQYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:24:53 -0500
Received: from mta1.integra.fr ([217.115.161.166]:41901 "EHLO mta1.integra.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754912Ab0CEQYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:24:51 -0500
X-Greylist: delayed 1768 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Mar 2010 11:24:51 EST
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] x86: Dell Precision WorkStation 690 reboot quirk
X-Mercurial-Node: aec3aca0d290e7000e179a1f4908b3b475d98846
Message-Id: <aec3aca0d290e7000e17.1267804511@egomez.in.mobiclip.com>
User-Agent: Mercurial-patchbomb/1.4.3+93-1a8df80dfdde
Date: Fri, 05 Mar 2010 16:55:11 +0100
From: Edouard Gomez <ed.gomez@free.fr>
To: linux-kernel@vger.kernel.org
Cc: Edouard Gomez <ed.gomez@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Edouard Gomez <ed.gomez@free.fr>
# Date 1267783903 -3600
# Node ID aec3aca0d290e7000e179a1f4908b3b475d98846
# Parent  c242cee8e9bd4ef993871546912bc17b0605c7d0
x86: Dell Precision WorkStation 690 reboot quirk

This Dell workstation gets stuck on reboot unless booted with
the paremeter reboot=bios.

This patch has been submitted 2 times already to X86 ARCHITECTURE
maintainers w/o any feedback so far. Trying my chance on the LKML.

Signed-off-by: Edouard Gomez <ed.gomez@free.fr>

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -228,6 +228,15 @@
 			DMI_MATCH(DMI_PRODUCT_NAME, "Precision WorkStation T5400"),
 		},
 	},
+	{	/* Handle problems with rebooting on Dell 690's */
+		.callback = set_bios_reboot,
+		.ident = "Dell Precision 690",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision WorkStation 690"),
+			DMI_MATCH(DMI_BOARD_NAME, "0MY171"),
+		},
+	},
 	{	/* Handle problems with rebooting on HP laptops */
 		.callback = set_bios_reboot,
 		.ident = "HP Compaq Laptop",
