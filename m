Return-Path: <linux-kernel-owner+w=401wt.eu-S932621AbZGRLnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621AbZGRLnM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 07:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758191AbZGRLnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 07:43:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:35858 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758163AbZGRLnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 07:43:09 -0400
Date: Sat, 18 Jul 2009 11:42:36 GMT
From: tip-bot for Alexey Fisher <bug-track@fisher-privat.net>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       bug-track@fisher-privat.net, stable@kernel.org, yakui.zhao@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       bug-track@fisher-privat.net, yakui.zhao@intel.com, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1247660169-4503-1-git-send-email-bug-track@fisher-privat.net>
References: <1247660169-4503-1-git-send-email-bug-track@fisher-privat.net>
Subject: [tip:x86/urgent] x86: Add quirk for Intel DG45ID board to avoid low memory corruption
Message-ID: <tip-6aa542a694dc9ea4344a8a590d2628c33d1b9431@git.kernel.org>
Git-Commit-ID: 6aa542a694dc9ea4344a8a590d2628c33d1b9431
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 11:42:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6aa542a694dc9ea4344a8a590d2628c33d1b9431
Gitweb:     http://git.kernel.org/tip/6aa542a694dc9ea4344a8a590d2628c33d1b9431
Author:     Alexey Fisher <bug-track@fisher-privat.net>
AuthorDate: Wed, 15 Jul 2009 14:16:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 13:38:29 +0200

x86: Add quirk for Intel DG45ID board to avoid low memory corruption

AMI BIOS with low memory corruption was found on Intel DG45ID
board (Bug 13710). Add this board to the blacklist - in the
(somewhat optimistic) hope of future boards/BIOSes from Intel
not having this bug.

Also see:

  http://bugzilla.kernel.org/show_bug.cgi?id=13736

Signed-off-by: Alexey Fisher <bug-track@fisher-privat.net>
Cc: ykzhao <yakui.zhao@intel.com>
Cc: alan@lxorguk.ukuu.org.uk
Cc: <stable@kernel.org>
LKML-Reference: <1247660169-4503-1-git-send-email-bug-track@fisher-privat.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/setup.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index de2cab1..63f32d2 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -672,6 +672,19 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
 			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies"),
 		},
 	},
+	{
+	/*
+	 * AMI BIOS with low memory corruption was found on Intel DG45ID board.
+	 * It hase different DMI_BIOS_VENDOR = "Intel Corp.", for now we will
+	 * match only DMI_BOARD_NAME and see if there is more bad products
+	 * with this vendor.
+	 */
+		.callback = dmi_low_memory_corruption,
+		.ident = "AMI BIOS",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "DG45ID"),
+		},
+	},
 #endif
 	{}
 };
