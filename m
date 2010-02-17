Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab0BQMNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 07:13:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:56397 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757103Ab0BQMNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 07:13:43 -0500
Date: Wed, 17 Feb 2010 12:12:38 GMT
From: "tip-bot for Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, justinmattock@gmail.com, hpa@zytor.com,
       mingo@redhat.com, stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, justinmattock@gmail.com,
       linux-kernel@vger.kernel.org, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1266362249-3337-1-git-send-email-justinmattock@gmail.com>
References: <1266362249-3337-1-git-send-email-justinmattock@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Add iMac9,1 to pci_reboot_dmi_table
Message-ID: <tip-0a832320f1bae6a4169bf683e201378f2437cfc1@git.kernel.org>
Git-Commit-ID: 0a832320f1bae6a4169bf683e201378f2437cfc1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Feb 2010 12:12:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0a832320f1bae6a4169bf683e201378f2437cfc1
Gitweb:     http://git.kernel.org/tip/0a832320f1bae6a4169bf683e201378f2437cfc1
Author:     Justin P. Mattock <justinmattock@gmail.com>
AuthorDate: Tue, 16 Feb 2010 15:17:29 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Feb 2010 08:08:21 +0100

x86: Add iMac9,1 to pci_reboot_dmi_table

On the iMac9,1 /sbin/reboot results in a black mangled screen. Adding
this DMI entry gets the machine to reboot cleanly as it should.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
LKML-Reference: <1266362249-3337-1-git-send-email-justinmattock@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
