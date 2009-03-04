Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbZCDT6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbZCDT6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 14:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756133AbZCDT6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 14:58:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:45123 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbZCDT6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 14:58:03 -0500
Date: Wed, 4 Mar 2009 19:57:29 GMT
From: Leann Ogasawara <leann.ogasawara@canonical.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       manoj.iyer@canonical.com, leann.ogasawara@canonical.com,
       tim.gardner@canonical.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       manoj.iyer@canonical.com, leann.ogasawara@canonical.com,
       tim.gardner@canonical.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236196380.3231.89.camel@emiko>
References: <1236196380.3231.89.camel@emiko>
Subject: [tip:x86/urgent] x86: add Dell XPS710 reboot quirk
Message-ID: <tip-dd4124a8a06bca89c077a16437edac010f0bb993@git.kernel.org>
Git-Commit-ID: dd4124a8a06bca89c077a16437edac010f0bb993
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 19:57:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd4124a8a06bca89c077a16437edac010f0bb993
Gitweb:     http://git.kernel.org/tip/dd4124a8a06bca89c077a16437edac010f0bb993
Author:     "Leann Ogasawara" <leann.ogasawara@canonical.com>
AuthorDate: Wed, 4 Mar 2009 11:53:00 -0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Mar 2009 20:56:15 +0100

x86: add Dell XPS710 reboot quirk

Dell XPS710 will hang on reboot.  This is resolved by adding a quirk to
set bios reboot.

Signed-off-by: Leann Ogasawara <leann.ogasawara@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Cc: "manoj.iyer" <manoj.iyer@canonical.com>
Cc: <stable@kernel.org>
LKML-Reference: <1236196380.3231.89.camel@emiko>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 2b46eb4..4526b3a 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -217,6 +217,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
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
 
