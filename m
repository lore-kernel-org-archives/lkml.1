Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbZFGNz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbZFGNz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZFGNzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 09:55:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:39301 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbZFGNzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 09:55:13 -0400
Date: Sun, 7 Jun 2009 13:54:36 GMT
From: tip-bot for Jean Delvare <jdelvare@suse.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, steve.conklin@canonical.com, hpa@zytor.com,
       mingo@redhat.com, leann.ogasawara@canonical.com, jdelvare@suse.de,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, steve.conklin@canonical.com,
       linux-kernel@vger.kernel.org, leann.ogasawara@canonical.com,
       jdelvare@suse.de, stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <200906051202.38311.jdelvare@suse.de>
References: <200906051202.38311.jdelvare@suse.de>
Subject: [tip:x86/urgent] x86: Add quirk for reboot stalls on a Dell Optiplex 360
Message-ID: <tip-4a4aca641bc4598e77b866804f47c651ec4a764d@git.kernel.org>
Git-Commit-ID: 4a4aca641bc4598e77b866804f47c651ec4a764d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 07 Jun 2009 13:54:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a4aca641bc4598e77b866804f47c651ec4a764d
Gitweb:     http://git.kernel.org/tip/4a4aca641bc4598e77b866804f47c651ec4a764d
Author:     Jean Delvare <jdelvare@suse.de>
AuthorDate: Fri, 5 Jun 2009 12:02:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 7 Jun 2009 15:51:20 +0200

x86: Add quirk for reboot stalls on a Dell Optiplex 360

The Dell Optiplex 360 hangs on reboot, just like the Optiplex 330, so
the same quirk is needed.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Steve Conklin <steve.conklin@canonical.com>
Cc: Leann Ogasawara <leann.ogasawara@canonical.com>
Cc: <stable@kernel.org>
LKML-Reference: <200906051202.38311.jdelvare@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/reboot.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 667188e..d2d1ce8 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -192,6 +192,15 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "0KP561"),
 		},
 	},
+	{   /* Handle problems with rebooting on Dell Optiplex 360 with 0T656F */
+		.callback = set_bios_reboot,
+		.ident = "Dell OptiPlex 360",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 360"),
+			DMI_MATCH(DMI_BOARD_NAME, "0T656F"),
+		},
+	},
 	{	/* Handle problems with rebooting on Dell 2400's */
 		.callback = set_bios_reboot,
 		.ident = "Dell PowerEdge 2400",
