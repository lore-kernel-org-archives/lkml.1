Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0BSRHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:07:18 -0500
Received: from kroah.org ([198.145.64.141]:57741 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865Ab0BSRBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:01:01 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:49 2010
Message-Id: <20100219163249.791565000@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:30:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [69/93] ahci: add Acer G725 to broken suspend list
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit cedc9bf906dae044443d403371c887affdb44168 upstream.

Acer G725 shares the same suspend problem with the HP laptops which
lose ATA devices on resume.  New firmware which fixes the problem is
already available.  Add G725 with old firmwares to the broken suspend
list.

This problem has been reported in bko#15104.

  http://bugzilla.kernel.org/show_bug.cgi?id=15104

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jani-Matti Hätinen <jani-matti.hatinen@iki.fi>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ahci.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -2868,6 +2868,21 @@ static bool ahci_broken_suspend(struct p
 			},
 			.driver_data = "F.23",	/* cutoff BIOS version */
 		},
+		/*
+		 * Acer eMachines G725 has the same problem.  BIOS
+		 * V1.03 is known to be broken.  V3.04 is known to
+		 * work.  Inbetween, there are V1.06, V2.06 and V3.03
+		 * that we don't have much idea about.  For now,
+		 * blacklist anything older than V3.04.
+		 */
+		{
+			.ident = "G725",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "eMachines"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "eMachines G725"),
+			},
+			.driver_data = "V3.04",	/* cutoff BIOS version */
+		},
 		{ }	/* terminate list */
 	};
 	const struct dmi_system_id *dmi = dmi_first_match(sysids);


