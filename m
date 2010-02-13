Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab0BMP6M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 10:58:12 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:51470 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab0BMP6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 10:58:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=TjXCV3Gf2I4KvbYGZIXsMowZvk6rkKOkiMKoviMDYb1/Astxj9tzctx7PgfvpTWOjd
         /yK3kJyLfbHMqG/6AtAS8HMPvKT1CxpaqNUbkdPi3URrqZwCN+dyK00wxV85+Bdn5zBd
         Abh/Uj1s0SeKUQ7TT2LC9PQ/eq+VPNEQebtBo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]Resend_Add_iMac9,1_to_pci_reboot_dmi_table 
Date: Sat, 13 Feb 2010 07:51:27 -0800
Message-Id: <1266076287-28339-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On the iMac9,1 /sbin/reboot results in
a black mangled screen. Adding this DMI entry
gets the machine to reboot cleanly as it should.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 704bddc..8e1aac8 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -461,6 +461,14 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Macmini3,1"),
 		},
 	},
+	{	/* Handle problems with rebooting on the iMac9,1. */
+		.callback = set_pci_reboot,
+		.ident = "Apple iMac9,1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
+		},
+	},
 	{ }
 };
 
-- 
1.6.5.GIT

