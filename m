Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab0BFThb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 14:37:31 -0500
Received: from mail-iw0-f185.google.com ([209.85.223.185]:49951 "EHLO
	mail-iw0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab0BFTh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 14:37:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=xcVJimYTyS36ZbVLeqQjNkCkOvEzhZ+vSBghlaNnj10zKg0w7j+EPejzX3asRFPTQ9
         fLA2ZvFgjPzxJOQoFefqy+5NkaEGPAGiUGSrMzb8HXSxIS1z/LAYU6OPKOtVkD8YcNfc
         j/YlltVd0LiSc8Xy/wZyDQIK1YN897OAdyRpE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH] Add an Apple iMac9,1 DMI entry to reboot.c so the machine reboot's properly.
Date: Sat,  6 Feb 2010 11:36:16 -0800
Message-Id: <1265484976-13414-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the iMac9,1 sudo /sbin/reboot results in
a black screen. Adding this DMI entry gets the 
machine to reboot cleanly as it should.


Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 704bddc..2de6645 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -461,6 +461,14 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Macmini3,1"),
 		},
 	},
+	{	/* Handle problems with rebooting on Apple iMac9,1 */
+		.callback = set_pci_reboot,
+		.ident = "Apple iMac9,1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
+		},
+	 },
 	{ }
 };
 
-- 
1.6.5.GIT

