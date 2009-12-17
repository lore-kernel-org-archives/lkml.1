Return-Path: <linux-kernel-owner+w=401wt.eu-S936721AbZLQEpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936721AbZLQEpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763309AbZLQEDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:03:52 -0500
Received: from kroah.org ([198.145.64.141]:55305 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757994AbZLQEDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:03:47 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:45 2009
Message-Id: <20091217035645.678326175@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Leann Ogasawara <leann.ogasawara@canonical.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [021/151] x86: ASUS P4S800 reboot=bios quirk
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Leann Ogasawara <leann.ogasawara@canonical.com>

commit 4832ddda2ec4df96ea1eed334ae2dbd65fc1f541 upstream.

Bug reporter noted their system with an ASUS P4S800 motherboard would
hang when rebooting unless reboot=b was specified.  Their dmidecode
didn't contain descriptive System Information for Manufacturer or
Product Name, so I used their Base Board Information to create a
reboot quirk patch.  The bug reporter confirmed this patch resolves
the reboot hang.

Handle 0x0001, DMI type 1, 25 bytes
System Information
       Manufacturer: System Manufacturer
       Product Name: System Name
       Version: System Version
       Serial Number: SYS-1234567890
       UUID: E0BFCD8B-7948-D911-A953-E486B4EEB67F
       Wake-up Type: Power Switch

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
     Manufacturer: ASUSTeK Computer INC.
     Product Name: P4S800
     Version: REV 1.xx
     Serial Number: xxxxxxxxxxx

BugLink: http://bugs.launchpad.net/bugs/366682

ASUS P4S800 will hang when rebooting unless reboot=b is specified.
Add a quirk to reboot through the bios.

Signed-off-by: Leann Ogasawara <leann.ogasawara@canonical.com>
LKML-Reference: <1259972107.4629.275.camel@emiko>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -259,6 +259,14 @@ static struct dmi_system_id __initdata r
 			DMI_MATCH(DMI_PRODUCT_NAME, "SBC-FITPC2"),
 		},
 	},
+	{       /* Handle problems with rebooting on ASUS P4S800 */
+		.callback = set_bios_reboot,
+		.ident = "ASUS P4S800",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "P4S800"),
+		},
+	},
 	{ }
 };
 


