Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497Ab0A3UTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab0A3UTJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 15:19:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292Ab0A3UTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 15:19:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:46839 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281Ab0A3UTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 15:19:06 -0500
Date: Sat, 30 Jan 2010 20:18:43 GMT
From: tip-bot for Leann Ogasawara <leann.ogasawara@canonical.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       leann.ogasawara@canonical.com, stable@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       leann.ogasawara@canonical.com, stable@kernel.org, tglx@linutronix.de
In-Reply-To: <1264634958.27335.1091.camel@emiko>
References: <1264634958.27335.1091.camel@emiko>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Add Dell OptiPlex 760 reboot quirk
Message-ID: <tip-35ea63d70f827a26c150993b4b940925bb02b03f@git.kernel.org>
Git-Commit-ID: 35ea63d70f827a26c150993b4b940925bb02b03f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 30 Jan 2010 20:18:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35ea63d70f827a26c150993b4b940925bb02b03f
Gitweb:     http://git.kernel.org/tip/35ea63d70f827a26c150993b4b940925bb02b03f
Author:     Leann Ogasawara <leann.ogasawara@canonical.com>
AuthorDate: Wed, 27 Jan 2010 15:29:18 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 27 Jan 2010 16:28:51 -0800

x86: Add Dell OptiPlex 760 reboot quirk

Dell OptiPlex 760 hangs on reboot unless reboot=bios is used.  Add quirk
to reboot through the BIOS.

BugLink: https://bugs.launchpad.net/bugs/488319

Signed-off-by: Leann Ogasawara <leann.ogasawara@canonical.com>
LKML-Reference: <1264634958.27335.1091.camel@emiko>
Cc: <stable@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
