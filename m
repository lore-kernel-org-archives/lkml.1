Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549Ab0AEUGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab0AEUGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527Ab0AEUGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:06:30 -0500
Received: from kroah.org ([198.145.64.141]:50070 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490Ab0AEUG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:28 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:03:03 2010
Message-Id: <20100105200303.404490159@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Keng-Yu Lin <keng-yu.lin@canonical.com>,
       Moiseev Vladimir <cdb@linkycat.com>,
       Alexander Huhlaev <sancheolz@gmail.com>
Subject: [34/39] Input: atkbd - add force relese key quirk for Samsung R59P/R60P/R61P
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Moiseev Vladimir <cdb@linkycat.com>

This patch is not upstream. Since 2.6.32, there is an interface in
/sys for handling the force_release events from userspace, so such
quirk patches are no longer accepted upstream now. But this patch is
valid for version 2.6.31 downwards.

OriginalAuthor:
    Moiseev Vladimir <cdb@linkycat.com>
    Alexander Huhlaev <sancheolz@gmail.com>

BugLink: http://bugs.launchpad.net/bugs/253874

Signed-off-by: Keng-Yu Lin <keng-yu.lin@canonical.com>
Cc: Moiseev Vladimir <cdb@linkycat.com>
Cc: Alexander Huhlaev <sancheolz@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/keyboard/atkbd.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1608,6 +1608,15 @@ static struct dmi_system_id atkbd_dmi_qu
 		.driver_data = atkbd_samsung_forced_release_keys,
 	},
 	{
+		.ident = "Samsung R59P/R60P/R61P",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "R59P/R60P/R61P"),
+		},
+		.callback = atkbd_setup_forced_release,
+		.driver_data = atkbd_samsung_forced_release_keys,
+	},
+	{
 		.ident = "Fujitsu Amilo PA 1510",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),


