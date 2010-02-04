Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406Ab0BDRWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:22:42 -0500
Received: from kroah.org ([198.145.64.141]:34782 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933287Ab0BDRWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:04 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:11 2010
Message-Id: <20100204171510.969308513@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Leann Ogasawara <leann.ogasawara@canonical.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [40/74] x86: Add Dell OptiPlex 760 reboot quirk
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Leann Ogasawara <leann.ogasawara@canonical.com>

commit 35ea63d70f827a26c150993b4b940925bb02b03f upstream.

Dell OptiPlex 760 hangs on reboot unless reboot=bios is used.  Add quirk
to reboot through the BIOS.

BugLink: https://bugs.launchpad.net/bugs/488319

Signed-off-by: Leann Ogasawara <leann.ogasawara@canonical.com>
LKML-Reference: <1264634958.27335.1091.camel@emiko>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/reboot.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -203,6 +203,15 @@ static struct dmi_system_id __initdata r
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


