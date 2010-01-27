Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553Ab0A0Xcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0A0Xcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756540Ab0A0Xcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:32:52 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43803 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531Ab0A0Xcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:32:52 -0500
Subject: [PATCH] x86: add Dell OptiPlex 760 reboot quirk
From: Leann Ogasawara <leann.ogasawara@canonical.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 15:29:18 -0800
Message-ID: <1264634958.27335.1091.camel@emiko>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

A bug reporter noted their Dell OptiPlex 760 hangs on reboot unless
reboot=bios is specified.  They have confirmed the following reboot
quirk resolves the issue.  Please consider applying for 2.6.33.

Thanks,
Leann

>From 1e25ca7ec6c1894032a0174e42c537c9b7d849fd Mon Sep 17 00:00:00 2001
From: Leann Ogasawara <leann.ogasawara@canonical.com>
Date: Wed, 27 Jan 2010 15:02:02 -0800
Subject: [PATCH] x86: add Dell OptiPlex 760 reboot quirk

BugLink: https://bugs.launchpad.net/bugs/488319

Dell OptiPlex 760 hangs on reboot unless reboot=bios is used.  Add quirk
to reboot through the BIOS.

Signed-off-by: Leann Ogasawara <leann.ogasawara@canonical.com>
Cc: <stable@kernel.org>
---
 arch/x86/kernel/reboot.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 1545bc0..704bddc 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -203,6 +203,15 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "0T656F"),
 		},
 	},
+	{	/* Handle problems with rebooting on Dell OptiPlex 760 with 0G919G*/
+		.callback = set_bios_reboot,
+		.ident = "Dell OptiPlex 760",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 760"),
+			DMI_MATCH(DMI_BOARD_NAME, "0G919G"),
+		},
+	},
 	{	/* Handle problems with rebooting on Dell 2400's */
 		.callback = set_bios_reboot,
 		.ident = "Dell PowerEdge 2400",
-- 
1.6.3.3



