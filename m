Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbZCDTx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbZCDTx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 14:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756133AbZCDTxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 14:53:12 -0500
Received: from adelie.canonical.com ([91.189.90.139]:35391 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096AbZCDTxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 14:53:10 -0500
Subject: [PATCH] x86: Dell XPS710 reboot quirk
From: Leann Ogasawara <leann.ogasawara@canonical.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, x86@kernel.org
Cc: "manoj.iyer" <manoj.iyer@canonical.com>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 11:53:00 -0800
Message-Id: <1236196380.3231.89.camel@emiko>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a338e3234e27beba9e07fd8de63b6deeed9e451c Mon Sep 17 00:00:00 2001
From: Leann Ogasawara <leann.ogasawara@canonical.com>
Date: Wed, 4 Mar 2009 11:44:18 -0800
Subject: [PATCH] x86: Dell XPS710 reboot quirk

Dell XPS710 will hang on reboot.  This is resolved by adding a quirk to
set bios reboot.

Signed-off-by: Leann Ogasawara <leann.ogasawara@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Cc: <stable@kernel.org>
---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 1cc18d4..2aef36d 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -216,6 +216,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq"),
 		},
 	},
+	{	/* Handle problems with rebooting on Dell XPS710 */
+		.callback = set_bios_reboot,
+		.ident = "Dell XPS710",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell XPS710"),
+		},
+	},
 	{ }
 };
 
-- 
1.6.0.4



