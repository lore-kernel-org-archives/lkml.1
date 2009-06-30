Return-Path: <linux-kernel-owner+w=401wt.eu-S1761078AbZGAAdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761078AbZGAAdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759705AbZGAAaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:30:10 -0400
Received: from kroah.org ([198.145.64.141]:34338 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757379AbZGAAaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:30:05 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:03:58 2009
Message-Id: <20090701000358.122275246@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 16:59:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Leann Ogasawara <leann.ogasawara@canonical.com>,
       Steve Conklin <steve.conklin@canonical.com>,
       Ingo Molnar <mingo@elte.hu>, Jean Delvare <khali@linux-fr.org>
Subject: [patch 12/30] x86: quirk for reboot stalls on a Dell Optiplex 330
References: <20090630235944.868879272@mini.kroah.org>
Content-Disposition: inline; filename=x86-quirk-for-reboot-stalls-on-a-dell-optiplex-330.patch
In-Reply-To: <20090701002817.GA6156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steve Conklin <sconklin@canonical.com>

commit 093bac154c142fa1fb31a3ac69ae1bc08930231b upstream.

Dell Optiplex 330 appears to hang on reboot. This is resolved by adding
a quirk to set bios reboot.

Signed-off-by: Leann Ogasawara <leann.ogasawara@canonical.com>
Signed-off-by: Steve Conklin <steve.conklin@canonical.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/reboot.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -178,6 +178,15 @@ static struct dmi_system_id __initdata r
 			DMI_MATCH(DMI_BOARD_NAME, "0T656F"),
 		},
 	},
+	{   /* Handle problems with rebooting on Dell Optiplex 330 with 0KP561 */
+		.callback = set_bios_reboot,
+		.ident = "Dell OptiPlex 330",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 330"),
+			DMI_MATCH(DMI_BOARD_NAME, "0KP561"),
+		},
+	},
 	{	/* Handle problems with rebooting on Dell 2400's */
 		.callback = set_bios_reboot,
 		.ident = "Dell PowerEdge 2400",


