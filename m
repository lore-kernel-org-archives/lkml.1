Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbYJNUuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbYJNUuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 16:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYJNUtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 16:49:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47347 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbYJNUtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 16:49:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI suspend: Blacklist HP xw4600 Workstation for old code ordering
Date: Tue, 14 Oct 2008 22:54:06 +0200
User-Agent: KMail/1.9.9
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, John Brown <john.brown3@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810142254.07024.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

ACPI suspend: Blacklist HP xw4600 Workstation for old code ordering

HP xw4600 Workstation is known to require the "old" (ie. compatible
with ACPI 1.0) suspend code ordering, so blacklist it for this
purpose.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Tested-by: John Brown <john.brown3@hp.com>
---
 drivers/acpi/sleep/main.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep/main.c
+++ linux-2.6/drivers/acpi/sleep/main.c
@@ -298,6 +298,14 @@ static struct dmi_system_id __initdata a
 		DMI_MATCH(DMI_BOARD_NAME, "KN9 Series(NF-CK804)"),
 		},
 	},
+	{
+	.callback = init_old_suspend_ordering,
+	.ident = "HP xw4600 Workstation",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP xw4600 Workstation"),
+		},
+	},
 	{},
 };
 #endif /* CONFIG_SUSPEND */
