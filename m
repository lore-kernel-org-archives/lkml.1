Return-Path: <linux-kernel-owner+w=401wt.eu-S932693AbZLEA6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693AbZLEA6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 19:58:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757603AbZLEA6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 19:58:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:58579 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757550AbZLEA6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 19:58:08 -0500
Date: Sat, 5 Dec 2009 00:57:51 GMT
From: tip-bot for Leann Ogasawara <leann.ogasawara@canonical.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       leann.ogasawara@canonical.com, stable@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       leann.ogasawara@canonical.com, stable@kernel.org, tglx@linutronix.de
In-Reply-To: <1259972107.4629.275.camel@emiko>
References: <1259972107.4629.275.camel@emiko>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: ASUS P4S800 reboot=bios quirk
Message-ID: <tip-4832ddda2ec4df96ea1eed334ae2dbd65fc1f541@git.kernel.org>
Git-Commit-ID: 4832ddda2ec4df96ea1eed334ae2dbd65fc1f541
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4832ddda2ec4df96ea1eed334ae2dbd65fc1f541
Gitweb:     http://git.kernel.org/tip/4832ddda2ec4df96ea1eed334ae2dbd65fc1f541
Author:     Leann Ogasawara <leann.ogasawara@canonical.com>
AuthorDate: Fri, 4 Dec 2009 15:42:22 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 4 Dec 2009 16:38:59 -0800

x86: ASUS P4S800 reboot=bios quirk

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
Cc: <stable@kernel.org>
---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index f930787..6caf260 100644
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
 
