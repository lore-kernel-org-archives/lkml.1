Return-Path: <linux-kernel-owner+w=401wt.eu-S932706AbZLEAQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706AbZLEAQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 19:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932672AbZLEAQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 19:16:10 -0500
Received: from adelie.canonical.com ([91.189.90.139]:47769 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613AbZLEAQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 19:16:03 -0500
Subject: [PATCH] x86: ASUS P4S800 reboot quirk
From: Leann Ogasawara <leann.ogasawara@canonical.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       kernel-team <kernel-team@lists.ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 16:15:07 -0800
Message-ID: <1259972107.4629.275.camel@emiko>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Bug reporter noted their system with an ASUS P4S800 motherboard would
hang when rebooting unless reboot=b was specified.  Their dmidecode
didn't contain descriptive System Information for Manufacturer or
Product Name, so I used their Base Board Information to create a reboot
quirk patch.  The bug reporter confirmed this patch resolves the reboot
hang.  Please consider applying.

Thanks,
Leann Ogasawara 

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

>From 303bffef31e1a03f1d87606b15153e176c12b686 Mon Sep 17 00:00:00 2001
From: Leann Ogasawara <leann.ogasawara@canonical.com>
Date: Fri, 4 Dec 2009 15:42:22 -0800
Subject: [PATCH] x86: ASUS P4S800 reboot quirk

BugLink: http://bugs.launchpad.net/bugs/366682

ASUS P4S800 will hang when rebooting unless reboot=b is specified.
Add a quirk to reboot through the bios.

Signed-off-by: Leann Ogasawara <leann.ogasawara@canonical.com>
---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 2b97fc5..1545bc0 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -259,6 +259,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
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
 
-- 
1.5.6.3



