Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbYL2O3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbYL2O3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 09:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYL2O3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 09:29:06 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40900 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbYL2O3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 09:29:05 -0500
Date: Mon, 29 Dec 2008 14:29:02 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: dtor@mail.ru
Cc: Nick Warne <nick@ukfsn.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [PATCH] Input: atkbd - broaden the Dell DMI signatures
Message-ID: <20081229142902.GC31266@srcf.ucam.org>
References: <20081111074702.75e71055@sauron.linicks.net> <20081112131427.1bbc2a7c@palantir.linicks.net> <20081112165650.GA15594@srcf.ucam.org> <20081229113621.1a64caea@sauron.linicks.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229113621.1a64caea@sauron.linicks.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Dells need the dell input quirk applied but have a different vendor
string in their DMI tables. Add an extra entry to cover these machines as
well.
    
Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

Dmitry, any chance of getting this queued for .29? Probably suitable for 
-stable as well.

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index 379b7ff..d48de0c 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1476,6 +1476,15 @@ static struct dmi_system_id atkbd_dmi_quirk_table[] __initdata = {
 		.driver_data = atkbd_dell_laptop_keymap_fixup,
 	},
 	{
+		.ident = "Dell Laptop",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "8"), /* Portable */
+		},
+		.callback = atkbd_setup_fixup,
+		.driver_data = atkbd_dell_laptop_keymap_fixup,
+	},
+	{
 		.ident = "HP 2133",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),

-- 
Matthew Garrett | mjg59@srcf.ucam.org
