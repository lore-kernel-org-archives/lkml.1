Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbZG1X4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbZG1X4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756116AbZG1X4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:56:15 -0400
Received: from kroah.org ([198.145.64.141]:35826 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706AbZG1XuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:13 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:58 2009
Message-Id: <20090728234158.285147529@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alexey Fisher <bug-track@fisher-privat.net>,
       ykzhao <yakui.zhao@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 45/71] x86: Add quirk for Intel DG45ID board to avoid low memory corruption
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=x86-add-quirk-for-intel-dg45id-board-to-avoid-low-memory-corruption.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Fisher <bug-track@fisher-privat.net>

commit 6aa542a694dc9ea4344a8a590d2628c33d1b9431 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/setup.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -650,6 +650,19 @@ static struct dmi_system_id __initdata b
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


