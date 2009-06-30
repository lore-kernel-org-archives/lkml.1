Return-Path: <linux-kernel-owner+w=401wt.eu-S1760913AbZGAAc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760913AbZGAAc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759677AbZGAAaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:30:08 -0400
Received: from kroah.org ([198.145.64.141]:34332 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756693AbZGAAaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:30:04 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:03:58 2009
Message-Id: <20090701000357.950820556@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 16:59:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <jdelvare@suse.de>,
       Steve Conklin <steve.conklin@canonical.com>,
       Leann Ogasawara <leann.ogasawara@canonical.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 11/30] x86: Add quirk for reboot stalls on a Dell Optiplex 360
References: <20090630235944.868879272@mini.kroah.org>
Content-Disposition: inline; filename=x86-add-quirk-for-reboot-stalls-on-a-dell-optiplex-360.patch
In-Reply-To: <20090701002817.GA6156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <jdelvare@suse.de>

commit 4a4aca641bc4598e77b866804f47c651ec4a764d upstream.

The Dell Optiplex 360 hangs on reboot, just like the Optiplex 330, so
the same quirk is needed.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Steve Conklin <steve.conklin@canonical.com>
Cc: Leann Ogasawara <leann.ogasawara@canonical.com>
LKML-Reference: <200906051202.38311.jdelvare@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/reboot.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -169,6 +169,15 @@ static struct dmi_system_id __initdata r
 			DMI_MATCH(DMI_BOARD_NAME, "0KW626"),
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


