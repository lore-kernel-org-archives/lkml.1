Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbZEVHNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbZEVHNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 03:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbZEVHNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 03:13:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:55343 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbZEVHNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 03:13:40 -0400
Date: Fri, 22 May 2009 07:12:52 GMT
From: tip-bot for Zhang Rui <rui.zhang@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lenb@kernel.org, rui.zhang@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lenb@kernel.org, rui.zhang@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1242963350.32574.53.camel@rzhang-dt>
References: <1242963350.32574.53.camel@rzhang-dt>
Subject: [tip:x86/urgent] x86: DMI match for the Sony VGN-Z540N as it needs BIOS reboot
Message-ID: <tip-88dff4936c0a5fa53080cca68dc963a8a2a674b0@git.kernel.org>
Git-Commit-ID: 88dff4936c0a5fa53080cca68dc963a8a2a674b0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 22 May 2009 07:13:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  88dff4936c0a5fa53080cca68dc963a8a2a674b0
Gitweb:     http://git.kernel.org/tip/88dff4936c0a5fa53080cca68dc963a8a2a674b0
Author:     Zhang Rui <rui.zhang@intel.com>
AuthorDate: Fri, 22 May 2009 11:35:50 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 May 2009 09:11:30 +0200

x86: DMI match for the Sony VGN-Z540N as it needs BIOS reboot

x86: DMI match for the Sony VGN-Z540N as it needs BIOS reboot,
see:

  http://bugzilla.kernel.org/show_bug.cgi?id=12901

[ Impact: fix hung reboot on certain systems ]

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
LKML-Reference: <1242963350.32574.53.camel@rzhang-dt>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 1340dad..667188e 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -232,6 +232,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Dell DXP061"),
 		},
 	},
+	{	/* Handle problems with rebooting on Sony VGN-Z540N */
+		.callback = set_bios_reboot,
+		.ident = "Sony VGN-Z540N",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-Z540N"),
+		},
+	},
 	{ }
 };
 
