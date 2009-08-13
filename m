Return-Path: <linux-kernel-owner+w=401wt.eu-S932219AbZHMUI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbZHMUI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbZHMUIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:08:37 -0400
Received: from kroah.org ([198.145.64.141]:41764 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157AbZHMT7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:40 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:29 2009
Message-Id: <20090813195129.754915826@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch 35/74] PM / ACPI: HP G7000 Notebook needs a SCI_EN resume quirk
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=pm-acpi-hp-g7000-notebook-needs-a-sci_en-resume-quirk.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit ec79be26875f6c1468784876cb99192b7f41c7a5 upstream.

This fixes regression (battery "vanishing" on resume) introduced by
commit d0c71fe7ebc180f1b7bc7da1d39a07fc19eec768 ("ACPI Suspend: Enable
ACPI during resume if SCI_EN is not set") and also the issue with
the "screaming" IRQ 9.

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=13745

Reported-and-tested-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Acked-by: Len Brown <lenb@kernel.org>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/sleep.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -397,6 +397,14 @@ static struct dmi_system_id __initdata a
 		},
 	},
 	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Hewlett-Packard HP G7000 Notebook PC",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP G7000 Notebook PC"),
+		},
+	},
+	{
 	.callback = init_old_suspend_ordering,
 	.ident = "Panasonic CF51-2L",
 	.matches = {


