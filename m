Return-Path: <linux-kernel-owner+w=401wt.eu-S934142AbZDHQNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934142AbZDHQNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765991AbZDHQLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:11:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:55439 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933884AbZDHQLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:11:04 -0400
Date: Wed, 8 Apr 2009 16:10:00 GMT
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, alan@lxorguk.ukuu.org.uk, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, alan@lxorguk.ukuu.org.uk, mingo@elte.hu
In-Reply-To: <20090326204524.4454.8776.stgit@localhost.localdomain>
References: <20090326204524.4454.8776.stgit@localhost.localdomain>
Subject: [tip:x86/urgent] x86: DMI match for the Dell DXP061 as it needs BIOS reboot
Message-ID: <tip-c5da9a2bb24a7928c39495cdabf98d3f7931bde5@git.kernel.org>
Git-Commit-ID: c5da9a2bb24a7928c39495cdabf98d3f7931bde5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 16:10:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5da9a2bb24a7928c39495cdabf98d3f7931bde5
Gitweb:     http://git.kernel.org/tip/c5da9a2bb24a7928c39495cdabf98d3f7931bde5
Author:     Alan Cox <alan@lxorguk.ukuu.org.uk>
AuthorDate: Thu, 26 Mar 2009 20:45:28 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 17:53:27 +0200

x86: DMI match for the Dell DXP061 as it needs BIOS reboot

Closes http://bugzilla.kernel.org/show_bug.cgi?12901

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
LKML-Reference: <20090326204524.4454.8776.stgit@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 2aef36d..1340dad 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -224,6 +224,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Dell XPS710"),
 		},
 	},
+	{	/* Handle problems with rebooting on Dell DXP061 */
+		.callback = set_bios_reboot,
+		.ident = "Dell DXP061",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell DXP061"),
+		},
+	},
 	{ }
 };
 
