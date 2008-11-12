Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbYKLQ5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbYKLQ5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbYKLQ44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:56:56 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:41751 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbYKLQ4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:56:55 -0500
Date: Wed, 12 Nov 2008 16:56:50 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Nick Warne <nick@ukfsn.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make Dell keyboard repeat quirk apply to a wider range of hardware
Message-ID: <20081112165650.GA15594@srcf.ucam.org>
References: <20081111074702.75e71055@sauron.linicks.net> <20081112131427.1bbc2a7c@palantir.linicks.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112131427.1bbc2a7c@palantir.linicks.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does this work?

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index 22016ca..15479ef 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1460,6 +1460,15 @@ static struct dmi_system_id atkbd_dmi_quirk_table[] __initdata = {
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
