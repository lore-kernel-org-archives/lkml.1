Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262Ab0A1UDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab0A1UDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 15:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535Ab0A1UDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 15:03:00 -0500
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:51105 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab0A1UC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 15:02:59 -0500
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jan 2010 15:02:59 EST
Date: Thu, 28 Jan 2010 21:02:54 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: linux-kernel@vger.kernel.org
Cc: bug-track@fisher-privat.net, yakui.zhao@intel.com, aabonesml@gmail.com,
       mingo@elte.hu
Subject: [PATCH] x86: Add quirk for Intel DG45FC board to avoid low memory
 corruption
Message-ID: <20100128200254.GA9134@hardeman.nu>
Mail-Followup-To: linux-kernel@vger.kernel.org, bug-track@fisher-privat.net,
	yakui.zhao@intel.com, aabonesml@gmail.com, mingo@elte.hu
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6aa542a694dc9ea4344a8a590d2628c33d1b9431 added a quirk for the
Intel DG45ID board due to low memory corruption. The Intel DG45FC
shares the same BIOS (and the same bug) as noted in:

  http://bugzilla.kernel.org/show_bug.cgi?id=13736

Signed-off-by: David Härdeman <david@hardeman.nu>
Cc: <stable@kernel.org>
Cc: Alexey Fisher <bug-track@fisher-privat.net>
Cc: ykzhao <yakui.zhao@intel.com>
Cc: Tony Bones <aabonesml@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>

---
 arch/x86/kernel/setup.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f7b8b98..5d9e40c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -642,19 +642,27 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
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
-- 
1.6.6

