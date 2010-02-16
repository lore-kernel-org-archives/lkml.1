Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549Ab0BPXe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 18:34:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:35848 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933129Ab0BPXe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 18:34:26 -0500
Date: Tue, 16 Feb 2010 23:33:38 GMT
From: "tip-bot for Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, justinmattock@gmail.com, hpa@zytor.com,
       mingo@redhat.com, stable@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, justinmattock@gmail.com,
       linux-kernel@vger.kernel.org, stable@kernel.org, tglx@linutronix.de
In-Reply-To: <1266362249-3337-1-git-send-email-justinmattock@gmail.com>
References: <1266362249-3337-1-git-send-email-justinmattock@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Add iMac9,1 to pci_reboot_dmi_table
Message-ID: <tip-30f541e8251d3a708544808292d96eaecbe7e3ab@git.kernel.org>
Git-Commit-ID: 30f541e8251d3a708544808292d96eaecbe7e3ab
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Feb 2010 23:33:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30f541e8251d3a708544808292d96eaecbe7e3ab
Gitweb:     http://git.kernel.org/tip/30f541e8251d3a708544808292d96eaecbe7e3ab
Author:     Justin P. Mattock <justinmattock@gmail.com>
AuthorDate: Tue, 16 Feb 2010 15:17:29 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 16 Feb 2010 15:26:29 -0800

x86: Add iMac9,1 to pci_reboot_dmi_table

On the iMac9,1 /sbin/reboot results in a black mangled screen. Adding
this DMI entry gets the machine to reboot cleanly as it should.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
LKML-Reference: <1266362249-3337-1-git-send-email-justinmattock@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: <stable@kernel.org>
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
 
