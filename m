Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556Ab0BPXSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 18:18:42 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:56348 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933354Ab0BPXSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 18:18:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MzQXFU0jUmueLs+0cB8n6OLODrkIrP0wuQ4I1sw6dcUq5vEob4HLMwdidg8uhA4EJ3
         0Jq/yhQIHnfPxQmsFqyAxhFLOYycYm7DK04Cdwiic+MZGusYtykRozJyqWWDjVUEC7NF
         KOh+7zSWztHxcp/+HEr12B4mofBCXiejQ1jGE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, jbarnes@virtuousgeek.org, akpm@linux-foundation.org,
       rjw@sisk.pl, hpa@zytor.com,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]"X86",Resend_Add_iMac9,1_to_pci_reboot_dmi_table 
Date: Tue, 16 Feb 2010 15:17:29 -0800
Message-Id: <1266362249-3337-1-git-send-email-justinmattock@gmail.com>
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

