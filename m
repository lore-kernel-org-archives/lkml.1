Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466Ab0BDRa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:30:57 -0500
Received: from kroah.org ([198.145.64.141]:34791 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933289Ab0BDRWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:05 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:12 2010
Message-Id: <20100204171511.530738093@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?ISO-8859-15?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
       Alexey Fisher <bug-track@fisher-privat.net>,
       ykzhao <yakui.zhao@intel.com>, Tony Bones <aabonesml@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [41/74] x86: Add quirk for Intel DG45FC board to avoid low memory corruption
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Härdeman <david@hardeman.nu>

commit 7c099ce1575126395f186ecf58b51a60d5c3be7d upstream.

Commit 6aa542a694dc9ea4344a8a590d2628c33d1b9431 added a quirk for the
Intel DG45ID board due to low memory corruption. The Intel DG45FC
shares the same BIOS (and the same bug) as noted in:

  http://bugzilla.kernel.org/show_bug.cgi?id=13736

Signed-off-by: David Härdeman <david@hardeman.nu>
LKML-Reference: <20100128200254.GA9134@hardeman.nu>
Cc: Alexey Fisher <bug-track@fisher-privat.net>
Cc: ykzhao <yakui.zhao@intel.com>
Cc: Tony Bones <aabonesml@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/setup.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -667,19 +667,27 @@ static struct dmi_system_id __initdata b
 			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix/MSC"),
 		},
 	},
-	{
 	/*
-	 * AMI BIOS with low memory corruption was found on Intel DG45ID board.
-	 * It hase different DMI_BIOS_VENDOR = "Intel Corp.", for now we will
+	 * AMI BIOS with low memory corruption was found on Intel DG45ID and
+	 * DG45FC boards.
+	 * It has a different DMI_BIOS_VENDOR = "Intel Corp.", for now we will
 	 * match only DMI_BOARD_NAME and see if there is more bad products
 	 * with this vendor.
 	 */
+	{
 		.callback = dmi_low_memory_corruption,
 		.ident = "AMI BIOS",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "DG45ID"),
 		},
 	},
+	{
+		.callback = dmi_low_memory_corruption,
+		.ident = "AMI BIOS",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "DG45FC"),
+		},
+	},
 #endif
 	{}
 };


